//
//  PostsPostProtocol.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/22/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import UIKit

protocol PostsPostProtocol {
    func postUserName() -> String
    func postUserImage() -> UIImage
    func postUserText() -> String
}
