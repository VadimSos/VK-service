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

	@IBOutlet weak var group: UITableView!

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		urlRequest()
	}

	//create, send URL to VK
	func urlRequest() {
		let api = "https://api.vk.com/method/messages.getConversations?"
		let offset = "offset=0&"
		let count = "count=1&"
		let filter = "filter=all&"
		let extended = "extended=0&"
		let version = "v=5.101&"
		let requestToken = compileToken()
		guard let myURL = URL(string: api + offset + count + filter + extended + version + requestToken) else {return}

		//send request and operate response
		AF.request(myURL).responseJSON { response in
			debugPrint(response)
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
		return 5
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as? GroupsTableViewCell else {
			fatalError("error")
		}
		return cell
	}
}
