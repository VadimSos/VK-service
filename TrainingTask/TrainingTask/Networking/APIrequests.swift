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

	let pBaseURL = ConfigPlistReading().getPlistValue(key: "Base URL")
	let pAuthorizationURL = ConfigPlistReading().getPlistValue(key: "Authorization URL")
	let pRedirectURL = ConfigPlistReading().getPlistValue(key: "Redirect URL")
	let pApiVersion = ConfigPlistReading().getPlistValue(key: "API version")
	let pClientID = ConfigPlistReading().getPlistValue(key: "Client ID")
	let pCount = ConfigPlistReading().getPlistValue(key: "Count of Posts/Groups")
	let pScope = ConfigPlistReading().getPlistValue(key: "Access Permissions")
	let accessTokenKey = ConfigPlistReading().getPlistValue(key: "Token Key")

    func authorizeURL() -> URL? {
        let api = "\(pAuthorizationURL)authorize?"
        let clientID = "client_id=\(pClientID)&"
        let scope = "scope=\(pScope)&"
        let display = "display=page&"
        let version = "v=\(pApiVersion)&"
        let responseToken = "response_type=token&"
        let revoke = "revoke=1"
        let redirectURL = "redirect_uri=\(pRedirectURL)&"
        let myURL = URL(string: api + clientID + scope + redirectURL + display + version + responseToken + revoke)
        return myURL
    }

	func getGroupsURL(userOffsetAmount: Int) -> URL? {
		let api = "\(pBaseURL)method/groups.get?"
		let extended = "extended=1&"
		let count = "count=\(pCount)&"
		let offset = "offset=\(userOffsetAmount)&"
		let version = "v=\(pApiVersion)&"
		guard let requestToken = compileToken() else {return nil}
		let myURL = URL(string: api + extended + offset + count + version + requestToken)
		return myURL
	}

	func getPostsURL(userOffsetAmount: Int) -> URL? {
		let api = "\(pBaseURL)method/wall.get?"
		let extended = "extended=1&"
		let count = "count=\(pCount)&"
		let offset = "offset=\(userOffsetAmount)&"
		let version = "v=\(pApiVersion)&"
		guard let requestToken = compileToken() else {return nil}
		let myURL = URL(string: api + extended + offset + count + version + requestToken)
		return myURL
	}

	func addingPost(postText: String) -> URL? {
		let api = "\(pBaseURL)method/wall.post?"
		let message = "message=\(postText)&"
		let version = "v=\(pApiVersion)&"
		guard let requestToken = compileToken() else {return nil}
		let myURL = URL(string: api + message + version + requestToken)
		return myURL
	}

	func getProfileNameURL() -> URL? {
		let api = "\(pBaseURL)method/account.getProfileInfo?"
		let version = "v=\(pApiVersion)&"
		guard let requestToken = compileToken() else {return nil}
		let myURL = URL(string: api + version + requestToken)
		return myURL
	}

	func getProfileImageURL() -> URL? {
		let api = "\(pBaseURL)method/photos.getProfile?"
		let reverse = "rev=0&"
		let extended = "extended=0&"
		let photoSizes = "photo_sizes=0&"
		let version = "v=\(pApiVersion)&"
		guard let requestToken = compileToken() else {return nil}
		let myURL = URL(string: api + reverse + extended + photoSizes + version + requestToken)
		return myURL
	}

	func logoutURL() -> URL? {
		let api = "\(pBaseURL)oauth/logout?"
		let clientID = "client_id=\(pClientID)&"
		let myURL = URL(string: api + clientID)
		return myURL
	}

	//prepare token to the correct format
	func compileToken() -> String? {
		guard let token = KeychainOperations().getToken() else {return nil}
		let tokenKey = "\(accessTokenKey)"
		let finalToken = tokenKey + "=" + token
		return finalToken
	}
}
