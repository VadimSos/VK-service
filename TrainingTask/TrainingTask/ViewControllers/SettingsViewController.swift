//
//  SettingsViewController.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/18/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SettingsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var accountName: UILabel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileImage()
		getProfileName()
    }

	func getProfileName() {
		APIrequests().request(route: ProfileRoute(), parser: ProfileParser()) { result, error  in
			if error != nil {
				UIAlertController.showError(message: (error?.errorDescription)!, from: self)
			} else {
				self.accountName.text = result?.name
			}
		}
    }

    func getProfileImage() {
		APIrequests().request(route: ProfileAvatarRoute(), parser: ProfileAvatarParser()) { result, error in
			if error != nil {
				UIAlertController.showError(message: (error?.errorDescription)!, from: self)
			} else {
				guard let result = result else {return}
				let image = UIImageView()
				image.load(url: result.image) {
					self.avatarImage.image = image.image
				}
			}
		}
    }

    @IBAction func logoutButtonDidTab(_ sender: UIButton) {
        KeychainOperations().deleteToken()

		guard let logoutURL = APIrequests().logoutURL() else {return}

        AF.request(logoutURL).responseData { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
        }

        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            for cookie in cookies {
                storage.deleteCookie(cookie)
            }
        }

        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
