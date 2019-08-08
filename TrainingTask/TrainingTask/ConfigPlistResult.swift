//
//  ConfigPlistResult.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/3/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation

class ConfigPlistResult {
	var result = ConfigPlistReading()

	func intValue(key: Key) -> Double {
		let intResult = result.getPlist(key: key.rawValue)
		return intResult as? Double ?? 0 //TODo: change default value to correct nil checking
	}

	func stringValue(key: Key) -> String {
		let stringResult = result.getPlist(key: key.rawValue)
		return stringResult as? String ?? "" //TODo: change default value to correct nil checking
	}
}

enum Key: String {
	case baseURL = "Base URL"
	case authURL = "Authorization URL"
	case redirectURL = "Redirect URL"
	case apiVersion = "API version"
	case clientID = "Client ID"
	case count = "Count of Posts/Groups"
	case permission = "Access Permissions"
	case tokenKey = "Token Key"
}
