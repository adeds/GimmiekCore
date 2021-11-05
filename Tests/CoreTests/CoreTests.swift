import XCTest
@testable import Core

final class CoreTests: XCTestCase {
    func testExample() {
        let games = GameFactory.createGame()
        let gameUiModel = GameMapper.mapToUiModel(input: games)
        
        XCTAssertEqual(games.results.count, gameUiModel.count)
        
        for (index, game) in games.results.enumerated() {
            XCTAssertEqual(game.id, gameUiModel[index].gameId)
            XCTAssertEqual(game.name, gameUiModel[index].name)
            XCTAssertEqual(game.released, gameUiModel[index].released)
            XCTAssertEqual(game.updated, gameUiModel[index].updated)
            XCTAssertEqual(game.backgroundImage, gameUiModel[index].backgroundImage)
            XCTAssertEqual(game.rating, gameUiModel[index].rating)
            XCTAssertEqual(game.ratingTop, gameUiModel[index].ratingTop)
            XCTAssertEqual(game.platforms?.compactMap({ element in
                element.platform?.name
            }), gameUiModel[index].platforms)
            
            XCTAssertEqual(game.genres?.compactMap { $0.name }, gameUiModel[index].genres)
            XCTAssertEqual(game.shortScreenshots?.compactMap { $0.image }, gameUiModel[index].screenshots)
            XCTAssertEqual(game.tags?.compactMap { $0.name }, gameUiModel[index].tags)
        }
    }
}
