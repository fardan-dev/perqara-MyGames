//
//  GamesInteractor.swift
//  MyGames
//
//  Created by telkom on 17/08/23.
//

import Combine

protocol GamesUseCase {
  func getGamesList() -> AnyPublisher<[GameModel], Error>
  func getGamesSearchList(search: String) -> AnyPublisher<[GameModel], Error>
}

class GamesInteractor: GamesUseCase {
  let repository: GameRepositoryProtocol
  
  required init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }
  
  func getGamesList() -> AnyPublisher<[GameModel], Error> {
    repository
      .getGamesList()
      .eraseToAnyPublisher()
  }
  
  func getGamesSearchList(search: String) -> AnyPublisher<[GameModel], Error> {
    repository
      .getGamesSearchList(search: search)
      .eraseToAnyPublisher()
  }
}
