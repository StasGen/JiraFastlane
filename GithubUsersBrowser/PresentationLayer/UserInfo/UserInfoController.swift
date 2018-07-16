//
//  UserViewController.swift
//  GithubUsersBrowser
//
//  Created by Stanislav Kaliberov on 4/3/18.
//  Copyright © 2018 Stanislav Kaliberov. All rights reserved.
//

import UIKit

protocol UsersViewControllerDelegate {
    func userDidViewed(user: UserPlainModel)
}


class UserViewController: UIViewController {
    
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var id: UILabel!
    
    var user: UserPlainModel!
    var delegate: UsersViewControllerDelegate?
    
    override func viewDidLoad() {
        navigationTitle.text = "User Info"
        
        
        URLSession.shared.dataTask(with: URL(string: user.avatarUrl!)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.sync() {
                self.avatar.image = UIImage(data: data)
            }
        }.resume()
        
        
        var godLevel = ""
        
        if user.score > 5 {
            if user.score > 10 {
                if user.score > 13 {
                    if user.score > 17 {
                        godLevel = "👽"
                    } else {
                        godLevel = "🤖"
                    }
                } else {
                    godLevel = "🧔"
                }
            } else {
                godLevel = "👱‍♂️"
            }
        } else {
            godLevel = "👶"
        }
        
        name.text = user.login + godLevel
        score.text = "Score: " + user.score.description
        id.text = "User ID: " + user.id.description
    }
    
    override func viewDidAppear(_ animated: Bool) {
        delegate?.userDidViewed(user: user)
    }
    
    
    @IBAction func onBackDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
