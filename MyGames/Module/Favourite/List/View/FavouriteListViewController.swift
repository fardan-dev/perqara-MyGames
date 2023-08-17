//
//  FavouriteListViewController.swift
//  MyGames
//
//  Created by telkom on 16/08/23.
//

import UIKit
import Combine

class FavouriteListViewController: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var emptyMessagelabel: UILabel!
  
  private let router = GameRouter()
  private var _cancellables: Set<AnyCancellable> = []
  private var _presenter: FavouriteGameListPresenter
  private var _refreshControl = UIRefreshControl()
  
  init(presenter: FavouriteGameListPresenter) {
    self._presenter = presenter
    super.init(nibName: "FavouriteListViewController", bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _setupView()
    _observableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBarView()
    _fetchData()
    title = "Favourite"
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
        self.emptyMessagelabel.isHidden = !games.isEmpty
      }
    }.store(in: &_cancellables)
    
    _presenter.errorMessage.sink { message in
      DispatchQueue.main.async {
        if !message.isEmpty {
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

extension FavouriteListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return _presenter.games.value.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueCell(GameListTableViewCell.self, indexPath: indexPath)
    cell.gameModel = _presenter.games.value[indexPath.row]
    return cell
  }
}

extension FavouriteListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let gameItem = _presenter.games.value[indexPath.row]
    let gameDetailView = router.makeGameDetail(gameId: gameItem.id)
    gameDetailView.hidesBottomBarWhenPushed = true
    gameDetailView.title = gameItem.name
    navigationController?.pushViewController(gameDetailView, animated: true)
  }
}
