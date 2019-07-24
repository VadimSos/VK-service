//
//  SettingsViewController.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/18/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit
import Locksmith
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

    //create, send URL to VK
    func getProfileName() {
        let api = "https://api.vk.com/method/account.getProfileInfo?"
        let version = "v=5.101&"
        let requestToken = compileToken()
        guard let myURL = URL(string: api + version + requestToken) else {return}

        //send request and operate response
        AF.request(myURL).responseData { response in

            if let data = response.data {
                do {
                    let json = try JSON(data: data)
                    //take dictionary from JSON
                    let response = json["response"].dictionaryValue
                    //take value from dictionary
                    let name = response["first_name"]?.stringValue
                    self.accountName.text = name
                } catch {
                    print(error)
                }
            }
        }
    }

    //create, send URL to VK
    func getProfileImage() {
        let api = "https://api.vk.com/method/photos.getProfile?"
        let reverse = "rev=0&"
        let extended = "extended=0&"
        let photoSizes = "photo_sizes=0&"
        let version = "v=5.101&"
        let requestToken = compileToken()
        guard let myURL = URL(string: api + reverse + extended + photoSizes + version + requestToken) else {return}

        //send request and operate response
        AF.request(myURL).responseData { response in

            if let data = response.data {
                do {
                    let json = try JSON(data: data)
                    //take dictionary from JSON
                    let response = json["response"].dictionaryValue
                    //take value from dictionary
                    guard let items = response["items"]?.arrayValue else {return}
                    guard let item = items.last?.dictionaryValue else {return}
                    let sizes = item["sizes"]!.arrayValue
                    guard let photo = sizes.last!["url"].url else {return}

                    let image = UIImageView()
                    image.load(url: photo)

                    self.avatarImage.image = image.image
                } catch {
                    print(error)
                }
            }
        }
    }

    //prepare token to the correct format
    func compileToken() -> String {
        let token = Locksmith.loadDataForUserAccount(userAccount: "VK")

        let tokenKey: String = (token?.keys.first)!
        guard let tokenValue: String = token?.values.first as? String else {
            return "error with token Value"
        }
        let finalToken = tokenKey + "=" + tokenValue

        return finalToken
    }

    @IBAction func logoutButtonDidTab(_ sender: UIButton) {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "VK")
        } catch {
            print(error)
        }

        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
