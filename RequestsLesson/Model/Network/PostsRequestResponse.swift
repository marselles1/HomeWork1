//
//  PostsRequestResponse.swift
//  RequestsLesson
//
//  Created by marsel on 28.08.2020.
//

import Foundation

struct PostsRequestResponse: Codable {
    
    //VK Response from JSON
    let response: Response

    init(response: Response) {
        self.response = response
    }
    
    
    /// Function for getting array of post models from JSON
    func getPosts() -> [PostModel] {
        
        var posts = [PostModel]()
        
        for item in response.items {
            
            let id = item.id
            let text = item.text
            let likes = item.likes.count
            let comments = item.comments.count
            let reposts = item.reposts.count
            let date = Date(timeIntervalSince1970: TimeInterval(exactly: item.date)!)
            let image = item.attachments?.first?.photo.sizes.last?.url
 
            let post = PostModel(id: id, text: text, likes: likes, comments: comments, reposts: reposts, date: date, image: image)
            
            posts.append(post)
        }
        
        return posts
    }
}

// MARK: - Response

//VK Response from JSON
struct Response: Codable {
    
    let count: Int
    let items: [Item]

    init(count: Int, items: [Item]) {
        
        self.count = count
        self.items = items
    }
}

//MARK: - Item

//VK Item from JSON
struct Item: Codable {
    
    let id, date: Int
    let text: String
    let attachments: [Attachment]?
    let comments: Comments
    let likes: Likes
    let reposts: Reposts

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case text
        case attachments
        case comments, likes, reposts
    }
    
    init(id: Int, date: Int, text: String, attachments: [Attachment], comments: Comments, likes: Likes, reposts: Reposts) {
        
        self.id = id
        self.date = date
        self.text = text
        self.attachments = attachments
        self.comments = comments
        self.likes = likes
        self.reposts = reposts
    }
}

//MARK: - Attachment

//VK Attachment from JSON
struct Attachment: Codable {
    
    let type: String
    let photo: Photo

    init(type: String, photo: Photo) {
        self.type = type
        self.photo = photo
    }
}

//MARK: - Photo

//VK Photo from JSON
struct Photo: Codable {
    
    let id: Int
    let sizes: [Size]
    let text: String
    let date: Int

    enum CodingKeys: String, CodingKey {
        case id
        case sizes, text, date
    }

    init(id: Int, sizes: [Size], text: String, date: Int) {
        self.id = id
        self.sizes = sizes
        self.text = text
        self.date = date
    }
}

//MARK: - Size

//VK Size from JSON
struct Size: Codable {
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
}

//MARK: - Comments

//VK Comments from JSON
struct Comments: Codable {
    
    let count: Int

    enum CodingKeys: String, CodingKey {
        case count
    }

    init(count: Int) {
        self.count = count
    }
}

//MARK: - Likes

//VK Likes from JSON
struct Likes: Codable {
    
    let count, canLike: Int

    enum CodingKeys: String, CodingKey {
        
        case count
        case canLike
    }

    init(count: Int, canLike: Int) {
        
        self.count = count
        self.canLike = canLike
    }
}

// MARK: - Reposts

//VK Reposts from JSON
struct Reposts: Codable {
    
    let count: Int

    enum CodingKeys: String, CodingKey {
        case count
    }

    init(count: Int) {
        self.count = count
    }
}

