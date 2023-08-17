//
//  GameListPresenter.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 15/08/23.
//

import Foundation
import Combine

class GameListPresenter {
  private var cancellables: Set<AnyCancellable> = []
  private var gamesUseCase: GamesUseCase
  
  var isLoading = CurrentValueSubject<Bool, Never>(false)
  var errorMessage = CurrentValueSubject<String, Never>("")
  var games = CurrentValueSubject<[GameModel], Never>([GameModel]())
  
  init(gamesUseCase: GamesUseCase) {
    self.gamesUseCase = gamesUseCase
  }
  
  func getGamesList() {
    isLoading.send(true)
    gamesUseCase.getGamesList().sink { completion in
      switch completion {
      case .finished:
        self.isLoading.send(false)
      case .failure(let error):
        self.isLoading.send(false)
        self.errorMessage.send(error.localizedDescription)
      }
    } receiveValue: { games in
      self.games.send(games)
    }.store(in: &cancellables)
  }
  
  func getGamesSearchList(search: String) {
    isLoading.send(true)
    gamesUseCase.getGamesSearchList(search: search).sink { completion in
      switch completion {
      case .finished:
        self.isLoading.send(false)
      case .failure(let error):
        self.isLoading.send(false)
        self.errorMessage.send(error.localizedDescription)
      }
    } receiveValue: { games in
      self.games.send(games)
    }.store(in: &cancellables)
  }
}
