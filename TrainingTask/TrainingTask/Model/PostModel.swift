//
//  PostModel.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 7/21/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation

struct PostModel: PostModelProtocol {

	var pGroupName: String

	func postGroupName() -> String {
		return self.pGroupName
	}
}
