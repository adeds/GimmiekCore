//
//  Endpoint.swift
//  Gimmiek
//
//  Created by Ade Dyas  on 23/10/21.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constant.rawgBaseUrl
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        print(url.absoluteString)
        return url
    }
    
    var headers: [String: Any] {
        return [:]
        //        ["header key": "header value"]
    }
    
    static var game: Self {
        return Endpoint(path: Constant.Path.games, queryItems: [
            URLQueryItem(name: "key", value: Constant.rawrgApiKey)
        ])
    }
    
    static func game(page: Int, keyword: String) -> Self {
        return Endpoint(path: Constant.Path.api+Constant.Path.games, queryItems: [
            URLQueryItem(name: "key", value: Constant.rawrgApiKey),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "search", value: keyword)
        ])
    }
}
