//
//  WallTableViewController.swift
//  RequestsLesson
//
//  Created by marsel on 28.08.2020.
//

import UIKit

class WallTableViewController: UITableViewController {
    
    //Post Cell Nib Name
    private let postCellNibName = "PostTableViewCell"
    //Post Cell Reuse Identifier
    private let postCellReuseIdentifier = "PostCell"
    //Network Manager singleton
    let networkManager = NetworkManager.singleton
    //Data Manager singleton
    let dataManager = DataManager.singleton
    //Back to login controller segue identifier
    let backToLoginSegueIdentifier = "backToLoginController"
    
    //Logged in user
    var user: UserModel!
    //Array of posts
    var posts: [PostModel] = []
    //Is data loading right now
    var isDataLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: postCellNibName, bundle: nil), forCellReuseIdentifier: postCellReuseIdentifier)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        navigationItem.setHidesBackButton(true, animated: false)
        
        networkManager.getPosts { [weak self] posts in
            
            self?.posts = posts
            self?.dataManager.deleteAllPosts() { isOk in
                
                if isOk {
                    self?.dataManager.savePosts(posts: posts)
                }
            }
            self?.isDataLoading = false
            self?.tableView.reloadData()
        }
        
        dataManager.getPosts() { [weak self] posts in
            
            self?.posts = posts
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: postCellReuseIdentifier, for: indexPath) as! PostTableViewCell
        cell.configure(user: user, post: posts[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Scrolling navigation
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if tableView.contentOffset.y >= tableView.contentSize.height - tableView.frame.size.height, !isDataLoading {
            
            isDataLoading = true
            networkManager.getPosts() { [weak self] posts in
                
                if !posts.isEmpty {
                    
                    self?.posts += posts
                    self?.tableView.reloadData()
                    self?.isDataLoading = false
                }
            }
        }
    }
    
    //MARK:- Button actions
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        networkManager.logout() { [weak self] in
            
            guard let self = self else { return }
            self.dataManager.deleteAllInformationAboutUser() { success in
                
                self.performSegue(withIdentifier: self.backToLoginSegueIdentifier, sender: nil)
            }
        }
    }
    
}
