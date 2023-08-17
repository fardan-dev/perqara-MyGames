//
//  GameRouter.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 17/08/23.
//

final class GameRouter {
  func makeGameDetail(gameId: String) -> GameDetailViewController {
    return GameDetailViewController(presenter: GameDetailPresenter(gameId: gameId, gameDetailUseCase: Injection().provideGameDetail()))
  }
}
