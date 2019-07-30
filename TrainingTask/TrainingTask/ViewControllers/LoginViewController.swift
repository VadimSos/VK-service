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
            showReachabilityAlert()
        }
    }

    func showReachabilityAlert() {
            let alert = UIAlertController(title: "Warning!", message: "Internet Connection not Available!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
}
