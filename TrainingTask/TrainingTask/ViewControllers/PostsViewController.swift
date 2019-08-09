//
//  PostsViewController.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/22/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class PostsViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets

    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var postTextField: UITextField!

    // MARK: - Variables

    // swiftlint:disable:next force_try
    let realm = try! Realm()
    var items: Results<PostsList>!

    var userOffsetAmount = 0
    var totalCountOfPosts = 0
    var refreshControl: UIRefreshControl!
    var scrollMore = false
    var cellHeightsDictionary: [IndexPath: CGFloat] = [:]

    //update realm
    var needUpdate = false
    var item = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.postTableView.rowHeight = 100

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        postTableView.addSubview(refreshControl)

        //request to realm DB
        items = realm.objects(PostsList.self)
        //print realm DB in Finder
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        print("//\(items.count)")
        if items.count == 0 {
            DispatchQueue.global().async {
                self.getPostList()
                DispatchQueue.main.async {
                    self.postTableView.reloadData()
                }
            }
//            getPostList()
        }
    }
    //after press keyboard button "Done" hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        postTextField.resignFirstResponder()
        return true
    }

    @objc func refresh(_ sender: Any) {
        self.userOffsetAmount = 0
        self.needUpdate = true
        // swiftlint:disable:next force_try
//        try! realm.write {
//            items.realm?.delete(items)
//        }
        getPostList()
        refreshControl.endRefreshing()
    }

    //create, send URL to VK
    func getPostList() {
		guard let myURL = APIrequests().getPostsURL(userOffsetAmount: userOffsetAmount) else {return}

        //do not increase cells more than total amount of groups
        if userOffsetAmount <= totalCountOfPosts {

            //send request and operate response
            AF.request(myURL).responseData { response in
                if let data = response.data {
                    do {
                        let json = try JSON(data: data)
                        //take dictionary from JSON
                        let response = json["response"].dictionaryValue
                        //take value from dictionary
                        guard let profiles = response["profiles"]?.arrayValue else {return}
                        self.userOffsetAmount += 20
                        print("scroll: \(self.userOffsetAmount)")
                        guard let items = response["items"]?.arrayValue else {return}
                        //return total count of posts
                        guard let totalPosts = response["count"]?.intValue else {return}
                        self.totalCountOfPosts = totalPosts

                        //save names into array and link into array
                        for eachPost in items {
                            guard let postText = eachPost["text"].string else {return}
                            guard let fromID = eachPost["from_id"].int else {return}

                            for eachProfile in profiles {
                                guard let id = eachProfile["id"].int else {return}
                                guard let name = eachProfile["first_name"].string else {return}
                                guard let urlImage = eachProfile["photo_100"].url else {return}

                                //find proper user info for current post item
                                if fromID == id {
                                    let urlImageView = UIImageView()
                                    urlImageView.load(url: urlImage) {

                                        self.postTableView.reloadData()
                                    }

                                    // swiftlint:disable:next force_try
                                    try! self.realm.write {
                                        let realmData = PostsList()
                                        realmData.name = name
                                        realmData.text = postText
                                        //save image to realm DB as Data
                                        let url = URL(string: urlImage.absoluteString)
                                        guard let imgData = NSData(contentsOf: url!) else {return}
                                        realmData.image = imgData as Data

                                        if self.needUpdate {
                                            self.updateRealmData(name: name, image: imgData as Data, text: postText)
                                        } else {
                                            self.realm.add(realmData)
                                        }
                                    }
//                                    // swiftlint:disable:next force_try
//                                    try! self.realm.write {
//                                        let realmData = PostsList()
//                                        realmData.name = name
//                                        realmData.text = postText
//                                        //save image to realm DB as Data
//                                        let url = URL(string: urlImage.absoluteString)
//                                        guard let imgData = NSData(contentsOf: url!) else {return}
//                                        realmData.image = imgData as Data
//
//                                        self.realm.add(realmData)
//                                    }

                                }
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
                print("start scroll")
                self.needUpdate = false
                self.scrollMore = false
                self.postTableView.reloadData()
                self.postTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
            }

        }
    }

    func updateRealmData(name: String, image: Data, text: String) {
        if item < userOffsetAmount {
            let updatedData = realm.objects(PostsList.self)
            updatedData[item].name = name
            updatedData[item].image = image
            updatedData[item].text = text
            item += 1
        }
    }

    @IBAction func addPostButtonDidTap(_ sender: UIButton) {
        addingPost()
        postTextField.text?.removeAll()
    }

    func addingPost() {
		guard let postText = postTextField.text else {return}
		guard let myURL = APIrequests().addingPost(postText: postText) else {return}

        AF.request(myURL).response { _ in
            self.userOffsetAmount = 0
            // swiftlint:disable:next force_try
            try! self.realm.write {
                self.items.realm?.delete(self.items)
            }
            self.getPostList()
        }
    }
}

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //realm
            if items?.count != nil && items?.count != 0 {
                return items!.count
            }
            return 0
        } else if section == 1 && !scrollMore {
            //if this is end of table do not show spinner at all
            if userOffsetAmount <= totalCountOfPosts {
                if Reachability.isConnectedToNetwork() {
                    return 1
                } else {
                    return 0
                }
            }
            return 0
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell", for: indexPath) as? PostsTableViewCell else {
                fatalError("error")
            }
            //realm
            if indexPath.row < items.count {
                let item = items?[indexPath.row]
                cell.updateRealmData(image: item!.image, name: item!.name, text: item!.text)
            }
            if indexPath.row == items.count - 1 {
                if scrollMore == false {
                    beginScrollMore {
                        if Reachability.isConnectedToNetwork() {
                            self.getPostList()
                        }
                    }
                }
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingPostCell", for: indexPath) as? PostsLoadingTableViewCell else {
                fatalError("error")
            }
            if Reachability.isConnectedToNetwork() {
                cell.spinner.startAnimating()
                cell.refreshTextLabel.text = "Refreshing..."
            } else {
                cell.spinner.startAnimating()
                cell.refreshTextLabel.text = "Can't refresh data. Please check your network connection."
            }
            cell.hideSeparator()
            return cell
        }
    }
}

// MARK: - TableViewDelegate

extension PostsViewController: UITableViewDelegate {

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
//    // MARK: - hanlode scrolling in the end of table
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //detect position from top of frame till the beginning of content
//        let offsetY = scrollView.contentOffset.y
//        let contentHigh = scrollView.contentSize.height
//
//        if offsetY > contentHigh - scrollView.frame.height {
//            if !scrollMore {
//                beginScrollMore {
//                    if Reachability.isConnectedToNetwork() {
//                        self.getPostList()
//                    }
//                }
//            }
//        }
//    }

    func beginScrollMore(completion: () -> Void) {
        if Reachability.isConnectedToNetwork() {
            scrollMore = true
            print("begin scroll")
            postTableView.reloadSections(IndexSet(integer: 1), with: .none)
            completion()
        } else {
            scrollMore = false
//            UIAlertController.showError(message: "Internet Connection not Available!", from: self)
        }
    }
}
