//
//  ProfileModel.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/7/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import UIKit

class ProfileModel {

	var name: String

	init(name: String) {
		self.name = name
	}

	func postName() -> String {
		return self.name
	}
}
