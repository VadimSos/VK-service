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

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        OAuthURLRequest(clientID: "client_id=6191231&", scope: "scope=4096&", redirectURL: "redirect_uri=https://oauth.vk.com&", display: "display=page&", version: "v=5.101&", responseToken: "response_type=token")
    }

    func OAuthURLRequest(clientID: String, scope: String, redirectURL: String, display: String, version: String, responseToken: String) {
        let api = "https://oauth.vk.com/authorize?"
        let myURL = URL(string: api + clientID + scope + redirectURL + display + version + responseToken)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
