//
//  GameRepository.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 15/08/23.
//

import Foundation
import Combine

protocol GameRepositoryProtocol {
  func getGamesList() -> AnyPublisher<[GameModel], Error>
  func getGamesSearchList(search: String) -> AnyPublisher<[GameModel], Error>
  func getGameDetail(id: String) -> AnyPublisher<GameModel, Error>
  func addFavouriteGame(gameModel: GameModel) -> AnyPublisher<Bool, Error>
  func deleteFavouriteGame(id: String) -> AnyPublisher<Bool, Error>
  func getFavouritesGameList() -> AnyPublisher<[GameModel], Error>
}

class GameRepository: NSObject {
  typealias GameInstance = (RemoteDataSource, LocaleDataSource) -> GameRepository
  fileprivate let remote: RemoteDataSource
  fileprivate let locale: LocaleDataSource
  
  static var sharedInstance: GameInstance = { remoteRepo, localeRepo in
    return GameRepository(remote: remoteRepo, locale: localeRepo)
  }
  
  private init(remote: RemoteDataSource, locale: LocaleDataSource) {
      self.remote = remote
      self.locale = locale
  }
}

extension GameRepository: GameRepositoryProtocol {
  func getGamesList() -> AnyPublisher<[GameModel], Error> {
    remote
      .getGamesList()
      .map { GameMapper.mapGameResponsesToDomains(input: $0) }
      .eraseToAnyPublisher()
  }
  
  func getGamesSearchList(search: String) -> AnyPublisher<[GameModel], Error> {
    var params = Parameter.defaultParameters()
    params["search"] = search
    return remote
      .getGamesSearchList(parameters: params)
      .map { GameMapper.mapGameResponsesToDomains(input: $0) }
      .eraseToAnyPublisher()
  }
  
  func getGameDetail(id: String) -> AnyPublisher<GameModel, Error> {
    locale
      .getFavouriteGame(gameId: id)
      .catch { error in
        return self.remote
          .getGameDetail(id: id)
          .map { GameMapper.mapGameResponseToDomain(input: $0) }
          .eraseToAnyPublisher()
      }.eraseToAnyPublisher()
  }
  
  func addFavouriteGame(gameModel: GameModel) -> AnyPublisher<Bool, Error> {
    locale
      .addFavouriteGame(gameModel: gameModel)
      .eraseToAnyPublisher()
  }
  
  func deleteFavouriteGame(id: String) -> AnyPublisher<Bool, Error> {
    locale
      .deleteFavouriteGame(id: id)
      .eraseToAnyPublisher()
  }
  
  func getFavouritesGameList() -> AnyPublisher<[GameModel], Error> {
    locale
      .getFavouritesList()
      .eraseToAnyPublisher()
  }
}
