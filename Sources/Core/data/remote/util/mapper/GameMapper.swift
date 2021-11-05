//
//  GameMapper.swift
//  Gimmiek
//
//  Created by Ade Dyas  on 28/10/21.
//

import Foundation

final class GameMapper {
    
    static func mapToUiModel(
        input game: Game
    ) -> [GameUiModel] {
        return game.results.map { itemGame in
            GameUiModel(
                gameId: itemGame.id,
                name: itemGame.name ?? " - ",
                released: itemGame.released ?? " - ",
                updated: itemGame.updated ?? " - ",
                backgroundImage: itemGame.backgroundImage,
                rating: itemGame.rating ?? 0.0,
                ratingTop: itemGame.ratingTop ?? 0,
                platforms: self.getPlatform(itemGame.platforms),
                genres: self.getGenresAndTags(itemGame.genres),
                screenshots: self.getScreenshots(itemGame.shortScreenshots),
                tags: self.getGenresAndTags(itemGame.tags))
        }
    }
    
    static func mapToUiModel(
        input game: [GameEntity]
    ) -> [GameUiModel] {
        return game.map { itemGame in
            GameUiModel(
                gameId: itemGame.gameId,
                name: itemGame.name,
                released: itemGame.released,
                updated: itemGame.updated,
                backgroundImage: itemGame.backgroundImage,
                rating: itemGame.rating,
                ratingTop: itemGame.ratingTop,
                platforms: itemGame.platforms,
                genres: itemGame.genres,
                screenshots: itemGame.screenshots,
                tags: itemGame.tags)
        }
    }
    
    static func mapToUiEntity(
        input itemGame: GameUiModel
    ) -> GameEntity {
        return GameEntity(
            gameId: itemGame.gameId,
            name: itemGame.name,
            released: itemGame.released,
            updated: itemGame.updated,
            backgroundImage: itemGame.backgroundImage,
            rating: itemGame.rating,
            ratingTop: itemGame.ratingTop,
            platforms: itemGame.platforms,
            genres: itemGame.genres,
            screenshots: itemGame.screenshots,
            tags: itemGame.tags)
        
    }
    
    private static func getPlatform(_ platforms: [PlatformElement]?) -> [String] {
        guard let platforms = platforms else {
            return [String]()
        }
        return platforms.compactMap { $0.platform?.name }
    }
    
    private static func getGenresAndTags(_ genres: [Genre]?) -> [String] {
        guard let genres = genres else {
            return [String]()
        }
        return genres.compactMap { $0.name }
    }
    
    private static func getScreenshots(_ screenshots: [ShortScreenshot]?) -> [String] {
        guard let screenshots = screenshots else {
            return [String]()
        }
        return screenshots.compactMap { $0.image }
    }
}
