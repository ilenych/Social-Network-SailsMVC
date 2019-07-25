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

class Service: NSObject {
    static let shared = Service()
    
    func fetchPosts(compilation: @escaping (Result <[Post], Error>) -> ()) {
        guard let url = URL(string: "http://localhost:1337/posts") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let err = error {
                    print(err)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    let posts  = try JSONDecoder().decode([Post].self, from: data)
                    compilation(.success(posts))
                } catch {
                    compilation(.failure(error))
                }
            }
            }.resume()
    }
    
    func createPosts(title: String, body: String, compilation: @escaping (Error?) -> ()) {
        guard let url = URL(string: "http://localhost:1337/post") else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let params = ["title": title, "postBody": body]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: .init())
            urlRequest.httpBody = data
            urlRequest.setValue("aplication/json", forHTTPHeaderField: "content-type")
            
            URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
                
                guard let data = data  else { return }
                
                compilation(nil)
                }.resume()
        } catch {
            compilation(error)
        }
    }
    
    func deletePost(id: Int, compilation: @escaping (Error?) -> ()) {
        guard let url = URL(string: "http://localhost:1337/post/\(id)") else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, resp, err) in
            DispatchQueue.main.async {
                if let err = err {
                    compilation(err)
                    return
                }
                
                if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
                    
                    let errorString = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    
                    compilation(NSError(domain: "", code: resp.statusCode, userInfo: [NSLocalizedDescriptionKey: errorString]))
                    return
                }
            }
            
            compilation(nil)
            
            }.resume()
    }
}

class ViewController: UITableViewController {
    
    fileprivate func fetchPosts() {
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
}

