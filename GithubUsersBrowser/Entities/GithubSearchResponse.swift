//
//  GithubSearchResponse.swift
//  GithubUsersBrowser
//
//  Created by Stanislav Kaliberov on 4/2/18.
//  Copyright © 2018 Stanislav Kaliberov. All rights reserved.
//

import Foundation

final class GithubUsersResponse: Codable {
    var total_count: Int
    var incomplete_results: Bool?
    var items: [UserPlainModel]
    
    enum CodingKeys : String, CodingKey {
        case total_count
        case incomplete_results
        case items
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total_count = try values.decode(Int.self, forKey: .total_count)
        incomplete_results = try values.decode(Bool.self, forKey: .incomplete_results)
        items = try values.decode([UserPlainModel].self, forKey: .items)
    }
}

final class GithubErrorResponse: Codable {
    
    enum GitError: Error {
        case message(String?)
        
        var description: String? {
            switch self {
            case .message(let text): return text
            }
        }
    }
    
    enum CodingKeys : String, CodingKey {
        case message
        case documentation_url
    }
    
    var message: String?
    var documentation_url: String?
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decode(String.self, forKey: .message)
        documentation_url = try values.decode(String.self, forKey: .documentation_url)
    }
}
