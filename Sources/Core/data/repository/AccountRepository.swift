//
//  AccountRepository.swift
//  Gimmiek
//
//  Created by Ade Dyas  on 24/10/21.
//

import Foundation
import Combine
import Cleanse

public protocol AccountRepositoryProtocol {
    func getName() -> AnyPublisher<String, Error>
    func setName(name:String) -> AnyPublisher<String, Error>
}

public class AccountRepository : AccountRepositoryProtocol {
    
    let userDataProvider: UserDataProviderProtocol
    
    init(userDataProvider: UserDataProviderProtocol) {
        self.userDataProvider = userDataProvider
    }
    
    public func getName() -> AnyPublisher<String, Error> {
        return userDataProvider.getName()
    }
    
    public func setName(name:String) -> AnyPublisher<String, Error> {
        return userDataProvider.setName(name: name)
    }
    
}

public extension AccountRepository {
    struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Unscoped>) {
            binder.bind(AccountRepositoryProtocol.self).to(factory: AccountRepository.init)
        }
    }
}
