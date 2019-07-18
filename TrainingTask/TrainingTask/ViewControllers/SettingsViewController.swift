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
        
        Alamofire.request(myURL).responseJSON { response in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                
                /*JSON: {
                    response =     {
                        bdate = "20.4.1991";
                        "bdate_visibility" = 0;
                        city =         {
                            id = 282;
                            title = Minsk;
                        };
                        country =         {
                            id = 3;
                            title = Belarus;
                        };
                        "first_name" = Vadim;
                        "home_town" = "\U041c\U0438\U043d\U0441\U043a";
                        "last_name" = Sosnovsky;
                        phone = "+375 ** *** ** 91";
                        relation = 0;
                        sex = 2;
                        status = "+375295000791";
                    };
                }*/
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
