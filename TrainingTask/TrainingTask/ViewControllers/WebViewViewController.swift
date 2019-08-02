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

    var webView: WKWebView!

    // MARK: - Lifecycle

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        urlRequest()
    }

    // MARL: - AOuth2 request

    func urlRequest() {
        guard let finalURL = APIrequests().authorizeURL() else {return}
        let myRequest = URLRequest(url: finalURL)
        webView.load(myRequest)
    }
}

    // MARK: - WebView Navigation request/response

extension WebViewViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {

        guard let requestURL = navigationResponse.response.url?.absoluteString,
            let resultURL = APIresponse().prepareResponseURLToCorrectFormat(url: requestURL) else {
            returnToRootViewController()
            return decisionHandler(.cancel)
        }

		if APIresponse().checkURLValidation(responseURL: resultURL) {
			let parseURLResult = resultURL.params(url: resultURL)

			//3 - count of key/value pairs in response from "allow privilage" and "Cancel"
			if parseURLResult.count <= 3 {

				guard let index = parseURLResult.index(forKey: "access_token") else {
					returnToRootViewController()
					return decisionHandler(.cancel)
				}
				guard let tokenValue = parseURLResult[index].value as? String else {
					returnToRootViewController()
					return decisionHandler(.cancel)
				}
					KeychainOperations().saveToken(value: tokenValue)

				performSegue(withIdentifier: "toTabBar", sender: nil)
			}
			return decisionHandler(.allow)
		}
        returnToRootViewController()
        decisionHandler(.cancel)
    }

    func returnToRootViewController() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
