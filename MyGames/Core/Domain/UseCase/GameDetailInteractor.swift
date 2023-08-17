//
//  GameDetailInteractor.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 17/08/23.
//

import Combine

protocol GameDetailUseCase {
  func getGameDetail(id: String) -> AnyPublisher<GameModel, Error>
  func addFavouriteGame(gameModel: GameModel) -> AnyPublisher<Bool, Error>
  func deleteFavouriteGame(id: String) -> AnyPublisher<Bool, Error>
}

class GameDetailInteractor: GameDetailUseCase {
  let repository: GameRepositoryProtocol
  
  required init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }
  
  func getGameDetail(id: String) -> AnyPublisher<GameModel, Error> {
    repository.getGameDetail(id: id).eraseToAnyPublisher()
  }
  
  func addFavouriteGame(gameModel: GameModel) -> AnyPublisher<Bool, Error> {
    repository.addFavouriteGame(gameModel: gameModel)
  }
  
  func deleteFavouriteGame(id: String) -> AnyPublisher<Bool, Error> {
    repository.deleteFavouriteGame(id: id)
  }
}
