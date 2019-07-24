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
import SDWebImage

class GroupsViewController: UIViewController {

        // MARK: - Outlets

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var groupsTableView: UITableView!

	// MARK: - Variables

	var userOffsetAmount = 0
    var totalCountOfGroups = 0
	var groupsArray: [PostModel] = []
	var refreshControl: UIRefreshControl!
    var scrollMore = false

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		urlRequest()

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        groupsTableView.addSubview(refreshControl)
	}

    @objc func refresh(_ sender: Any) {
        groupsArray.removeAll()
        self.userOffsetAmount = 0
        urlRequest()
        refreshControl.endRefreshing()
    }

	//create, send URL to VK
	func urlRequest() {
		let api = "https://api.vk.com/method/groups.get?"
		let extended = "extended=1&"
		let count = "count=20&"
		let offset = "offset=\(userOffsetAmount)&"
		let version = "v=5.101&"
		let requestToken = compileToken()
		guard let myURL = URL(string: api + extended + offset + count + version + requestToken) else {return}

		//send request and operate response
        if userOffsetAmount <= totalCountOfGroups {

            AF.request(myURL).responseData { response in
                if let data = response.data {
                    do {
                        let json = try JSON(data: data)
                        //take dictionary from JSON
                        let response = json["response"].dictionaryValue
                        //take value from dictionary
                        guard let items = response["items"]?.arrayValue else {return}
                        self.userOffsetAmount += 20
                        //total count of groups
                        guard let groupsCount = response["count"]?.intValue else {return}
                        self.totalCountOfGroups = groupsCount
                        //save names into array and link into array
                        for eachItems in items {
                            guard let name = eachItems["name"].string else {return}
                            guard let urlImage = eachItems["photo_50"].url else {return}

                            let urlImageView = UIImageView()
                            urlImageView.load(url: urlImage)
                            self.groupsArray.append(PostModel(pGroupName: name, pGroupImage: urlImageView.image!))
                        }
                    } catch {
                        print(error)
                    }
                }
                self.groupsTableView.reloadData()
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

//    func detectingEndOfTable() {
//        if groupsTableView.contentOffset.y >= (groupsTableView.contentSize.height - groupsTableView.frame.size.height) {
//            urlRequest()
//        }
//    }
}

extension GroupsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return groupsArray.count
        } else if section == 1 && scrollMore {
            return 1
        }
		return 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as? GroupsTableViewCell else {
                fatalError("error")
            }
            cell.updateTableOfGroups(with: groupsArray[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? GroupsLoadingTableViewCell else {
                fatalError("error")
            }
            cell.loadingIndicator.startAnimating()
            return cell
        }

//        print("request \(indexPath.row), \(groupsArray.count)")
//        if groupsArray.count - 1 == indexPath.row {
//          print("request success")
//          urlRequest()
//        }
	}
}

extension GroupsViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //detect position from top of frame till the beginning of content
        let offsetY = scrollView.contentOffset.y
        let contentHigh = scrollView.contentSize.height

        if offsetY > contentHigh - scrollView.frame.height {
            if !scrollMore {
                beginScrollMore()
            }
        }
    }

    func beginScrollMore() {
        scrollMore = true
        print("begin scroll")
        groupsTableView.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            print("start scroll")
            self.urlRequest()
            self.scrollMore = false
        })
    }
}
