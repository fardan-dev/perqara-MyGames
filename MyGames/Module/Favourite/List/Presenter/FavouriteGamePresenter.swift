//
//  FavouriteGamePresenter.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 17/08/23.
//

import Combine

class FavouriteGameListPresenter {
  private var cancellables: Set<AnyCancellable> = []
  private var favouriteUseCase: FavouriteUseCase
  
  var isLoading = CurrentValueSubject<Bool, Never>(false)
  var errorMessage = CurrentValueSubject<String, Never>("")
  var games = CurrentValueSubject<[GameModel], Never>([GameModel]())
  
  init(favouriteUseCase: FavouriteUseCase) {
    self.favouriteUseCase = favouriteUseCase
  }
  
  func getGamesList() {
    favouriteUseCase
      .getFavouritesGameList()
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          self.isLoading.send(false)
        case .failure(let error):
          self.isLoading.send(false)
          self.errorMessage.send(error.localizedDescription)
        }
      }, receiveValue: { games in
        self.games.send(games)
      }).store(in: &cancellables)
  }
}
