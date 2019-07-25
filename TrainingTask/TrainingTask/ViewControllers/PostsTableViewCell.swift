//
//  PostsTableViewCell.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/22/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postUserNameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!

    func updateTableOfPosts(with item: PostsPostProtocol) {
        postImage.image = item.postUserImage()
        postUserNameLabel.text = item.postUserName()
        postTextLabel.text = item.postUserText()
    }

    func updateRealmData(image: Data, name: String, text: String) {
        postImage.image = UIImage(data: image)
        postUserNameLabel.text = name
        postTextLabel.text = text
    }
}
