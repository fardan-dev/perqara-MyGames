//
//  GameListViewController.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 15/08/23.
//

import UIKit
import Combine

class GameListViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  private let router = GameRouter()
  private var _cancellables: Set<AnyCancellable> = []
  private var _presenter: GameListPresenter
  private var _refreshControl = UIRefreshControl()
  private let _searchController = UISearchController(searchResultsController: nil)
  
  init(presenter: GameListPresenter) {
    self._presenter = presenter
    super.init(nibName: "GameListViewController", bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupView()
    _observableView()
    _fetchData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBarView()
    _setupSearchBar()
    title = "Games"
  }
  
  private func _setupSearchBar() {
    _searchController.searchResultsUpdater = self
    _searchController.obscuresBackgroundDuringPresentation = false
    _searchController.delegate = self
    _searchController.searchBar.placeholder = "Search Games"
    _searchController.searchBar.barStyle = .default
    _searchController.searchBar.tintColor = .white
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

    navigationItem.searchController = _searchController
  }
  
  private func _setupView() {
    var attributes = [NSAttributedString.Key: AnyObject]()
    attributes[.foregroundColor] = UIColor.white
    _refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
    _refreshControl.tintColor = .white
    _refreshControl.addTarget(self, action: #selector(refreshGameList), for: .valueChanged)
    
    tableView.refreshControl = _refreshControl
    tableView.registerCell(GameListTableViewCell.self)
  }
  
  private func _fetchData() {
    _presenter.getGamesList()
  }
  
  private func _observableView() {
    _presenter.isLoading.sink { isLoading in
      DispatchQueue.main.async {
        if isLoading {
          self.activityIndicator.startAnimating()
        } else {
          self.activityIndicator.stopAnimating()
        }
      }
    }.store(in: &_cancellables)
    
    _presenter.games.sink { games in
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }.store(in: &_cancellables)
    
    _presenter.errorMessage.sink { message in
      if !message.isEmpty {
        DispatchQueue.main.async {
          self.showAlertMessage(message: message)
        }
      }
    }.store(in: &_cancellables)
  }
  
  @objc private func refreshGameList() {
    _presenter.getGamesList()
    _refreshControl.endRefreshing()
  }
}

extension GameListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return _presenter.games.value.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(GameListTableViewCell.self, indexPath: indexPath)
    cell.gameModel = _presenter.games.value[indexPath.row]
    return cell
  }
}

extension GameListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let gameItem = _presenter.games.value[indexPath.row]
    let gameDetailView = router.makeGameDetail(gameId: gameItem.id)
    gameDetailView.hidesBottomBarWhenPushed = true
    gameDetailView.title = gameItem.name
    navigationController?.pushViewController(gameDetailView, animated: true)
  }
}

extension GameListViewController: UISearchControllerDelegate {
  func didDismissSearchController(_ searchController: UISearchController) {
    _presenter.getGamesList()
  }
}

extension GameListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    _presenter.getGamesSearchList(search: searchController.searchBar.text ?? "")
  }
}
