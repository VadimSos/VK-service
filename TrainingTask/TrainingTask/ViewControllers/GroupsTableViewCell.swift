//
//  GroupsTableViewCell.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 7/20/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {

	// MARK: - Outlets

	@IBOutlet weak var groupsImage: UIImageView!
	@IBOutlet weak var groupsName: UILabel!
	@IBOutlet weak var groupsType: UILabel!

	func updateTableOfGroups(with items: PostModelProtocol) {
		groupsName.text = items.postGroupName()
	}

}
