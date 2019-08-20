//
//  RouteModel.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/20/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation

class PostModel {

	var name: String
	var image: URL
	var text: String

	init(name: String, image: URL, text: String) {
		self.name = name
		self.image = image
		self.text = text
	}
}
