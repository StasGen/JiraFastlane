//
//  UserTableViewCell.swift
//  GithubUsersBrowser
//
//  Created by Stanislav Kaliberov on 4/2/18.
//  Copyright © 2018 Stanislav Kaliberov. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var viewed: UILabel!
    
    
    let rotationAngle: CGFloat
    
    required init?(coder aDecoder: NSCoder) {
        rotationAngle = -.pi/4
        
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = bounds.height/2
        viewed.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    func configure(user: UserPlainModel) {
        name.text = user.login
        score.text = user.score.description
        
        URLSession.shared.dataTask(with: URL(string: user.avatarUrl!)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.sync() {
                self.avatar.image = UIImage(data: data)
            }
        }.resume()
        
        
        name.textColor = user.colorByScore()
        
        viewed.isHidden = !user.viewed
    }
    
    func configureAppearence(value: CGFloat) {
        contentView.alpha = 1 - value
    }
}

