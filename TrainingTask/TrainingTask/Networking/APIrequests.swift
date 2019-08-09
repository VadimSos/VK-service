//
//  APIrequests.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 8/1/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class APIrequests {

//	func apiRequest() {
//		guard let test = GroupRoute().getURL() else {return}
//		AF.request(test).responseData { response in
//			if let data = response.data {
//				GroupParser<[GroupModel]>().parsing(data: data)
//			}
//		}
//	}

	func request<T>(route: Route<T>, parser: Parser<T>, completion: @escaping (T?, ValidationError?) -> Void) {

//		func performCompletion(result: T?, error: ValidationError?) {
//			completion(result, error)
//		}

		guard let url = route.getURL() else {return}
		guard let httpMethod = HTTPMethod(rawValue: route.type) else {return}
		let parameters = route.param
		AF.request(url,
				   method: httpMethod,
				   parameters: parameters,
				   encoding: URLEncoding.default,
				   headers: nil,
				   interceptor: nil).validate().responseData { response in
			//operate result of AF request
			switch response.result {
			case .success:
				if let data = response.data {
					parser.parsing(data: data) { result, error  in
						if error != nil {
							completion(nil, .parsingError)
						} else {
							completion(result, nil)
						}
					}
				}
			case .failure:
				completion(nil, .requestError)
			}
		}
	}

	static let resultValue = ConfigPlistResult()

	let pBaseURL = resultValue.stringValue(key: .baseURL)
	let pAuthorizationURL = resultValue.stringValue(key: .authURL)
	let pRedirectURL = resultValue.stringValue(key: .redirectURL)
	let pApiVersion = resultValue.intValue(key: .apiVersion)
	let pClientID = resultValue.intValue(key: .clientID)
	let pCount = resultValue.intValue(key: .count)
	let pScope = resultValue.intValue(key: .permission)
	let accessTokenKey = resultValue.stringValue(key: .tokenKey)

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
