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

	override init() {
		super.init()
		guard let token = compileToken() else {return}
		self.url = pBaseURL
		self.method = "method/photos.getProfile"
		self.type = HTTPMethod.get.rawValue
		self.param = ["extended": 0, "rev": 0, "photo_sizes": 0, "v": pApiVersion, token.tokenKey: token.token]
		self.decoder = ProfileAvatarParser()
	}
}
