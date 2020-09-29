//
//  DataManager.swift
//  RequestsLesson
//
//  Created by marsel on 28.08.2020.
//

import Foundation
import CoreData

class DataManager {
    
    static let singleton = DataManager()
    
    private init() { }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RequestsLesson")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - User Functions
    
    /// Function for saving User model in CoreData
    /// - Parameters:
    ///   - user: User model itself
    ///   - token: User's token
    func saveUser(user: UserModel, token: String) {
        
        DispatchQueue.global().async { [weak self] in
            
            guard let self = self else { return }
            let userModel = User(context: self.persistentContainer.viewContext)
            userModel.id = Int64(user.id)
            userModel.firstName = user.firstName
            userModel.lastName = user.lastName
            userModel.photo = user.photo
            userModel.token = token
            self.saveContext()
        }
    }
    
    /// Function for getting User model from CoreData
    /// - Parameter completion: Completion to work with received User model
    func getUser(completion: @escaping (UserModel?) -> Void) {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        DispatchQueue.global().async { [weak self] in
            
            if let user = try? self?.persistentContainer.viewContext.fetch(fetchRequest).first {
                
                DispatchQueue.main.async {
                    completion(user.convertToModel())
                }
            }
            else {
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    //MARK:- Posts functions
    
    /// Function for saving Post modesl in CoreData
    /// - Parameter posts: Posts array itself
    func savePosts(posts: [PostModel]) {
        
        DispatchQueue.global().async { [weak self] in
            
            guard let self = self else { return }
            for post in posts {
                
                let postModel = Post(context: self.persistentContainer.viewContext)
                postModel.id = Int64(post.id)
                postModel.text = post.text
                postModel.reposts = Int64(post.reposts)
                postModel.comments = Int64(post.comments)
                postModel.likes = Int64(post.likes)
                postModel.date = post.date
                postModel.image = post.image
            }
            self.saveContext()
        }
    }
    
    /// Function for getting Post models from CoreData
    /// - Parameter completion: Completion to work with received Post models
    func getPosts(completion: @escaping ([PostModel]) -> Void) {
        
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        
        DispatchQueue.global().async { [weak self] in
            
            if let posts = try? self?.persistentContainer.viewContext.fetch(fetchRequest), !posts.isEmpty {
                
                DispatchQueue.main.async {
                    completion(posts.map({ $0.convertToModel() }))
                }
            }
            else {
                
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    // MARK:- Deleting functions
    
    /// Function for deleting all posts from CoreData
    /// - Parameter completion: Completion to claim success
    func deleteAllPosts(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.global().async { [weak self] in
            
            guard let self = self else { return }
            let postsDeleteRequest = NSBatchDeleteRequest(fetchRequest: Post.fetchRequest())
            do {
                
                try self.persistentContainer.viewContext.execute(postsDeleteRequest)
                self.saveContext()
                DispatchQueue.main.async {
                    
                    completion(true)
                }
            }
            catch {
                completion(false)
            }
        }
    }
    
    /// Function for deleting all information about current user from CoreData
    /// - Parameter completion: Completion to claim success
    func deleteAllInformationAboutUser(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.global().async { [weak self] in
            
            guard let self = self else { return }
            let userDeleteRequest = NSBatchDeleteRequest(fetchRequest: User.fetchRequest())
            let postsDeleteRequest = NSBatchDeleteRequest(fetchRequest: Post.fetchRequest())
            
            do {
                
                try self.persistentContainer.viewContext.execute(userDeleteRequest)
                try self.persistentContainer.viewContext.execute(postsDeleteRequest)
                self.saveContext()
                
                DispatchQueue.main.async {
                    completion(true)
                }
            }
            catch {
                completion(false)
            }
        }
    }
}
