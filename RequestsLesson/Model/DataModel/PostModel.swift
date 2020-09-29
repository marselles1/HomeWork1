//
//  PostModel.swift
//  RequestsLesson
//
//  Created by marsel on 28.08.2020.
//

import Foundation

//Post model to use in app
struct PostModel: Codable {
    
    var id: Int
    var text: String?
    var image: String?
    var likes: Int
    var comments: Int
    var reposts: Int
    var date: Date
    
    init(id: Int, text: String?, likes: Int, comments: Int, reposts: Int, date: Date, image: String?) {
        
        self.id = id
        self.text = text
        self.likes = likes
        self.comments = comments
        self.reposts = reposts
        self.date = date
        self.image = image
    }
}
