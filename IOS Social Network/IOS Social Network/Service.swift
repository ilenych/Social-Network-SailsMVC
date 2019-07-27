//
//  Service.swift
//  IOS Social Network
//
//  Created by  SENAT on 28/07/2019.
//  Copyright © 2019 <ASi. All rights reserved.
//

import Foundation

class Service: NSObject {
    static let shared = Service()
    
    let baseUrl = "http://localhost:1440"
    
    func fetchPosts(compilation: @escaping (Result <[Post], Error>) -> ()) {
        guard let url = URL(string: "\(baseUrl)/home") else { return }
        
        var fetchPostRequest = URLRequest(url: url)
        fetchPostRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        URLSession.shared.dataTask(with: fetchPostRequest) { (data, response, error) in
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
        guard let url = URL(string: "\(baseUrl)/post") else { return }
        
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
        guard let url = URL(string: "\(baseUrl)/post/\(id)") else { return }
        
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
