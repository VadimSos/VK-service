//
//  ViewController.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/15/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func loginButtonDidTab(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() {
            performSegue(withIdentifier: "loginSuccess", sender: nil)
        } else {
            UIAlertController.showError(message: NSLocalizedString("No internet", comment: ""), from: self)
        }
    }
}
