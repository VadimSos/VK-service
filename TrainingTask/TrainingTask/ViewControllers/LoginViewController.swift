//
//  ViewController.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/15/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit
import p2_OAuth2
import Alamofire

class LoginViewController: UIViewController {

    fileprivate var alamofireManager: SessionManager?

    var loader: OAuth2DataLoader?

    var oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "7059368",
        "client_secret": "WlZlgKtJLW4msmkPTSUd",
        "authorize_uri": "http://oauth.vk.com/authorize",
        "redirect_uri": "trainingtask://",   // register your own "trainingtask" scheme in Info.plist
        "v": "5.74",
        "scope": "offline",
        ] as OAuth2JSON)

    // MARK: - Actiones

    @IBAction func VKAuthorization(_ sender: UIButton) {
        if oauth2.isAuthorizing {
            oauth2.abortAuthorization()
            return
        }

        sender.setTitle("Authorizing...", for: UIControl.State.normal)

        oauth2.authConfig.authorizeEmbedded = false        // the default
        let loader = OAuth2DataLoader(oauth2: oauth2)
        self.loader = loader

        loader.perform(request: userAuthentication) { response in
            do {
                let json = try response.responseJSON()
                print("\(json)")
            } catch let error {
                print("\(error)")
            }
        }
    }

    // MARK: - Actions

    var userAuthentication: URLRequest {
        var request = URLRequest(url: URL(string: "https://api.github.com/user")!)
//        request.setValue("user_id=210700286&v=5.52", forHTTPHeaderField: "Accept")
        return request
    }
}

class OAuth2RetryHandler: RequestRetrier, RequestAdapter {

    let loader: OAuth2DataLoader

    init(oauth2: OAuth2) {
        loader = OAuth2DataLoader(oauth2: oauth2)
    }

    /// Intercept 401 and do an OAuth2 authorization.
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse, 401 == response.statusCode, let req = request.request {
            var dataRequest = OAuth2DataRequest(request: req, callback: { _ in })
            dataRequest.context = completion
            loader.enqueue(request: dataRequest)
            loader.attemptToAuthorize() { authParams, error in
                self.loader.dequeueAndApply() { req in
                    if let comp = req.context as? RequestRetryCompletion {
                        comp(nil != authParams, 0.0)
                    }
                }
            }
        } else {
            completion(false, 0.0)   // not a 401, not our problem
        }
    }

    /// Sign the request with the access token.
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard nil != loader.oauth2.accessToken else {
            return urlRequest
        }
        return try urlRequest.signed(with: loader.oauth2)
    }
}
