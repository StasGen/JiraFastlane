//
//  GithubApiConst.swift
//  GithubUsersBrowser
//
//  Created by Stanislav Kaliberov on 4/2/18.
//  Copyright © 2018 Stanislav Kaliberov. All rights reserved.
//

import Foundation


struct GithubApi {
    
    static let BaseURL = "https://api.github.com"
    
    enum Endpoint {
        case searchUsers
        
        public var path: String {
            var endpoint: String
            switch self {
            case .searchUsers:
                endpoint = "/search/users"
            }
            
            return GithubApi.BaseURL + endpoint
        }
    }
    
    enum SortKey {
        static let stars = "stars"
    }
    
    enum ParamKey {
        static let searchText = "q"
        static let sort = "sort"
        static let page = "page"
        static let perPage = "per_page"
    }
}
