//
//  GameUiModel.swift
//  Gimmiek
//
//  Created by Ade Dyas  on 14/08/21.
//

public class GameUiModel {
    public var gameId: Int?
    public var name, released, updated: String
    public var backgroundImage: String
    public var rating: Double
    public var ratingTop: Int
    public var platforms, genres, screenshots, tags: [String]
    
    init(
        gameId: Int?, name: String,
        released: String, updated: String,
        backgroundImage: String?,
        rating: Double, ratingTop: Int,
        platforms: [String], genres: [String], screenshots: [String], tags: [String]
    ) {
        self.gameId = gameId
        self.name = name
        self.released = released
        self.updated = updated
        self.backgroundImage = backgroundImage ?? ""
        self.rating = rating
        self.ratingTop = ratingTop
        self.platforms = platforms
        self.genres = genres
        self.screenshots = screenshots
        self.tags = tags
    }
}
