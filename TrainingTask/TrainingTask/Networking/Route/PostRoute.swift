//
//  PostRoute.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/6/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import Alamofire

class PostRoute: Route<[PostModel]> {

	let result = ConfigPlistResult.shared

	override init() {
		super.init()
		guard let token = compileToken() else {return}
		self.url = result.baseURL
		self.method = "method/wall.get"
		self.type = HTTPMethod.get.rawValue
		self.param = ["extended": 1, "count": result.count, "offset": 0, "v": result.apiVersion, token.tokenKey: token.token]
		self.decoder = PostParser()
	}

//	func getGroupsURL() -> URL? {
//		//combine parameters in String
//		let dictString = ((param.compactMap ({ (key, value) -> String in
//			return "\(key)=\(value)"
//		}) as Array).joined(separator: "&") as String)
//
//		let myURL = URL(string: url + method + "?" + dictString)
//		return myURL
//	}
}
