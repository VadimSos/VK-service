//
//  APIresponse.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 8/1/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import UIKit

class APIresponse {
    
    private let redirectURL = "https://oauth.vk.com/blank.html"

    func prepareResponseURLToCorrectFormat(url: String) -> URL? {
        let newString = (url.replacingOccurrences(of: "#", with: "?"))
        let resultURL = URL(string: newString)
        return resultURL
    }

    func checkURLValidation(responseURL: URL) -> Bool {
        var result = false
        let stringURL = responseURL.absoluteString
        if stringURL.hasPrefix("\(redirectURL)") || stringURL.hasPrefix("https://oauth.vk.com/authorize") {
            result = true
        }
        return result
    }
}
