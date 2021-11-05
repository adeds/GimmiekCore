//
//  GameFavoritesInteractor.swift
//  Gimmiek
//
//  Created by Ade Dyas  on 27/10/21.
//

import Foundation
import Cleanse
import Combine

public protocol GameFavoritesInteractorProtocol {
    func getAllFavorites() -> AnyPublisher<[GameUiModel], Error>
    func deleteFavorites(_ gameId: Int?) -> AnyPublisher<Any?, Error>
}

public class GameFavoritesInteractor : GameFavoritesInteractorProtocol {

    let repository: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getAllFavorites() -> AnyPublisher<[GameUiModel], Error> {
        return repository.getAllFavorites().eraseToAnyPublisher()
    }
    
    public func deleteFavorites(_ gameId: Int?) -> AnyPublisher<Any?, Error> {
        return repository.deleteFavorites(gameId).eraseToAnyPublisher()
    }
}

public extension GameFavoritesInteractor {
    struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Unscoped>) {
            binder.bind(GameFavoritesInteractorProtocol.self).to(factory: GameFavoritesInteractor.init)
        }
    }
}
