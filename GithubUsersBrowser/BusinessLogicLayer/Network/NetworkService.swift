//
//  NetworkService.swift
//  GithubUsersBrowser
//
//  Created by Stanislav Kaliberov on 4/2/18.
//  Copyright © 2018 Stanislav Kaliberov. All rights reserved.
//

import Foundation

final class NetworkService {
    
    enum Result {
        case success(Data)
        case failure(Data?, Error?)
    }
    
    func getRequest(url: URL, completion: @escaping (Result)->()) {
        let urlSession = URLSession.shared
        
        urlSession.dataTask(with: url) { (data, response, error) in
            switch (data, response, error) {
            case (let data, let response as HTTPURLResponse, nil) where 200...299 ~= response.statusCode:
                guard let data = data else { fallthrough }
                completion(.success(data))
                
            default:
                completion(.failure(data, error))
            
            }
        }
        .resume()
    }
}
