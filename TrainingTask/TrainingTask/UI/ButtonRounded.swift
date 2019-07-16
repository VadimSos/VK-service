//
//  ButtonRounded.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/16/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit

class ButtonRounded: UIButton {

    override func layoutSubviews() {
        super .layoutSubviews()
        layer.cornerRadius = frame.height * 0.2
    }
}
