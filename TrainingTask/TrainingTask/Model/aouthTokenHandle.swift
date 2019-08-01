//
//  aouthTokenHandle.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 8/1/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import Locksmith

class AouthTokenHandle {
    
    let userAccount = "VK"
    typealias Token = [String: Any]

    func saveToken(tokenDictionary: Token) {
        do {
            try Locksmith.saveData(data: tokenDictionary, forUserAccount: userAccount)
        } catch {
            fatalError("Can't save token")
        }
    }

    func loadToken() -> Token? {
        guard let token = Locksmith.loadDataForUserAccount(userAccount: userAccount) else {return nil}
        return token
    }

    func updateToken(tokenDictionary: Token) {
        do {
            try Locksmith.updateData(data: tokenDictionary, forUserAccount: userAccount)
        } catch {
            fatalError("Can't update token")
        }
    }

    func deleteToken() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: userAccount)
        } catch {
            fatalError("Can't delete token")
        }
    }
}
