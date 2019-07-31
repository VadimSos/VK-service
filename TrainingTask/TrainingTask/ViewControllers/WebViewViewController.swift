//
//  WebViewViewController.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/17/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit
import WebKit
import Locksmith

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
        let scope = "scope=8192&"
        let display = "display=page&"
        let version = "v=5.101&"
        let responseToken = "response_type=token&"
        let revoke = "revoke=1"
        let myURL = URL(string: api + clientID + scope + "redirect_uri=" + redirectURL + "&" + display + version + responseToken + revoke)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true //move backward or forward in web browsing
    }
}

    // MARK: - handle response URL

extension WebViewViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        let requestURL = navigationResponse.response.url?.absoluteString
        guard let newString = (requestURL?.replacingOccurrences(of: "#", with: "?")) else {return}
        let resultURL = URL(string: newString)

        if requestURL != nil {
            let stringURL = (resultURL?.absoluteString)!

            if validateResponseUrl(stringURL: stringURL) {
                let parseURLResult = resultURL?.params(url: resultURL!)

                //open tab bar controller
                if parseURLResult!.count <= 3 {

                    //save token to Locksmith
                    guard let index = parseURLResult?.index(forKey: "access_token") else {
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        return decisionHandler(.cancel)
                    }
                    if parseURLResult != nil {
                        let tokenDict: [String: String] = [(parseURLResult![index].key): parseURLResult![index].value as? String ?? "error"]
                        if Locksmith.loadDataForUserAccount(userAccount: "VK") != nil {
                            do {
                                try Locksmith.updateData(data: tokenDict, forUserAccount: "VK")
                            } catch {
                                print(error)
                            }
                        } else {
                            do {
                                try Locksmith.saveData(data: tokenDict, forUserAccount: "VK")
                            } catch {
                                print(error)
                            }
                        }
                    }

                    //if cancel permissions in VK
                    if parseURLResult?.keys.first?.description == "error_description" ||
                        parseURLResult?.keys.first?.description == "error" ||
                        parseURLResult?.keys.first?.description == "error_reason" {

                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        return decisionHandler(.cancel)
                    }
                    performSegue(withIdentifier: "toTabBar", sender: nil)
                }
                return decisionHandler(.allow)
            }
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            return decisionHandler(.cancel)
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        decisionHandler(.cancel)
    }

    func validateResponseUrl (stringURL: String) -> Bool {
        var result = false
        if stringURL.hasPrefix("\(redirectURL)") || stringURL.hasPrefix("https://oauth.vk.com/authorize") {
            result = true
        }
        return result
    }
}
