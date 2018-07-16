//
//  GithubUserPlain.swift
//  GithubUsersBrowser
//
//  Created by Stanislav Kaliberov on 4/2/18.
//  Copyright © 2018 Stanislav Kaliberov. All rights reserved.
//

import UIKit

class UserPlainModel: Codable, Equatable {
    var id: Int
    var login: String
    var url: String?
    var score: Double
    var avatarUrl: String?
    var viewed = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case url = "html_url"
        case score
        case avatarUrl = "avatar_url"
    }
    
    init(id: Int, login: String, url: String?, score: Double, avatarUrl: String?) {
        self.id = id
        self.login = login
        self.url = url
        self.score = score
        self.avatarUrl = avatarUrl
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        login = try values.decode(String.self, forKey: .login)
        url = try values.decode(String?.self, forKey: .url)
        score = try values.decode(Double.self, forKey: .score)
        avatarUrl = try values.decode(String?.self, forKey: .avatarUrl)
    }
    
    func colorByScore() -> UIColor {
        if score > 5 {
            if score > 10 {
                if score > 13 {
                    if score > 17 {
                        return .red
                    } else {
                        return .orange
                    }
                } else {
                    return .green
                }
            } else {
                return .blue
            }
        } else {
            return .gray
        }
    }
}

func ==(lhs: UserPlainModel, hrs: UserPlainModel) -> Bool {
    if lhs.id == hrs.id, lhs.login == hrs.login, lhs.url == hrs.url, lhs.score == hrs.score, lhs.avatarUrl == hrs.avatarUrl {
        return true
    }
    return false
}
