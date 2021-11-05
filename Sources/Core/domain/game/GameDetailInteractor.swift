//
//  GameDetailInteractor.swift
//  Gimmiek
//
//  Created by Ade Dyas  on 24/10/21.
//

import Foundation
import Cleanse
import Combine

public protocol GameDetailInteractorProtocol {
    func changeFavorites(_ gameUiModel: GameUiModel?) -> AnyPublisher<Bool, Error>
    func checkFavorites(_ gameId: Int) -> AnyPublisher<Bool, Error>
}

public class GameDetailInteractor: GameDetailInteractorProtocol {
    
    let repository: GameRepositoryProtocol
    
    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    public func changeFavorites(_ gameUiModel: GameUiModel?) -> AnyPublisher<Bool, Error> {
        guard let game = gameUiModel else {
            print("game nil, load game first")
            return Empty().eraseToAnyPublisher()
        }
        return repository.checkFavorites(game.gameId).map { isFavorite in
            _ = isFavorite ? self.repository.deleteFavorites(game.gameId) : self.repository.addFavorites(game)
            return !isFavorite
        }.eraseToAnyPublisher()
    }
    
    public func checkFavorites(_ gameId: Int) -> AnyPublisher<Bool, Error> {
        return repository.checkFavorites(gameId).eraseToAnyPublisher()
    }
}

public extension GameDetailInteractor {
    struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Unscoped>) {
            binder.bind(GameDetailInteractorProtocol.self).to(factory: GameDetailInteractor.init)
        }
    }
}
