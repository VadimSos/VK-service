//
//  WebViewViewController.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/17/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {

    private let redirectURL = "https://oauth.vk.com"

    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        urlRequest()
    }

    //create, send URL to VK
    func urlRequest() {
        let api = "https://oauth.vk.com/authorize?"
        let clientID = "client_id=6191231&"
        let scope = "scope=4096&"
        let display = "display=page&"
        let version = "v=5.101&"
        let responseToken = "response_type=token"
        let myURL = URL(string: api + clientID + scope + "redirect_uri=" + redirectURL + "&" + display + version + responseToken)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true //move backward or forward in web browsing
    }
}

    // MARK: - handle response URL

extension WebViewViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let requestURL = navigationResponse.response.url

        if requestURL != nil {
            let stringURL = requestURL!.absoluteString

            if validateResponseUrl(stringURL: stringURL) {
                let parseURLResult = requestURL?.params(url: requestURL!)

                //open tab bar controller
                if parseURLResult!.count <= 4 {
                    performSegue(withIdentifier: "toTabBat", sender: nil)
                }
                return decisionHandler(.allow)
            }
            return decisionHandler(.allow)
        }
        decisionHandler(.cancel)
    }

    func validateResponseUrl (stringURL: String) -> Bool {

        var result = false
        if stringURL.hasPrefix("\(redirectURL)") {
            result = true
        }
        return result
    }
}
