//
//  File.swift
//  
//
//  Created by Ade Dyas  on 06/11/21.
//

import Foundation

final class RandomFactory {
    static func randomString() -> String {
        return NSUUID().uuidString
    }
    
    static func randomInt() -> Int {
        return Int.random(in: 1..<100)
    }
    
    static func randomDouble() -> Double {
        return Double(randomInt())
    }
}
