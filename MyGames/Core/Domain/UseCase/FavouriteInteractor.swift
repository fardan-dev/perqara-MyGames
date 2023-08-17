//
//  FavouriteInteractor.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 17/08/23.
//

import Combine

protocol FavouriteUseCase {
  func getFavouritesGameList() -> AnyPublisher<[GameModel], Error>
}

class FavouriteInteractor: FavouriteUseCase {
  let repository: GameRepositoryProtocol
  
  required init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }
  
  func getFavouritesGameList() -> AnyPublisher<[GameModel], Error> {
    repository.getFavouritesGameList().eraseToAnyPublisher()
  }
}
