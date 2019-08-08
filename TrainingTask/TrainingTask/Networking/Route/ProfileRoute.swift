//
//  ProfileInfo.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/7/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import Alamofire

class ProfileRoute: Route<ProfileParser> {

	override init() {
		super.init()
		guard let token = compileToken() else {return}
		self.url = pBaseURL
		self.method = "method/account.getProfileInfo"
		self.type = HTTPMethod.get.rawValue
		self.param = ["v": pApiVersion, token.tokenKey: token.token]
		self.decoder = Parser<ProfileParser>()
	}
}
