//
//  UIAlertController.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/30/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {

    static func showError(message: String, from viewController: UIViewController, with style: UIAlertAction.Style = .default) {
        let alert = UIAlertController(title: NSLocalizedString("Warning!", comment: ""),
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                      style: style,
                                      handler: nil))

        viewController.present(alert, animated: true, completion: nil)
    }
}
