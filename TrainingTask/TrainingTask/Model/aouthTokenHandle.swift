//
//  aouthTokenHandle.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 8/1/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import KeychainSwift

class Keychain {
	enum Key: String {
		case token
	}

	func save(key: String, value: String) {
		KeychainSwift().set(value, forKey: key)
	}
	func get(key: String) -> String? {
		guard let getData = KeychainSwift().get(key) else {return nil}
		return getData
	}
	func delete(key: String) {
		KeychainSwift().delete(key)
	}
}

class KeychainOperations: Keychain {

	func saveToken(value: String) {
		Keychain().save(key: Key.token.rawValue, value: value)
	}

	func getToken() -> String? {
		guard let getToken = Keychain().get(key: Key.token.rawValue) else {return nil}
		return getToken
	}

	func deleteToken() {
		Keychain().delete(key: Key.token.rawValue)
	}
}
