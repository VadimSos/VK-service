//
//  ProfileInfo.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/7/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import Alamofire

class ProfileRoute: Route<ProfileModel> {

	let result = ConfigPlistResult.shared

	override init() {
		super.init()
		guard let token = compileToken() else {return}
		self.url = result.baseURL
		self.method = "method/account.getProfileInfo"
		self.type = HTTPMethod.get.rawValue
		self.param = ["v": result.apiVersion, token.tokenKey: token.token]
		self.decoder = ProfileParser()
	}
}
