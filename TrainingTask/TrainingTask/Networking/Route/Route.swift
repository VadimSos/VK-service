//
//  Route.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/5/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation

class Route<T> {

	var url: String
	var method: String
	var type: String
	var param: [String: Any]
	var decoder: Parser<T>

	init() {
		url = ""
		method = ""
		type = ""
		param = [:]
		decoder = Parser<T>()
	}

	func getURL() -> URL? {
		//combine parameters in String
		let dictString = ((param.compactMap ({ (key, value) -> String in
			return "\(key)=\(value)"
		}) as Array).joined(separator: "&") as String)

		let myURL = URL(string: url + method + "?" + dictString)
		return myURL
	}

	//prepare token to the correct format
	func compileToken() -> (tokenKey: String, token: Any)? {
		let resultValue = ConfigPlistResult.shared
		let accessTokenKey = resultValue.stringValue(key: .tokenKey)
		guard let token = KeychainOperations().getToken() else {return nil}
		let tokenKey = "\(accessTokenKey)"
		let finalToken = (tokenKey, token) as (String, Any)
		return finalToken
	}
}
