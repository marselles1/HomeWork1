//
//  PostTableViewCell.swift
//  RequestsLesson
//
//  Created by Евгений on 29.12.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameAndSurnameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImageImageView: UIImageView!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    @IBOutlet weak var numberOfRepostsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.bounds.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    /// Function for cell configuration
    /// - Parameters:
    ///   - user: User model to configure cell with
    ///   - post: Post model to configure cell with
    func configure(user: UserModel, post: PostModel) {
        userNameAndSurnameLabel.text = "\(user.firstName) \(user.lastName)"
        userAvatarImageView.load(url: URL(string: user.photo)!)
        let reformatedDate = DateManager.singleton.reformDate(post.date)
        postDateLabel.text = "\(reformatedDate)"
        
        if let postText = post.text {
            postTextLabel.text = postText
        } else {
            postTextLabel.isHidden = true
        }
        
        if let imageLink = post.image, let url = URL(string: imageLink) {
            postImageImageView.load(url: url)
        } else {
            postImageImageView.isHidden = true
        }
        
        numberOfLikesLabel.text = "\(post.likes)"
        numberOfRepostsLabel.text = "\(post.reposts)"
        numberOfCommentsLabel.text = "\(post.comments)"
        
    }
    
    override func prepareForReuse() {
        
        postImageImageView.isHidden = false
        postImageImageView.image = nil
        postTextLabel.isHidden = false
    }
    
}
