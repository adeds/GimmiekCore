//
//  GameInteractor.swift
//  Gimmiek
//
//  Created by Ade Dyas  on 21/10/21.
//

import Foundation
import Combine
import Cleanse

public protocol GameInteractorProtocol {
    func loadMore(page:Int, keyword:String) -> AnyPublisher<[GameUiModel], Error>
}

public class GameInteractor: GameInteractorProtocol {
    
    let repository: GameRepositoryProtocol
    
    private var isLastPage = false
    private var keyword = ""
    private var prevList : [GameUiModel] = [GameUiModel]()
    
    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    public func loadMore(page: Int, keyword:String) -> AnyPublisher<[GameUiModel], Error> {
        let result = repository.loadMore(page: page, keyword:keyword)
        if isLastPage {
            let noFetch = Just(prevList)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            return noFetch
        }
    
        return result.map { game in
            let isNewKeyword = self.keyword != keyword
            self.isLastPage = game.isEmpty && !isNewKeyword
            self.keyword = keyword
            if isNewKeyword {
                self.prevList.removeAll()
            }
            self.prevList.append(contentsOf: game)
            return self.prevList
        }.eraseToAnyPublisher()}
}

public extension GameInteractor {
    struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Unscoped>) {
            binder.bind(GameInteractorProtocol.self).to(factory: GameInteractor.init)
        }
    }
}
