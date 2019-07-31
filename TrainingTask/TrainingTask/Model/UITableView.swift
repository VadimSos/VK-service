//
//  UITableView.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/31/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func reloadSectionWithouAnimation(section: Int) {
        UIView.performWithoutAnimation {
            let offset = self.contentOffset
            self.reloadSections(IndexSet(integer: section), with: .none)
            self.contentOffset = offset
        }
    }
//    func reloadWithoutAnimation() {
//        let lastScrollOffset = contentOffset
//        beginUpdates()
//        endUpdates()
//        layer.removeAllAnimations()
//        setContentOffset(lastScrollOffset, animated: false)
//    }
}
