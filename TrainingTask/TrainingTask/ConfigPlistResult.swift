//
//  ConfigPlistResult.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/3/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation

class ConfigPlistResult {

	static let shared = ConfigPlistResult()

	private init() {}

	var result = ConfigPlistReading()

	lazy var baseURL = stringValue(key: .baseURL)
	lazy var authorizationURL = stringValue(key: .authURL)
	lazy var redirectURL = stringValue(key: .redirectURL)
	lazy var apiVersion = intValue(key: .apiVersion)
	lazy var clientID = intValue(key: .clientID)
	lazy var count = intValue(key: .count)
	lazy var scope = intValue(key: .permission)
	lazy var accessTokenKey = stringValue(key: .tokenKey)

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
	case permission = "Access Permissions" //73728 = wall + forever token
	case tokenKey = "Token Key"
}
