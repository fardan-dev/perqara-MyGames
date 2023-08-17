//
//  Injection.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 17/08/23.
//

final class Injection {
  private func provideRepository() -> GameRepositoryProtocol {
    let remote = RemoteDataSource.sharedInstance
    let locale = LocaleDataSource.sharedInstance
    
    return GameRepository.sharedInstance(remote, locale)
  }
  
  func provideGames() -> GamesUseCase {
    let repository = provideRepository()
    return GamesInteractor(repository: repository)
  }
  
  func provideGameDetail() -> GameDetailUseCase {
    let repository = provideRepository()
    return GameDetailInteractor(repository: repository)
  }
  
  func provideFavouriteGames() -> FavouriteUseCase {
    let repository = provideRepository()
    return FavouriteInteractor(repository: repository)
  }
}
