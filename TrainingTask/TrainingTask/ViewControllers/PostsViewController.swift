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

    // MARK: - Variables
    
    var userOffsetAmount = 10
    var postsArray: [PostsPostModel] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        urlRequest()
    }

    //create, send URL to VK
    func urlRequest() {
        let api = "https://api.vk.com/method/wall.get?"
        let extended = "extended=1&"
        let count = "count=8&"
        let offset = "offset=\(userOffsetAmount)&"
        let version = "v=5.101&"
        let requestToken = compileToken()
        guard let myURL = URL(string: api + extended + offset + count + version + requestToken) else {return}

        //send request and operate response
        AF.request(myURL).responseData { response in
            if let data = response.data {
                do {
                    let json = try JSON(data: data)
                    //take dictionary from JSON
                    let response = json["response"].dictionaryValue
                    //take value from dictionary
                    guard let profiles = response["profiles"]?.arrayValue else {return}
                    self.userOffsetAmount += 8
                    guard let items = response["items"]?.arrayValue else {return}
                    for eachPost in items {
                        guard let postText = eachPost["text"].string else {return}
                        //save names into array and link into array
                        for eachProfile in profiles {
                            guard let name = eachProfile["first_name"].string else {return}
                            guard let urlImage = eachProfile["photo_50"].url else {return}

                            let urlImageView = UIImageView()
                            urlImageView.load(url: urlImage)
                            self.postsArray.append(PostsPostModel(pUserName: name, pUserImage: urlImageView.image!, pUserText: postText))
                        }
                    }
                } catch {
                    print(error)
                }
            }
            self.postTableView.reloadData()
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

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell", for: indexPath) as? PostsTableViewCell else {
            fatalError("error")
        }
        cell.updateTableOfPosts(with: postsArray[indexPath.row])
        return cell
    }
}
