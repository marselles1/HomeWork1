//
//  LoginViewController.swift
//  RequestsLesson
//
//  Created by marsel on 28.08.2020.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    //URL for VK authentication page
    private let authenticationURL  = "https://oauth.vk.com/authorize?client_id=7263779&display=touch&response_type=token&redirect_uri=http://oauth.vk.com/blank.html"
    
    //To wall controller segue identifier
    private let toWallSegueIdentifier = "toWallSegue"
    
    //Data Manager singleton
    var dataManager = DataManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: authenticationURL)!))
    }
    
    //MARK:- Web View navigation
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if let urlString = webView.url?.absoluteString.replacingOccurrences(of: "#", with: "?"), let urlParams = URL(string: urlString)?.queryParameters, let token = urlParams["access_token"] {
            
            webView.alpha = 0
            NetworkManager.singleton.token = token
            NetworkManager.singleton.getUser { [weak self] user in
                
                self?.dataManager.saveUser(user: user, token: token)
                self?.performSegue(withIdentifier: (self?.toWallSegueIdentifier)!, sender: user)
            }
        }
    }
    
    
    //MARK:- Segue navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == toWallSegueIdentifier, let user = sender as? UserModel {
            
            let destVC = segue.destination as! WallTableViewController
            destVC.user = user
        }
    }
}

