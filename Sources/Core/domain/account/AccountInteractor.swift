//
//  AccountInteractor.swift
//  Gimmiek
//
//  Created by Ade Dyas  on 24/10/21.
//

import Foundation
import Combine
import Cleanse

public protocol AccountInteractorProtocol {
    func getName() -> AnyPublisher<String, Error>
    func setName(name:String) -> AnyPublisher<String, Error>
}

public class AccountInteractor : AccountInteractorProtocol {
    let accountRepository: AccountRepositoryProtocol
    
    init(accountRepository: AccountRepositoryProtocol) {
        self.accountRepository = accountRepository
    }
    public func getName() -> AnyPublisher<String, Error> {
        return accountRepository.getName()
    }
    
    public func setName(name:String) -> AnyPublisher<String, Error> {
        return accountRepository.setName(name: name)
    }
}

public extension AccountInteractor {
    struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Unscoped>) {
            binder.bind(AccountInteractorProtocol.self).to(factory: AccountInteractor.init)
        }
    }
}
