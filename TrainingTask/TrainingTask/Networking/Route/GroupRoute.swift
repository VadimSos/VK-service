//
//  GroupRoute.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/5/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import Alamofire

class GroupRoute: Route<[GroupModel]> {

	let result = ConfigPlistResult.shared

	override init() {
		super.init()
		guard let token = compileToken() else {return}
		self.url = result.baseURL
		self.method = "method/groups.get"
		self.type = HTTPMethod.get.rawValue
		self.param = ["extended": 1, "count": result.count, "offset": 0, "v": result.apiVersion, token.tokenKey: token.token]
		self.decoder = GroupParser()
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
