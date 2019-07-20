//
//  GroupsViewController.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 7/20/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

class GroupsViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var groupsTableView: UITableView!
	
	// MARK: - Variables
	
	let countAmmount = 10

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		urlRequest()
	}

	//create, send URL to VK
	func urlRequest() {
		let api = "https://api.vk.com/method/groups.get?"
		let extended = "extended=1&"
		let count = "count=\(countAmmount)&"
		let version = "v=5.101&"
		let requestToken = compileToken()
		guard let myURL = URL(string: api + extended + count + version + requestToken) else {return}

		//send request and operate response
		AF.request(myURL).responseJSON { response in
			print("Request: \(String(describing: response.request))")   // original url request
			print("Response: \(String(describing: response.response))") // http url response
			print("Result: \(response.result)")                         // response serialization result
			
			if let json = response.result.value {
				print("JSON: \(json)") // serialized json response
			}
			
			if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
				print("Data: \(utf8Text)") // original server data as UTF8 string
			}
		}
	}

	//prepare token to the correct format
	func compileToken() -> String {
		let token = Locksmith.loadDataForUserAccount(userAccount: "VK")

		let tokenKey: String = (token?.keys.first)!
		guard let tokenValue: String = token?.values.first as? String else {
			return "error with token Value"
		}
		let finalToken = tokenKey + "=" + tokenValue

		return finalToken
	}
}

extension GroupsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return countAmmount
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as? GroupsTableViewCell else {
			fatalError("error")
		}
		return cell
	}
}
