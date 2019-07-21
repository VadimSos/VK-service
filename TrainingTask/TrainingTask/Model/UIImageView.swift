//
//  UIImageView.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 7/21/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
	func load(url: URL) {
		if let data = try? Data(contentsOf: url) {
			if let image = UIImage(data: data) {
				self.image = image
			}
		}
	}
}

//extension UIImageView {
//	func load(url: URL) {
//		DispatchQueue.global().async { [weak self] in
//			if let data = try? Data(contentsOf: url) {
//				if let image = UIImage(data: data) {
//					DispatchQueue.main.async {
//						self?.image = image
//					}
//				}
//			}
//		}
//	}
//}
