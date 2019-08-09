//
//  GroupsTableViewCell.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 7/20/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit
import SDWebImage

class GroupsTableViewCell: UITableViewCell {

	// MARK: - Outlets

	@IBOutlet weak var groupsImage: UIImageView!
	@IBOutlet weak var groupsName: UILabel!

    func updateNameInRealm(name: String, image: Data) {
        groupsName.text = name
        groupsImage.image = UIImage(data: image)
    }

	func updateGroups(items: GroupModel) {
		groupsName.text = items.pGroupName
		let urlImageView = UIImageView()
		urlImageView.load(url: items.pGroupImage) {
			self.groupsImage.image = urlImageView.image
		}
	}
}
