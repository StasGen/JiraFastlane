//
//  GithubApiDataLoader.swift
//  GitBrowser
//
//  Created by Станислав Калиберов on 02.12.2017.
//  Copyright © 2017 Станислав Калиберов. All rights reserved.
//

import Foundation


final class GithubApiLoader {
    
    static let shared = GithubApiLoader()
    
    typealias UsersCompletion = ([UserPlainModel]?, Error?) -> ()
    
    lazy var networkService = NetworkService()
    
    
    func searchUsers(searchText: String, pagination: Pagination, completion: @escaping UsersCompletion) {
        let url = URL(string: GithubApi.Endpoint.searchUsers.path)!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let queryItems = [
            URLQueryItem(name: GithubApi.ParamKey.searchText, value: searchText),
            URLQueryItem(name: GithubApi.ParamKey.sort, value: GithubApi.SortKey.stars),
            URLQueryItem(name: GithubApi.ParamKey.page, value: String(pagination.page)),
            URLQueryItem(name: GithubApi.ParamKey.perPage, value: String(pagination.itemsPerPage))
        ]
        components?.queryItems = queryItems
        
        networkService.getRequest(url: (components?.url)!) { result in
            switch result {
            case .success(let data):
                self.handleOnSuccess(data: data, completion: completion)
                
            case .failure(let data, let error):
                self.handleOnError(error: error, data: data, completion: completion)
            }
        }
    }
    
    
    //MARK: - Private
    private func handleOnSuccess(data: Data, completion: UsersCompletion?) {
        let decoder = JSONDecoder()
        do {
            let gitResponse = try decoder.decode(GithubUsersResponse.self, from: data)
            completion?(gitResponse.items, nil)
            
        } catch {
            completion?(nil, error)
        }
    }
    
    private func handleOnError(error: Error?, data: Data?, completion: UsersCompletion?) {
        if let _data = data {
            let decoder = JSONDecoder()
            do {
                let errorResponse = try decoder.decode(GithubErrorResponse.self, from: _data)
                completion?(nil, GithubErrorResponse.GitError.message(errorResponse.message))
            } catch {
                return
            }
            
        } else {
            completion?(nil, error)
        }
    }
}
