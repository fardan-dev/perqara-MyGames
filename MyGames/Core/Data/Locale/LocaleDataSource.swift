//
//  LocaleDataSource.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 15/08/23.
//

import Foundation
import CoreData
import Combine

protocol LocaleDataSourceProtocol {
  func addFavouriteGame(gameModel: GameModel) -> AnyPublisher<Bool, Error>
  func getFavouritesList() -> AnyPublisher<[GameModel], Error>
  func getFavouriteGame(gameId: String) -> AnyPublisher<GameModel, Error>
}

final class LocaleDataSource: NSObject {
  static let sharedInstance = LocaleDataSource()
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MyGames")
    
    container.loadPersistentStores { _, error in
      guard error == nil else {
        fatalError("Unresolved error \(error!)")
      }
    }
    
    container.viewContext.automaticallyMergesChangesFromParent = false
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    container.viewContext.shouldDeleteInaccessibleFaults = true
    container.viewContext.undoManager = nil
    
    return container
  }()
  
  private func newTaskContext() -> NSManagedObjectContext {
    let taskContext = persistentContainer.newBackgroundContext()
    taskContext.undoManager = nil
    
    taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return taskContext
  }
}

extension LocaleDataSource: LocaleDataSourceProtocol {
  func addFavouriteGame(gameModel: GameModel) -> AnyPublisher<Bool, Error> {
    Future<Bool, Error> { completion in
      let taskContext = self.newTaskContext()
      taskContext.performAndWait {
        if let entity = NSEntityDescription.entity(forEntityName: "Favourite", in: taskContext) {
          let member = NSManagedObject(entity: entity, insertInto: taskContext)
          member.setValue(gameModel.id, forKey: "id")
          member.setValue(gameModel.name, forKey: "name")
          member.setValue(gameModel.rating, forKey: "rating")
          member.setValue(gameModel.released, forKey: "released")
          member.setValue(gameModel.backgroundImage, forKey: "backgroundImage")
          member.setValue(gameModel.developers, forKey: "developers")
          member.setValue(gameModel.description, forKey: "gameDescription")
          member.setValue(gameModel.genres, forKey: "genres")
          member.setValue(gameModel.platforms, forKey: "platforms")
          member.setValue(gameModel.playtime, forKey: "playtime")
          member.setValue(gameModel.publishers, forKey: "publishers")
          member.setValue(gameModel.tags, forKey: "tags")
          member.setValue(gameModel.website, forKey: "website")
          member.setValue(true, forKey: "isFavourited")
        }
        
        do {
          try taskContext.save()
          completion(.success(true))
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func getFavouritesList() -> AnyPublisher<[GameModel], Error> {
    Future<[GameModel], Error> { completion in
      let taskContext = self.newTaskContext()
      taskContext.perform {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favourite")
        do {
          let results = try taskContext.fetch(fetchRequest)
          var favourites = [GameModel]()
          for result in results {
            let favourite = GameModel(
              id: result.value(forKey: "id") as? String ?? "",
              backgroundImage: result.value(forKey: "backgroundImage") as? String ?? "",
              name: result.value(forKey: "name") as? String ?? "",
              released: result.value(forKey: "released") as? String ?? "",
              description: result.value(forKey: "gameDescription") as? String ?? "",
              rating: result.value(forKey: "rating") as? String ?? "",
              platforms: result.value(forKey: "platforms") as? String ?? "",
              genres: result.value(forKey: "genres") as? String ?? "",
              publishers: result.value(forKey: "publishers") as? String ?? "",
              developers: result.value(forKey: "developers") as? String ?? "",
              tags: result.value(forKey: "tags") as? String ?? "",
              website: result.value(forKey: "website") as? String ?? "",
              playtime: result.value(forKey: "playtime") as? String ?? "",
              isFavorited: result.value(forKey: "isFavourited") as? Bool ?? false
            )
            
            favourites.append(favourite)
          }
          
          completion(.success(favourites))
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func getFavouriteGame(gameId: String) -> AnyPublisher<GameModel, Error> {
    Future<GameModel, Error> { completion in
      let taskContext = self.newTaskContext()
      taskContext.perform {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favourite")
        do {
          let results = try taskContext.fetch(fetchRequest)
          var favourite: GameModel?
          for result in results {
            if let id = result.value(forKey: "id") as? String, gameId == id {
              favourite = GameModel(
                id: result.value(forKey: "id") as? String ?? "",
                backgroundImage: result.value(forKey: "backgroundImage") as? String ?? "",
                name: result.value(forKey: "name") as? String ?? "",
                released: result.value(forKey: "released") as? String ?? "",
                description: result.value(forKey: "gameDescription") as? String ?? "",
                rating: result.value(forKey: "rating") as? String ?? "",
                platforms: result.value(forKey: "platforms") as? String ?? "",
                genres: result.value(forKey: "genres") as? String ?? "",
                publishers: result.value(forKey: "publishers") as? String ?? "",
                developers: result.value(forKey: "developers") as? String ?? "",
                tags: result.value(forKey: "tags") as? String ?? "",
                website: result.value(forKey: "website") as? String ?? "",
                playtime: result.value(forKey: "playtime") as? String ?? "",
                isFavorited: result.value(forKey: "isFavourited") as? Bool ?? false
              )
            }
          }
          
          if let favourite = favourite {
            completion(.success(favourite))
          } else {
            completion(.failure(DatabaseError.invalidInstance))
          }
        } catch {
          completion(.failure(DatabaseError.requestFailed))
        }
      }
    }.eraseToAnyPublisher()
  }
  
  func deleteFavouriteGame(id: String) -> AnyPublisher<Bool, Error> {
    Future<Bool, Error> { completion in
      let taskContext = self.newTaskContext()
      taskContext.perform {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeCount
        if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
          if batchDeleteResult.result != nil {
            completion(.success(true))
          } else {
            completion(.failure(DatabaseError.invalidInstance))
          }
        } else {
          completion(.failure(DatabaseError.requestFailed))
        }
      }
    }.eraseToAnyPublisher()
  }
}
