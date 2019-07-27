//
//  ViewController.swift
//  IOS Social Network
//
//  Created by  SENAT on 24/07/2019.
//  Copyright © 2019 <ASi. All rights reserved.
//

import UIKit

struct Post: Decodable {
    var id: Int
    var title, body: String
}

class ViewController: UITableViewController {
    
    fileprivate func  fetchPosts() {
        Service.shared.fetchPosts { (res) in
            switch res {
            case .success(let posts):
                self.posts = posts
                self.tableView.reloadData()
            case .failure(let err):
                print("Failed to fetch posts:", err)
            }
        }
    }
    var posts = [Post]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete post")
            let post = self.posts[indexPath.row]
            Service.shared.deletePost(id: post.id) { (err) in
                if let err = err {
                    print("Failed to delete:", err)
                    return
                }
                print("Successfully delete post from server")
                
                self.posts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Posts"
        navigationItem.rightBarButtonItem = .init(title: "Create post", style: .plain, target: self, action: #selector(handleCreatePost))
        navigationItem.leftBarButtonItem = .init(title: "Login", style: .plain, target: self, action: #selector(handleLogin))
    }
    
    @objc func handleCreatePost() {
        print("Created post")
        Service.shared.createPosts(title: "Test", body: "Test post body ") { (err) in
            if let err = err {
                print("Failed to create post object", err)
                return
            }
            self.fetchPosts()
        }
    }
    
    @objc fileprivate func handleLogin() {
        print("Login")
        guard let url = URL(string: "http://localhost:1440/api/v1/entrance/login") else { return }
        
        var loginRequest = URLRequest(url: url)
        loginRequest.httpMethod = "PUT"
        do {
            let params = ["emailAddress": "alex@gmail.com", "password": "123123"]
            loginRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: .init())
            
            URLSession.shared.dataTask(with: loginRequest) { (data, resp, err) in
                
                if let err = err {
                    print("Failed to login:", err)
                    return
                }
                
                print("test")
                self.fetchPosts()
            }.resume()
        } catch {
            print("Failed to serialze data:", error)
        }
       
    }
}

