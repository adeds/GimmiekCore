//
//  GameRepository.swift
//  Gimmiek
//
//  Created by Ade Dyas  on 21/10/21.
//

import Foundation
import Combine
import Cleanse

public protocol GameRepositoryProtocol {
    
    func loadMore(page:Int, keyword: String) -> Future<[GameUiModel], Error>
    func deleteFavorites(_ gameId: Int?) -> Future<Any?, Error>
    func addFavorites(_ gameUiModel: GameUiModel) -> Future<Any?, Error>
    func checkFavorites(_ gameId: Int?) -> Future<Bool, Error>
    func getAllFavorites()  -> Future<[GameUiModel], Error>
}

public final class GameRepository : GameRepositoryProtocol {
    
    let networker: NetworkerProtocol
    
    let gameDataProvider: GameDataProvider
    private var cancellables = Set<AnyCancellable>()
    
    init(networker: NetworkerProtocol, gameDataProvider: GameDataProvider) {
        self.networker = networker
        self.gameDataProvider = gameDataProvider
    }
    
    public func loadMore(page: Int, keyword: String) -> Future<[GameUiModel], Error> {
        let endpoint = Endpoint.game(page: page, keyword: keyword)
        return Future { promise in
            self.networker.getGame(url: endpoint.url) { result in
                switch result {
                case .success(let response):
                    promise(.success(GameMapper.mapToUiModel(input: response)))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    public func deleteFavorites(_ gameId: Int?) -> Future<Any?, Error> {
        return gameDataProvider.deleteFavorites(gameId)
    }
    
    public func addFavorites(_ gameUiModel: GameUiModel) -> Future<Any?, Error> {
        return gameDataProvider.addFavorites(GameMapper.mapToUiEntity(input: gameUiModel))
    }
    
    public func checkFavorites(_ gameId: Int?) -> Future<Bool, Error> {
        return gameDataProvider.checkFavorites(gameId)
    }
    
    public func getAllFavorites() -> Future<[GameUiModel], Error> {
        return Future { promise in
            self.gameDataProvider.getAllFavorites { localData in
                switch localData {
                case .success(let entities):
                    promise(.success(GameMapper.mapToUiModel(input: entities)))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
}

public extension GameRepository {
    struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Unscoped>) {
            binder.bind(GameRepositoryProtocol.self).to(factory: GameRepository.init)
        }
    }
}
