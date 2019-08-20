//
//  LogoutRoute.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/20/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import Alamofire

class LogoutRoute: Route<TokenModel> {

	let result = ConfigPlistResult.shared

	override init() {
		super.init()
		self.url = result.baseURL
		self.method = "oauth/logout"
		self.type = HTTPMethod.get.rawValue
		self.param = ["client_id": result.clientID]
	}
}
