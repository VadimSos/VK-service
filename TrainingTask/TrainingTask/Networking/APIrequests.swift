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

	func request<ModelType>(route: Route<ModelType>, parser: Parser<ModelType>, completion: ((ModelType?, ValidationError?) -> Void)?) {

		guard let url = route.getURL() else {return}
		guard let httpMethod = HTTPMethod(rawValue: route.type) else {return}
		let parameters = route.param
		if Reachability.isConnectedToNetwork() {
			AF.request(url,
					   method: httpMethod,
					   parameters: parameters,
					   encoding: URLEncoding.default,
					   headers: nil,
					   interceptor: nil)
				.validate()
				.responseData { response in
				//operate result of AF request
				switch response.result {
				case .success:
					if let data = response.data {
						parser.parsing(data: data) { result, error  in
							if error != nil {
								completion!(nil, .parsingError)
							} else {
								completion!(result, nil)
							}
						}
					}
				case .failure:
					completion!(nil, .serverError)
				}
			}
		} else {
			UIAlertController.showError(message: NSLocalizedString("No internet", comment: ""), from: .init())
		}
	}

	let resultValue = ConfigPlistResult.shared

//	func getPostsURL(userOffsetAmount: Int) -> URL? {
//		let api = "\(resultValue.baseURL)method/wall.get?"
//		let extended = "extended=1&"
//		let count = "count=\(resultValue.count)&"
//		let offset = "offset=\(userOffsetAmount)&"
//		let version = "v=\(resultValue.apiVersion)&"
//		guard let requestToken = compileToken() else {return nil}
//		let myURL = URL(string: api + extended + offset + count + version + requestToken)
//		return myURL
//	}

	func addingPost(postText: String) -> URL? {
		let api = "\(resultValue.baseURL)method/wall.post?"
		let message = "message=\(postText)&"
		let version = "v=\(resultValue.apiVersion)&"
		guard let requestToken = compileToken() else {return nil}
		let myURL = URL(string: api + message + version + requestToken)
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
