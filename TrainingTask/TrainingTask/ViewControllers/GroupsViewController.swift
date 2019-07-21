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
import SwiftyJSON

class GroupsViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var groupsTableView: UITableView!

	// MARK: - Variables

	var countAmmount = 10
	var namesArray: [PostModel] = []

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
		AF.request(myURL).responseData { response in
			if let data = response.data {
				do {
					let json = try JSON(data: data)
					//take dictionary from JSON
					let response = json["response"].dictionaryValue
					//take value from dictionary
					guard let items = response["items"]?.arrayValue else {return}
					//save names into array
					for items in items {
						guard let name = items["name"].string else {return}
						self.namesArray.append(PostModel(pGroupName: name))
					}
				} catch {
					print(error)
				}
			}
			self.groupsTableView.reloadData()
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
		return namesArray.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as? GroupsTableViewCell else {
			fatalError("error")
		}
		cell.updateTableOfGroups(with: namesArray[indexPath.row])
		return cell
	}
}
