//
//  APIrequests.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 8/1/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import UIKit

class APIrequests {
    
    func aouth2CreateURLRequest() -> URL? {
        let api = "https://oauth.vk.com/authorize?"
        let clientID = "client_id=7062888&"
        let scope = "scope=8192&"
        let display = "display=page&"
        let version = "v=5.101&"
        let responseToken = "response_type=token&"
        let revoke = "revoke=1"
        let redirectURL = "https://oauth.vk.com/blank.html"
        let myURL = URL(string: api + clientID + scope + "redirect_uri=" + redirectURL + "&" + display + version + responseToken + revoke)
        return myURL
    }
}
