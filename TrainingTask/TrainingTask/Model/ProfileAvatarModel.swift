//
//  ProfileModelAvatar.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 8/8/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import UIKit

class ProfileAvatarModel {

	var image: URL

	init(image: URL) {
		self.image = image
	}

	func postAvatar() -> URL {
		return self.image
	}
}
