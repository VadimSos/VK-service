//
//  PostsViewController.swift
//  TrainingTask
//
//  Created by Sosnovsky, Vadim on 7/22/19.
//  Copyright © 2019 Sosnovsky, Vadim. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire
import SwiftyJSON

class PostsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var postTextField: UITextField!

    // MARK: - Variables

    var userOffsetAmount = 0
    var totalCountOfPosts = 0
    var postsArray: [PostsPostModel] = []
    var postText: [String] = []
    var refreshControl: UIRefreshControl!
    var scrollMore = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getPostList()
        self.postTableView.rowHeight = 100

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        postTableView.addSubview(refreshControl)
    }

    @objc func refresh(_ sender: Any) {
        postsArray.removeAll()
        self.userOffsetAmount = 0
        getPostList()
        refreshControl.endRefreshing()
    }

    //create, send URL to VK
    func getPostList() {
        let api = "https://api.vk.com/method/wall.get?"
        let extended = "extended=1&"
        let count = "count=15&"
        let offset = "offset=\(userOffsetAmount)&"
        let version = "v=5.101&"
        let requestToken = compileToken()
        guard let myURL = URL(string: api + extended + offset + count + version + requestToken) else {return}

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
                        self.userOffsetAmount += 15
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
                                    urlImageView.load(url: urlImage)

                                    self.postsArray.append(PostsPostModel(pUserName: name, pUserImage: urlImageView.image!, pUserText: postText))
                                }
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
                self.postTableView.reloadData()
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

    @IBAction func addPostButtonDidTap(_ sender: UIButton) {
        postPostList()
        //update table with new post
        postsArray.removeAll()
        userOffsetAmount = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.getPostList()
        })
    }

    //add post
    func postPostList() {
        let api = "https://api.vk.com/method/wall.post?"
        guard let text = postTextField.text else {return}
        let message = "message=\(text)&"
        let version = "v=5.101&"
        let requestToken = compileToken()
        guard let myURL = URL(string: api + message + version + requestToken) else {return}

        //make post on the wall
        AF.request(myURL)
    }
}

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return postsArray.count
        } else if section == 1 && scrollMore {
            //if this is end of table do not show spinner at all
            if userOffsetAmount <= totalCountOfPosts {
                return 1
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
            cell.updateTableOfPosts(with: postsArray[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingPostCell", for: indexPath) as? PostsLoadingTableViewCell else {
                fatalError("error")
            }
            cell.spinner.startAnimating()
            return cell
        }
    }
}

// MARK: - TableViewDelegate

extension PostsViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    // MARK: - hanlode scrolling in the end of table
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
        postTableView.reloadSections(IndexSet(integer: 1), with: .none)
        //add 1 second delay before request new list of groups
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            print("start scroll")
            self.getPostList()
            self.scrollMore = false
        })
    }
}
