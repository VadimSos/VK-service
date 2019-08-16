//
//  ProfileAvatarRoute.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/8/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import Alamofire

class ProfileAvatarRoute: Route<ProfileAvatarModel> {

	let result = ConfigPlistResult.shared

	override init() {
		super.init()
		guard let token = compileToken() else {return}
		self.url = result.baseURL
		self.method = "method/photos.getProfile"
		self.type = HTTPMethod.get.rawValue
		self.param = ["extended": 0, "rev": 0, "photo_sizes": 0, "v": result.apiVersion, token.tokenKey: token.token]
		self.decoder = ProfileAvatarParser()
	}
}
