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

	let redirectURL = ConfigPlistResult.shared.redirectURL
	let auothURL = ConfigPlistResult.shared.authorizationURL

    func prepareResponseURLToCorrectFormat(url: String) -> URL? {
        let newString = (url.replacingOccurrences(of: "#", with: "?"))
        let resultURL = URL(string: newString)
        return resultURL
    }

    func checkURLValidation(responseURL: URL) -> Bool {
        var result = false
        let stringURL = responseURL.absoluteString
        if stringURL.hasPrefix("\(redirectURL)") || stringURL.hasPrefix("\(auothURL)authorize") {
            result = true
        }
        return result
    }
}
