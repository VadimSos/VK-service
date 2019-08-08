//
//  ProfileParser.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/7/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProfileParser: Parser<ProfileModel> {
	override func  parsing(data: Data) -> ProfileModel? {
		let resultName = ProfileModel(name: "")
		do {
			let json = try JSON(data: data)
			let response = json["response"].dictionaryValue
			for eachKey in response {
				if eachKey.key == "first_name" {
					guard let name = response["first_name"]?.stringValue else {return nil}
					resultName.name = name
					break
				}
			}
//			guard let name = response["first_name"]?.stringValue else {return nil}
//
//			resultName.name = name
			return resultName
		} catch {
			fatalError("error")
		}
	}
}
