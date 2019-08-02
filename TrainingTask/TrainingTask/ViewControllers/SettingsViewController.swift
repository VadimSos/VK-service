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
                    image.load(url: photo) {
                        self.avatarImage.image = image.image
                    }

                } catch {
                    print(error)
                }
            }
        }
    }

    //prepare token to the correct format
    func compileToken() -> String {
        let token = KeychainOperations().getToken()

        let tokenKey = "access_token"
        guard let tokenValue: String = token else {
            return "error with token Value"
        }
        let finalToken = tokenKey + "=" + tokenValue

        return finalToken
    }

    @IBAction func logoutButtonDidTab(_ sender: UIButton) {
        KeychainOperations().deleteToken()

        let logoutURL = URL(string: "https://api.vk.com/oauth/logout?client_id=6191231")

        AF.request(logoutURL!).responseData { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result

//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }

            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
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
