//
//  GameDetailPresenter.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 17/08/23.
//

import Combine

class GameDetailPresenter {
  private var cancellables: Set<AnyCancellable> = []
  private var gameId: String
  private var gameDetailUseCase: GameDetailUseCase
  
  var game = CurrentValueSubject<GameModel?, Never>(GameModel())
  var isLoading = CurrentValueSubject<Bool, Never>(false)
  var errorMessage = CurrentValueSubject<String, Never>("")
  
  init(gameId: String, gameDetailUseCase: GameDetailUseCase) {
    self.gameId = gameId
    self.gameDetailUseCase = gameDetailUseCase
  }
  
  func getGameDetail() {
    isLoading.send(true)
    gameDetailUseCase
      .getGameDetail(id: gameId)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          self.isLoading.send(false)
        case .failure(let error):
          self.isLoading.send(false)
          self.errorMessage.send(error.localizedDescription)
        }
      }, receiveValue: { game in
        self.game.send(game)
      }).store(in: &cancellables)
  }
  
  func addDeleteFavorite() {
    if var game = game.value, game.isFavorited == false {
      gameDetailUseCase
        .addFavouriteGame(gameModel: game)
        .sink { _ in } receiveValue: { isFavourited in
          game.isFavorited = true
          self.game.send(game)
        }.store(in: &cancellables)
    } else if var game = game.value {
      gameDetailUseCase
        .deleteFavouriteGame(id: game.id)
        .sink(receiveCompletion: { _ in }, receiveValue: { _ in
          game.isFavorited = false
          self.game.send(game)
        }).store(in: &cancellables)
    }
  }
}
