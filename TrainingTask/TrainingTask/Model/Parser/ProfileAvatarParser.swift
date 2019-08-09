//
//  ProfileAvatarParser.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/8/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ProfileAvatarParser: Parser<ProfileAvatarModel> {
	override func  parsing(data: Data, completion: @escaping (ProfileAvatarModel?, ValidationError?) -> Void) -> ProfileAvatarModel? {

		func performCompletion(result: ProfileAvatarModel?, error: ValidationError?) {
			completion(result, error)
		}

		do {
			let json = try JSON(data: data)
			let response = json["response"].dictionaryValue
			guard let items = response["items"]?.arrayValue,
				let item = items.last?.dictionaryValue,
				let sizes = item["sizes"]?.arrayValue,
				let photo = sizes.last?["url"].url else {
				performCompletion(result: nil, error: .parsingError)
				return nil
			}
			let resultImage = ProfileAvatarModel(image: photo)

			performCompletion(result: resultImage, error: nil)
			return resultImage
		} catch {
			fatalError("error")
		}
	}
}
