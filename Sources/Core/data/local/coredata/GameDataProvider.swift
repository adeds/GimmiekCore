//
//  Persistence.swift
//  Gimmiek
//
//  Created by Ade Dyas  on 23/08/21.
//

import CoreData
import Cleanse
import Combine

open class PersistentContainer: NSPersistentContainer {
}

public class GameDataProvider {
    static let shared = GameDataProvider()
    
    lazy public var container: PersistentContainer? = {
        guard let modelURL = Bundle.module.url(forResource: Constant.CoreData.gameDataName, withExtension: "momd") else { return  nil }
            guard let model = NSManagedObjectModel(contentsOf: modelURL) else { return nil }
            let container = PersistentContainer(name: Constant.CoreData.gameDataName, managedObjectModel:model)
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    print("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    
    private struct GameContract {
        static let backgroundImage = "backgroundImage"
        static let gameId = "gameId"
        static let released = "gameReleased"
        static let updated = "gameUpdated"
        static let genres = "genres"
        static let name = "name"
        static let platforms = "platforms"
        static let  rating = "rating"
        static let  ratingTop = "ratingTop"
        static let screenshots = "screenshots"
        static let tags = "tags"
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = container!.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func addFavorites(_ gameEntity: GameEntity) -> Future<Any?, Error> {
        let taskContext = newTaskContext()
        
        return Future({ promise in
            taskContext.performAndWait {
                if let entity = NSEntityDescription.entity(forEntityName: Constant.CoreData.gameDataModel, in: taskContext) {
                    let game = NSManagedObject(entity: entity, insertInto: taskContext)
                    game.setValue(gameEntity.backgroundImage, forKeyPath: GameContract.backgroundImage)
                    game.setValue(gameEntity.gameId, forKeyPath: GameContract.gameId)
                    game.setValue(gameEntity.released, forKeyPath: GameContract.released)
                    game.setValue(gameEntity.updated, forKeyPath: GameContract.updated)
                    game.setValue(self.listToJsonString(list:gameEntity.genres), forKeyPath: GameContract.genres)
                    game.setValue(gameEntity.name, forKeyPath: GameContract.name)
                    game.setValue(self.listToJsonString(list:gameEntity.platforms), forKeyPath: GameContract.platforms)
                    game.setValue(gameEntity.rating, forKeyPath: GameContract.rating)
                    game.setValue(gameEntity.ratingTop, forKeyPath: GameContract.ratingTop)
                    game.setValue(self.listToJsonString(list:gameEntity.screenshots), forKeyPath: GameContract.screenshots)
                    game.setValue(self.listToJsonString(list:gameEntity.tags), forKeyPath: GameContract.tags)
                    
                    do {
                        try taskContext.save()
                        promise(.success(nil))
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
                
            }
        })
    }
    
    func deleteFavorites(_ gameId: Int?) -> Future<Any?, Error> {
        let taskContext = newTaskContext()
        return Future({ promise in
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.CoreData.gameDataModel)
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "gameId == \(gameId ?? 0)")
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                batchDeleteRequest.resultType = .resultTypeCount
                if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                    if batchDeleteResult.result != nil {
                        promise(.success(nil))
                    }
                }
            }
        })
    }
    
    func checkFavorites(_ gameId: Int?) -> Future<Bool, Error> {
        let taskContext = newTaskContext()
        
        return Future({ promise in
            taskContext.perform {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constant.CoreData.gameDataModel)
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "gameId == \(gameId ?? 0)")
                
                do {
                    if let result = try taskContext.fetch(fetchRequest).first {
                        if let name = result.value(forKey: "name") as? String {
                            promise(.success(!name.isEmpty))
                        } else {
                            promise(.success(false))
                        }
                    } else {
                        promise(.success(false))
                    }
                } catch let error as NSError {
                    promise(.failure(error))
                }
                
            }
        })
    }
    
    func getAllFavorites(localData: @escaping (Result<[GameEntity], Error>) -> Void) {
        let taskContext = newTaskContext()
        
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constant.CoreData.gameDataModel)
            
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: [GameEntity] = []
                
                for result in results {
                    let game = GameEntity(
                        gameId: Int(result.value(forKeyPath: GameContract.gameId) as? Int16 ?? 0),
                        name: result.value(forKeyPath: GameContract.name) as? String ?? " - ",
                        released: result.value(forKeyPath: GameContract.released) as? String ?? " - ",
                        updated: result.value(forKeyPath: GameContract.updated) as? String ?? " - ",
                        backgroundImage: result.value(forKeyPath: GameContract.backgroundImage) as? String ?? " - ",
                        rating: result.value(forKeyPath: GameContract.gameId) as? Double ?? 0.0,
                        ratingTop: Int(result.value(forKeyPath: GameContract.ratingTop) as? Int16 ?? 0),
                        platforms: self.jsonStringToList(jsonString: result.value(forKeyPath: GameContract.platforms) as? String ?? " - "),
                        genres: self.jsonStringToList(jsonString: result.value(forKeyPath: GameContract.genres) as? String ?? " - "),
                        screenshots: self.jsonStringToList(jsonString: result.value(forKeyPath: GameContract.screenshots) as? String ?? " - "),
                        tags: self.jsonStringToList(jsonString: result.value(forKeyPath: GameContract.tags) as? String ?? " - ")
                    )
                    
                    games.append(game)
                }
                localData(.success(games))
            } catch let error as NSError {
                localData(.failure(error))
            }
            
        }
        
    }
    
    private func listToJsonString(list : [String]) -> String {
        do {
            let data =  try JSONSerialization.data(withJSONObject:list, options: .prettyPrinted)
            let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
            return json ?? ""
        } catch {
            print(error)
            return ""
        }
    }
    
    private func jsonStringToList(jsonString : String) -> [String] {
        let data = jsonString.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String] {
                return jsonArray
            } else {
                print("Bad Json")
                return [String]()
            }
        } catch let error as NSError {
            print(error)
            return [String]()
        }
    }
}

public extension GameDataProvider {
    struct Module: Cleanse.Module {
        public static func configure(binder: Binder<Unscoped>) {
            binder.bind(GameDataProvider.self).to {
                GameDataProvider()
            }
        }
    }
}
