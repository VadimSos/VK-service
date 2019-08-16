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

	let resultValue = ConfigPlistResult.shared

    func authorizeURL() -> URL? {
        let api = "\(resultValue.authorizationURL)authorize?"
        let clientID = "client_id=\(resultValue.clientID)&"
        let scope = "scope=\(resultValue.scope)&"
        let display = "display=page&"
        let version = "v=\(resultValue.apiVersion)&"
        let responseToken = "response_type=token&"
        let revoke = "revoke=1"
        let redirectURL = "redirect_uri=\(resultValue.redirectURL)&"
        let myURL = URL(string: api + clientID + scope + redirectURL + display + version + responseToken + revoke)
        return myURL
    }

	func getGroupsURL(userOffsetAmount: Int) -> URL? {
		let api = "\(resultValue.baseURL)method/groups.get?"
		let extended = "extended=1&"
		let count = "count=\(resultValue.count)&"
		let offset = "offset=\(userOffsetAmount)&"
		let version = "v=\(resultValue.apiVersion)&"
		guard let requestToken = compileToken() else {return nil}
		let myURL = URL(string: api + extended + offset + count + version + requestToken)
		return myURL
	}

	func getPostsURL(userOffsetAmount: Int) -> URL? {
		let api = "\(resultValue.baseURL)method/wall.get?"
		let extended = "extended=1&"
		let count = "count=\(resultValue.count)&"
		let offset = "offset=\(userOffsetAmount)&"
		let version = "v=\(resultValue.apiVersion)&"
		guard let requestToken = compileToken() else {return nil}
		let myURL = URL(string: api + extended + offset + count + version + requestToken)
		return myURL
	}

	func addingPost(postText: String) -> URL? {
		let api = "\(resultValue.baseURL)method/wall.post?"
		let message = "message=\(postText)&"
		let version = "v=\(resultValue.apiVersion)&"
		guard let requestToken = compileToken() else {return nil}
		let myURL = URL(string: api + message + version + requestToken)
		return myURL
	}

	func getProfileNameURL() -> URL? {
		let api = "\(resultValue.baseURL)method/account.getProfileInfo?"
		let version = "v=\(resultValue.apiVersion)&"
		guard let requestToken = compileToken() else {return nil}
		let myURL = URL(string: api + version + requestToken)
		return myURL
	}

	func getProfileImageURL() -> URL? {
		let api = "\(resultValue.baseURL)method/photos.getProfile?"
		let reverse = "rev=0&"
		let extended = "extended=0&"
		let photoSizes = "photo_sizes=0&"
		let version = "v=\(resultValue.baseURL)&"
		guard let requestToken = compileToken() else {return nil}
		let myURL = URL(string: api + reverse + extended + photoSizes + version + requestToken)
		return myURL
	}

	func logoutURL() -> URL? {
		let api = "\(resultValue.baseURL)oauth/logout?"
		let clientID = "client_id=\(resultValue.clientID)&"
		let myURL = URL(string: api + clientID)
		return myURL
	}

	//prepare token to the correct format
	func compileToken() -> String? {
		guard let token = KeychainOperations().getToken() else {return nil}
		let tokenKey = "\(resultValue.accessTokenKey)"
		let finalToken = tokenKey + "=" + token
		return finalToken
	}
}
