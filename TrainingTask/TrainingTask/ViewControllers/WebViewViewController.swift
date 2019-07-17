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

        componentsOfURLRequest()
    }

    func componentsOfURLRequest() {
        let api = "https://oauth.vk.com/authorize?"
        let clientID = "client_id=6191231&"
        let scope = "scope=4096&"
        let redirectURL = "redirect_uri=https://oauth.vk.com&"
        let display = "display=page&"
        let version = "v=5.101&"
        let responseToken = "response_type=token"
        let myURL = URL(string: api + clientID + scope + redirectURL + display + version + responseToken)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
