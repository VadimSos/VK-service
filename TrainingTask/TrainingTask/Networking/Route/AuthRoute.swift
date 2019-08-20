//
//  AuthRoute.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/20/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import Alamofire

class AuthRoute: Route<TokenModel> {

	let result = ConfigPlistResult.shared

	override init() {
		super.init()
		self.url = result.authorizationURL
		self.method = "authorize"
		self.type = HTTPMethod.get.rawValue
		self.param = ["client_id": result.clientID,
					  "scope": result.scope,
					  "display": "page",
					  "v": result.apiVersion,
					  "response_type": "token",
					  "revoke": 1,
					  "redirect_uri": result.redirectURL]
	}
}
