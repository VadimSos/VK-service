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

        let myURL = URL(string: "https://oauth.vk.com/authorize?client_id=6191231&scope=4096&redirect_uri=https://oauth.vk.com&display=page&v=5.101&response_type=token")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
