//
//  GroupsViewController.swift
//  TrainingTask
//
//  Created by Vadzim Sasnouski on 7/20/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class GroupsViewController: UIViewController {

    // MARK: - Outlets

	@IBOutlet weak var groupsTableView: UITableView!

	// MARK: - Variables

    // swiftlint:disable:next force_try
    let realm = try! Realm()
    var items: Results<GroupsList>!

    var userOffsetAmount = 0
    var totalCountOfGroups = 0
	var refreshControl: UIRefreshControl!
    var scrollMore = false
    var cellHeightsDictionary: [IndexPath: CGFloat] = [:]
	var groupsArray: [GroupModel] = []

    //update realm
    var needUpdate = false
    var item = 0

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        groupsTableView.addSubview(refreshControl)

		urlRequest()
//        //request to realm DB
//        items = realm.objects(GroupsList.self)
//        //print realm DB in Finder
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
//        print("//\(items.count)")
//        if items.count == 0 {
//            DispatchQueue.global().async {
//                self.urlRequest()
//                DispatchQueue.main.async {
//                    self.groupsTableView.reloadData()
//                }
//            }
//
//        }
	}

    @objc func refresh(_ sender: Any) {
        self.userOffsetAmount = 0
        self.needUpdate = true
        // swiftlint:disable:next force_try
//        try! realm.write {
//            items.realm?.delete(items)
//        }
        urlRequest()
        refreshControl.endRefreshing()
    }

	//create, send URL to VK
	func urlRequest() {
//		guard let myURL = APIrequests().getGroupsURL(userOffsetAmount: userOffsetAmount) else {return}

		//do not increase cells more than total amount of groups
        if userOffsetAmount <= totalCountOfGroups {
            //send request and operate response
//            AF.request(myURL).responseData { response in
//                if let data = response.data {
//                    do {
//                        let json = try JSON(data: data)
//                        //take dictionary from JSON
//                        let response = json["response"].dictionaryValue
//                        //take value from dictionary
//                        guard let items = response["items"]?.arrayValue else {return}
//                        self.userOffsetAmount += 20
//                        //total count of groups
//                        guard let groupsCount = response["count"]?.intValue else {return}
//                        self.totalCountOfGroups = groupsCount
//                        //save names into array and link into array
//                        for eachItems in items {
//                            guard let name = eachItems["name"].string else {return}
//                            guard let urlImage = eachItems["photo_50"].url else {return}
//
//                            let urlImageView = UIImageView()
//                            urlImageView.load(url: urlImage) {
//
//                                self.groupsTableView.reloadData()
//                            }
//                            // swiftlint:disable:next force_try
//                            try! self.realm.write {
//                                let realmData = GroupsList()
//
//                                realmData.name = name
//                                print(name)
//                                //save image to realm DB as Data
//                                let url = URL(string: urlImage.absoluteString)
//                                guard let imgData = NSData(contentsOf: url!) else {return}
//                                realmData.image = imgData as Data
//                                print(realmData.image)
//
//                                if self.needUpdate {
//                                    self.updateRealmData(name: name, image: imgData as Data)
//                                } else {
//                                    self.realm.add(realmData)
//                                }
//                            }
//
//                        }
//                    } catch {
//                        print(error)
//                    }
//                }
//                print("start scroll")
//                self.needUpdate = false
//                self.scrollMore = false
//                self.groupsTableView.reloadData()
//                self.groupsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
//            }
			APIrequests().request(route: GroupRoute(), parser: GroupParser()) { result, error in
				if error != nil {
					UIAlertController.showError(message: (error?.errorDescription)!, from: self)
				} else {
					guard let result = result else {return}
					self.groupsArray = result
					print("start scroll")
					self.needUpdate = false
					self.scrollMore = false
					self.groupsTableView.reloadData()
					self.groupsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
				}
			}
        }
	}

    func updateRealmData(name: String, image: Data) {
        if item < userOffsetAmount {
            let updatedData = realm.objects(GroupsList.self)
            updatedData[item].name = name
            updatedData[item].image = image
            item += 1
        }
    }
}

extension GroupsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
//            //realm
//            if items?.count != nil && items?.count != 0 {
//                return items!.count
//            }
//            return 0
//        } else if section == 1 && !scrollMore {
//            //if this is end of table do not show spinner at all
//            if userOffsetAmount <= totalCountOfGroups {
//                if Reachability.isConnectedToNetwork() {
//                    return 1
//                } else {
//                    return 0
//                }
//            }

            return groupsArray.count
        }
		return 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsCell", for: indexPath) as? GroupsTableViewCell else {
                fatalError("error")
            }
//            //realm
//            if indexPath.row < items.count {
//                let item = items?[indexPath.row]
//                cell.updateNameInRealm(name: item!.name, image: item!.image)
//            }
//            print("//\(items.count)")
//            if indexPath.row == items.count - 1 {
//                if scrollMore == false {
//                    beginScrollMore {
//                        if Reachability.isConnectedToNetwork() {
//                            self.urlRequest()
//                        }
//                    }
//                }
//            }
			cell.updateGroups(items: groupsArray[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? GroupsLoadingTableViewCell else {
                fatalError("error")
            }
            if Reachability.isConnectedToNetwork() {
                cell.spinner.startAnimating()
                cell.textRefreshingLabel.text = "Refreshing..."
            } else {
                cell.spinner.startAnimating()
                cell.textRefreshingLabel.text = "Can't refresh data. Please check your network connection."
            }
            cell.hideSeparator()
            return cell
        }
	}
}

    // MARK: - TableViewDelegate

extension GroupsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.cellHeightsDictionary[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height =  self.cellHeightsDictionary[indexPath] {
            return height
        }
        return UITableView.automaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func beginScrollMore(completion: () -> Void) {
        if Reachability.isConnectedToNetwork() {
            scrollMore = true
            print("begin scroll")
            groupsTableView.reloadSections(IndexSet(integer: 1), with: .none)
            completion()
        } else {
            scrollMore = false
//            groupsTableView.reloadSections(IndexSet(integer: 1), with: .bottom)
//            UIAlertController.showError(message: "Internet Connection not Available!", from: self)
        }
    }
}
