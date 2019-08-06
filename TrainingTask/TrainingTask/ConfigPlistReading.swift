//
//  PlistReading.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/2/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation

class ConfigPlistReading {

	func getPlist(key: String) -> Any? {
		guard let plistPath = Bundle.main.path(forResource: "Config", ofType: "plist"),
			let dict = NSDictionary(contentsOfFile: plistPath),
			let value = dict.object(forKey: key) else {return nil}
		return value as Any
	}

}
