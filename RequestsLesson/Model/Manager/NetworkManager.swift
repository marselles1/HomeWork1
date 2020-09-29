//
//  NetworkManager.swift
//  RequestsLesson
//
//  Created by marsel on 28.08.2020.
//

import Foundation
import WebKit

class NetworkManager {
    
    //Self singleton
    static let singleton = NetworkManager()
    //Constant limit of posts to load
    private let intLimit = 10
    //VK Token
    var token: String = ""
    //Current loading offset
    var offset = 0
    //Current loading limit
    var limit = 10
    
    //MARK:- Models getters
    
    /// Function for getting User model from VK JSON
    /// - Parameter completion: Completion to work with received User model
    func getUser(completion: @escaping (UserModel) -> Void) {
        
        if let url = URL(string: getUserRequestURLLink(token: token)) {
            
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                
                guard let checkedData = data else { return }
                if let response = try? JSONDecoder().decode(UserRequestResponse.self, from: checkedData), let user = response.response.first {
                    
                    DispatchQueue.main.async {
                        completion(user)
                    }
                }
                else {
                    print("Error: Cannot decode JSON response")
                }
            })
            task.resume()
        }
    }
    
    
    ///Function for getting array of Post models from VK JSON
    /// - Parameter completion: Completion to work with received Post models
    func getPosts(completion: @escaping ([PostModel]) -> Void) {
        
        guard let url = URL(string: getPostsRequstURLLink(token: token, limit: limit, offset: offset)) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { [weak self] data, resp, error in
            
            self?.offset = self!.limit + 1
            self?.limit += (self?.intLimit)!
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let response = try? decoder.decode(PostsRequestResponse.self, from: data) {
                
                let posts = response.getPosts()
                if posts.isEmpty {
                    self?.limit -= (self?.intLimit)!
                }
                
                DispatchQueue.main.async {
                    completion(response.getPosts())
                }
            }
        }.resume()
    }
    
    //MARK:- Logout
    
    /// Function to clear web information
    /// - Parameter completion: Completion to clean cache
    func logout(completion: @escaping () -> Void) {
        
        limit = intLimit
        offset = 0
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: completion)
        }
    }
    
    
    //MARK:- Links getters
    
    /// Function for getting link for getting posts JSON from VK
    /// - Parameters:
    ///   - token: User's token
    ///   - limit: Current limit of posts
    ///   - offset: Current offset of posts
    private func getPostsRequstURLLink(token: String, limit: Int, offset: Int) -> String {
        return "https://api.vk.com/method/wall.get?count=\(limit)&offset=\(offset)&filter=owner&access_token=\(token)&v=5.103&extended=1"
    }
    
    /// Function for getting link for getting user JSON from VK
    /// - Parameter token: User's token
    private func getUserRequestURLLink(token: String) -> String {
        return "https://api.vk.com/method/users.get?fields=photo&access_token=\(token)&v=5.103"
    }
}
