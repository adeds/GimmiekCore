//
//  Constant.swift
//  Gimmiek
//
//  Created by Ade Dyas  on 14/08/21.
//
import Foundation

struct Constant {
    static let rawrgApiKey = "f35a5302fe024c59b9f0414f962201f9"
    static let rawgBaseUrl = "api.rawg.io"
    
    struct Path {
        static let api = "/api"
        static let games = "/games"
    }
    struct QueryName {
        static let key = "key"
        static let page = "page"
        static let search = "search"
    }
    
    struct CoreData {
        static let gameDataName = "game"
        static let gameDataModel = "GameDataModel"
    }
    
    struct UserDefault {
        static let name = "savedName"
    }
}
