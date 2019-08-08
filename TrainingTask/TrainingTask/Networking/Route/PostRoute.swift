//
//  PostRoute.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/6/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation

//class PostRoute: Route {
//
//	override init() {
//		super.init()
//		guard let token = compileToken() else {return}
//		self.url = pBaseURL
//		self.method = "method/wall.get"
//		self.type = "GET"
//		self.param = ["extended": 1, "count": pCount, "offset": 0, "v": pApiVersion, token.tokenKey: token.token]
////		self.decoder = Parser()
//	}
//
////	func getGroupsURL() -> URL? {
////		//combine parameters in String
////		let dictString = ((param.compactMap ({ (key, value) -> String in
////			return "\(key)=\(value)"
////		}) as Array).joined(separator: "&") as String)
////
////		let myURL = URL(string: url + method + "?" + dictString)
////		return myURL
////	}
//}
