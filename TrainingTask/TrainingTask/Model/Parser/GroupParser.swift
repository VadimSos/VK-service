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
	override func  parsing(data: Data) -> [GroupModel] {
		var groupArray: [GroupModel] = []
		do {
			let json = try JSON(data: data)
			let response = json["response"].dictionaryValue
			let items = (response["items"]?.arrayValue)!

			for eachItems in items {
				let name = eachItems["name"].string!
				let urlImage = eachItems["photo_50"].url!

				let urlImageView = UIImageView()
				urlImageView.load(url: urlImage) {
				}
				groupArray.append(GroupModel(name: name, image: urlImageView.image!))
			}
			return groupArray
		} catch {
			fatalError("error")
		}
	}
}
