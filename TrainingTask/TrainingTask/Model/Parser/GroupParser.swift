//
//  GroupParser.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/6/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import SwiftyJSON

class GroupParser: Parser<[GroupModel]> {
	override func  parsing(data: Data, completion: @escaping ([GroupModel]?, ValidationError?) -> Void) -> [GroupModel]? {

		var groupArray: [GroupModel] = []
		do {
			let json = try JSON(data: data)
			let response = json["response"].dictionaryValue
			guard let items = response["items"]?.arrayValue else {
				completion(nil, .parsingError)
				return nil
			}

			for eachItems in items {
				guard let name = eachItems["name"].string,
					let urlImage = eachItems["photo_50"].url else {
					completion(nil, .parsingError)
					return nil
				}

				groupArray.append(GroupModel(name: name, image: urlImage))
			}

			completion(groupArray, nil)
			return groupArray
		} catch {
			fatalError("error")
		}
	}
}
