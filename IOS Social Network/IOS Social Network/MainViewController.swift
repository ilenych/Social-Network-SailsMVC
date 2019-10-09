//
//  ViewController.swift
//  IOS Social Network
//
//  Created by  SENAT on 24/07/2019.
//  Copyright © 2019 <ASi. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.fetchPosts()
        }
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Posts"
        navigationItem.rightBarButtonItem = .init(title: "Create post", style: .plain, target: self, action: #selector(handleCreatePost))
        navigationItem.leftBarButtonItem = .init(title: "Update", style: .plain, target: self, action: #selector(handleUpdate))
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
    
//    @objc fileprivate func handleLogin() {
//        print("Login")
//        
//        Service.shared.login()
//        self.fetchPosts()
//        
//    }
    
    @objc func handleUpdate() {
        fetchPosts()
    }
}

