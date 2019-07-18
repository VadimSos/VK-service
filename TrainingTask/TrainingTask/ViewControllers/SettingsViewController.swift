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

        urlRequest()
    }

    //create, send URL to VK
    func urlRequest() {
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
}
