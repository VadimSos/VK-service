//
//  PostsModel.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/25/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import RealmSwift

class PostsList: Object {

    @objc dynamic var image = Data()
    @objc dynamic var name = ""
    @objc dynamic var text = ""
}
