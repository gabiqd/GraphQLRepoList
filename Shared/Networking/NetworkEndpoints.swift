//
//  NetworkEndpoints.swift
//  GraphQLRepoList
//
//  Created by Gabriel on 24/01/2021.
//

import Foundation

enum NetworkEndpoints {
    case repositories
    
    var url: URL?{
        let host = "api.github.com"
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        
        switch self {
        case .repositories:
            components.path = "/graphql"
        }
        
        return components.url
    }
    
    var httpMethod: String {
        switch self {
        case .repositories:
            return "POST"
        }
    }
}
