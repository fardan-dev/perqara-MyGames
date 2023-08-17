//
//  MainTabBarViewController.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 16/08/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _configureNavBar()
  }
  
  private func _configureNavBar() {
    tabBar.isTranslucent = false
    tabBar.barTintColor = .white
    tabBar.tintColor = .black
    tabBar.backgroundColor = .white
    
    let home = createTabController(vc: GameListViewController(presenter: GameListPresenter(gamesUseCase: Injection().provideGames())), title: "Game", active: UIImage(systemName: "gamecontroller.fill"), inactive: UIImage(systemName: "gamecontroller.fill"))
    let favourite = createTabController(vc: FavouriteListViewController(presenter: FavouriteGameListPresenter(favouriteUseCase: Injection().provideFavouriteGames())), title: "Favourite", active: UIImage(systemName: "heart.fill"), inactive: UIImage(systemName: "heart.fill"))
    viewControllers = [home, favourite]
  }
}

extension UITabBarController {
  func createTabController(vc: UIViewController, title: String, active: UIImage?, inactive: UIImage?) -> UINavigationController {
    
    let tabController = UINavigationController(rootViewController: vc)
    tabController.tabBarItem.image = inactive
    tabController.tabBarItem.selectedImage = active?.withRenderingMode(.alwaysTemplate)
    tabController.tabBarItem.title = title
    tabController.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], for: .normal)
    tabController.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], for: .selected)
    
    return tabController
  }
}
