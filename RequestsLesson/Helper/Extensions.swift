//
//  Extensions.swift
//  RequestsLesson
//
//  Created by marsel on 28.08.2020.
//

import Foundation
import UIKit

//Taken from StackOverflow for getting parameters from URL
extension URL {
    
    public var queryParameters: [String: String]? {
        
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

//Taken from HackingWithSwift for image loading
extension UIImageView {
    
    func load(url: URL) {
        
        DispatchQueue.global().async { [weak self] in
            
            if let data = try? Data(contentsOf: url) {
                
                if let image = UIImage(data: data) {
                    
                    DispatchQueue.main.async {
                        
                        self?.image = image
                    }
                }
            }
        }
    }
}

//Extension for converting from CoreData model to Structure model
extension User {
    
    func convertToModel() -> UserModel {
        return UserModel(id: Int(self.id), firstName: self.firstName ?? "", lastName: self.lastName ?? "", photo: self.photo ?? "", token: self.token ?? "")
    }
}

//Extension for converting from CoreData model to Structure model
extension Post {
    
    func convertToModel() -> PostModel {
        return PostModel(id: Int(self.id), text: self.text ?? "", likes: Int(self.likes), comments: Int(self.reposts), reposts: Int(self.comments), date: self.date ?? Date(timeIntervalSince1970: TimeInterval(exactly: 0)!), image: self.image ?? "")
    }
}
