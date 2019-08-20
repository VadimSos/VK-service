//
//  GroupModel.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/6/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import UIKit

class GroupModel {

	var pGroupName: String
	var pGroupImage: URL

	init(name: String, image: URL) {
		pGroupName = name
		pGroupImage = image
	}
}
