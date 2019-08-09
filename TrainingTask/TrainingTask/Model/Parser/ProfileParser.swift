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
	override func  parsing(data: Data, completion: @escaping (ProfileModel?, ValidationError?) -> Void) -> ProfileModel? {

//		func performCompletion(result: ProfileModel?, error: ValidationError?) {
//			completion(result, error)
//		}

		let resultName = ProfileModel(name: "")
		do {
			let json = try JSON(data: data)
			let response = json["response"].dictionaryValue
			for eachKey in response {
				if eachKey.key == "first_name" {
					guard let name = response["first_name"]?.stringValue else {
						completion(nil, .parsingError)
						return nil
					}
					resultName.name = name
					break
				}
			}
			completion(resultName, nil)
			return resultName
		} catch {
			fatalError("error")
		}
	}
}
