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

    private let redirectURL = "https://oauth.vk.com/blank.html"

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
        let clientID = "client_id=7062888&"
        let display = "display=page&"
        let version = "v=5.101&"
        let responseToken = "response_type=token&"
        let revoke = "revoke=1"
        let myURL = URL(string: api + clientID + "redirect_uri=" + redirectURL + "&" + display + version + responseToken + revoke)
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
                if parseURLResult!.count <= 3 {
//					if parseURLResult?.keys.first?.first == "e" {
//                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
//                        return decisionHandler(.cancel)
//                    }
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
