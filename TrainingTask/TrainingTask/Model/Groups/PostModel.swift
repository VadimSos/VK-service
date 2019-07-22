//
//  PostModel.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 7/21/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import UIKit

struct PostModel: GroupsPostProtocol {

	var pGroupName: String
	var pGroupImage: UIImage

	func postGroupName() -> String {
		return self.pGroupName
	}

	func postImage() -> UIImage {
		return self.pGroupImage
	}
}
