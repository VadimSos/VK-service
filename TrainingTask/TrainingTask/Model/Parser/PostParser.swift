//
//  PostParser.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/20/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import SwiftyJSON

class PostParser: Parser<[PostModel]> {
	override func  parsing(data: Data, completion: @escaping ([PostModel]?, ValidationError?) -> Void) -> [PostModel]? {

		var postArray: [PostModel] = []
		do {
			let json = try JSON(data: data)
			let response = json["response"].dictionaryValue
			guard let profiles = response["profiles"]?.arrayValue,
				let items = response["items"]?.arrayValue,
				let totalPosts = response["count"]?.intValue else {
					completion(nil, .parsingError)
					return nil
			}
//			self.totalCountOfPosts = totalPosts
//			self.userOffsetAmount += 20

			for eachPost in items {
				guard let postText = eachPost["text"].string,
					let fromID = eachPost["from_id"].int else {
						completion(nil, .parsingError)
						return nil
				}

				for eachProfile in profiles {
					guard let id = eachProfile["id"].int,
						let name = eachProfile["first_name"].string,
						let urlImage = eachProfile["photo_100"].url else {
							completion(nil, .parsingError)
							return nil
					}

					//find proper user info for current post item
//					if fromID == id {
//						let urlImageView = UIImageView()
//						urlImageView.load(url: urlImage) {
//
//							self.postTableView.reloadData()
//						}
//					}
					postArray.append(PostModel(name: name, image: urlImage, text: postText))
				}
			}
			completion(postArray, nil)
			return postArray
		} catch {
			completion(nil, .jsonDataError)
			return nil
		}
	}
}
