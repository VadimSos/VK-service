//
//  ExtensionURL.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/17/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import Locksmith

extension URL {
    func params(url: URL) -> [String: Any] {
        var dict = [String: Any]()

        let word = url.absoluteString
        let newString = word.replacingOccurrences(of: "#", with: "?")
        let resultURL = URL(string: newString)

        if let components = URLComponents(url: resultURL!, resolvingAgainstBaseURL: false) {
            if let queryItems = components.queryItems {
                for item in queryItems {
                    dict[item.name] = item.value!
                }
            }

            //save token to Locksmith
            if word.contains("#") {
                let index = dict.index(forKey: "access_token")
                let tokenDict: [String: String] = [dict[index!].key: dict[index!].value as? String ?? "error"]
                do {
                    try Locksmith.saveData(data: tokenDict, forUserAccount: "VK")
                } catch {
                    print(error)
                }
            }

            return dict
        } else {
            return [:]
        }
    }
}
