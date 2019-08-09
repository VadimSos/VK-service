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

//		guard let myURL = APIrequests().getProfileNameURL() else {return}
//        AF.request(myURL).responseData { response in
//            if let data = response.data {
//                do {
//                    let json = try JSON(data: data)
//                    let response = json["response"].dictionaryValue
//                    let name = response["first_name"]?.stringValue
//                    self.accountName.text = name
//                } catch {
//                    print(error)
//                }
//            }
//        }
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

//		APIrequests().request(route: ProfileAvatarRoute(), parser: ProfileAvatarParser()) { result, error  in
//			if error != nil {
//				fatalError("\(error?.errorDescription ?? "Network error")")
//			} else {
//				let image = UIImageView()
//				image.load(url: result!.image) {
//					self.avatarImage.image = image.image
//				}
//			}
//		}
//		guard let myURL = APIrequests().getProfileImageURL() else {return}
//
//        AF.request(myURL).responseData { response in
//            if let data = response.data {
//                do {
//                    let json = try JSON(data: data)
//                    let response = json["response"].dictionaryValue
//                    guard let items = response["items"]?.arrayValue else {return}
//                    guard let item = items.last?.dictionaryValue else {return}
//                    let sizes = item["sizes"]!.arrayValue
//                    guard let photo = sizes.last!["url"].url else {return}
//
//                    let image = UIImageView()
//                    image.load(url: photo) {
//                        self.avatarImage.image = image.image
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }
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
