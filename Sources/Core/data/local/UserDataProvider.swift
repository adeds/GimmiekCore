//
//  UserDataProvider.swift
//  Gimmiek
//
//  Created by Ade Dyas  on 24/10/21.
//

import Foundation
import Combine
import Cleanse

public protocol UserDataProviderProtocol {
    func getName() -> AnyPublisher<String, Error>
    func setName(name:String) -> AnyPublisher<String, Error>
}

public class UserDataProvider : UserDataProviderProtocol {
    public func getName() -> AnyPublisher<String, Error> {
        let name = UserDefaults.standard.object(forKey: Constant.UserDefault.name) as? String ?? "Adetya Dyas Saputra"
        return Just(name).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    public func setName(name:String) -> AnyPublisher<String, Error> {
        UserDefaults.standard.set(name, forKey: Constant.UserDefault.name)
        return getName()
    }
}

public extension UserDataProvider {
    struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Unscoped>) {
            binder.bind(UserDataProviderProtocol.self).to {
                UserDataProvider.init()
            }
        }
    }
}
