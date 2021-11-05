//
//  File.swift
//  
//
//  Created by Ade Dyas  on 06/11/21.
//

import Foundation
@testable import Core

final class GameFactory {
    static func createGame() -> Game {
        return Game(results: createGameResult(), next: RandomFactory.randomString())
    }
    
    private static func createGameResult() -> [GameResult] {
        var gamne = [GameResult]()
        gamne.append(randomGameResult())
        gamne.append(randomGameResult())
        gamne.append(randomGameResult())
        return gamne
    }
    
    private static func randomGameResult() -> GameResult {
        return GameResult(id: RandomFactory.randomInt(),
                          name: RandomFactory.randomString(),
                          released: RandomFactory.randomString(),
                          backgroundImage: RandomFactory.randomString(),
                          updated: RandomFactory.randomString(),
                          rating: RandomFactory.randomDouble(),
                          ratingTop: RandomFactory.randomInt(),
                          platforms: createPlatforms(),
                          genres: createGenres(),
                          tags: createGenres(),
                          shortScreenshots: createScreenShots())
    }
    
    private static func createScreenShots() -> [ShortScreenshot] {
        var screenshots = [ShortScreenshot]()
        screenshots.append(randomShortScreenshot())
        screenshots.append(randomShortScreenshot())
        screenshots.append(randomShortScreenshot())
        return screenshots
    }
    
    private static func createPlatforms() -> [PlatformElement] {
        var platforms = [PlatformElement]()
        platforms.append(randomPlatformElement())
        platforms.append(randomPlatformElement())
        platforms.append(randomPlatformElement())
        return platforms
    }
    
    private static func createGenres() -> [Genre] {
        var genres = [Genre]()
        genres.append(randomGenre())
        genres.append(randomGenre())
        genres.append(randomGenre())
        return genres
    }
    
    private static func randomPlatformElement() -> PlatformElement {
        return PlatformElement(platform: PlatformPlatform(name: RandomFactory.randomString()))
    }
    
    private static func randomGenre() -> Genre {
        return Genre(id: RandomFactory.randomInt(), name: RandomFactory.randomString())
    }
    
    private static func randomShortScreenshot() -> ShortScreenshot {
        return ShortScreenshot(id: RandomFactory.randomInt(), image: RandomFactory.randomString())
    }
}
