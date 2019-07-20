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

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
