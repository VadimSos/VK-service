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

	let apiVKVersion = "v=5.101&"
	let userClientID = "client_id=7062888&"

    func authorizeURL() -> URL? {
        let api = "https://oauth.vk.com/authorize?"
        let clientID = userClientID
        let scope = "scope=8192&"
        let display = "display=page&"
        let version = apiVKVersion
        let responseToken = "response_type=token&"
        let revoke = "revoke=1"
        let redirectURL = "https://oauth.vk.com/blank.html"
        let myURL = URL(string: api + clientID + scope + "redirect_uri=" + redirectURL + "&" + display + version + responseToken + revoke)
        return myURL
    }

	func getGroupsURL(userOffsetAmount: Int) -> URL? {
		let api = "https://api.vk.com/method/groups.get?"
		let extended = "extended=1&"
		let count = "count=20&"
		let offset = "offset=\(userOffsetAmount)&"
		let version = apiVKVersion
		let requestToken = compileToken()
		let myURL = URL(string: api + extended + offset + count + version + requestToken)
		return myURL
	}

	func getPostsURL(userOffsetAmount: Int) -> URL? {
		let api = "https://api.vk.com/method/wall.get?"
		let extended = "extended=1&"
		let count = "count=15&"
		let offset = "offset=\(userOffsetAmount)&"
		let version = apiVKVersion
		let requestToken = compileToken()
		let myURL = URL(string: api + extended + offset + count + version + requestToken)
		return myURL
	}

	func addingPost(postText: String) -> URL? {
		let api = "https://api.vk.com/method/wall.post?"
		let message = "message=\(postText)&"
		let version = "v=5.101&"
		let requestToken = APIrequests().compileToken()
		let myURL = URL(string: api + message + version + requestToken)
		return myURL
	}

	func getProfileNameURL() -> URL? {
		let api = "https://api.vk.com/method/account.getProfileInfo?"
		let version = apiVKVersion
		let requestToken = compileToken()
		let myURL = URL(string: api + version + requestToken)
		return myURL
	}

	func getProfileImageURL() -> URL? {
		let api = "https://api.vk.com/method/photos.getProfile?"
		let reverse = "rev=0&"
		let extended = "extended=0&"
		let photoSizes = "photo_sizes=0&"
		let version = apiVKVersion
		let requestToken = compileToken()
		let myURL = URL(string: api + reverse + extended + photoSizes + version + requestToken)
		return myURL
	}

	func logoutURL() -> URL? {
		let api = "https://api.vk.com/oauth/logout?"
		let clientID = userClientID
		let myURL = URL(string: api + clientID)
		return myURL
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
}
