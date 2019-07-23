//
//  PostsPostModel.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/22/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import UIKit

struct PostsPostModel: PostsPostProtocol {
    
    var pUserName: String
    var pUserImage: UIImage
    var pUserText: String
    
    func postUserName() -> String {
        return self.pUserName
    }
    
    func postUserImage() -> UIImage {
        return self.pUserImage
    }
    
    func postUserText() -> String {
        return self.pUserText
    }
}
