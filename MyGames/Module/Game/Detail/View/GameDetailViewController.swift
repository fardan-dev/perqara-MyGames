//
//  GameDetailViewController.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 16/08/23.
//

import UIKit
import Combine
import AlamofireImage

class GameDetailViewController: UIViewController {
  @IBOutlet weak var gameImageView: UIImageView!
  @IBOutlet weak var developerLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var releasedDateLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var totalGameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var loadingView: UIView!
  
  private var _cancellables: Set<AnyCancellable> = []
  private var _presenter: GameDetailPresenter
  
  init(presenter: GameDetailPresenter) {
    self._presenter = presenter
    super.init(nibName: "GameDetailViewController", bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _observableView()
    _fetchData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.tintColor = .white
    _setupFavouriteButton(isFavourite: false)
  }
  
  private func _setupFavouriteButton(isFavourite: Bool? = nil) {
    let favouriteButton = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(favouriteButtonDidPush(_ :)))
    if let isFavourite = isFavourite {
      favouriteButton.tintColor = isFavourite ? .red:.white
      navigationItem.rightBarButtonItem = favouriteButton
    } else {
      navigationItem.rightBarButtonItem = nil
    }
  }
  
  private func _fetchData() {
    _presenter.getGameDetail()
  }
  
  private func _observableView() {
    _presenter.isLoading.sink(receiveValue: { isLoading in
      DispatchQueue.main.async {
        self.loadingView.isHidden = !isLoading
      }
    }).store(in: &_cancellables)
    
    _presenter.game.sink { game in
      if game != nil {
        self._setupView()
      }
    }.store(in: &_cancellables)
  }
  
  private func _setupView() {
    guard let game = _presenter.game.value else { return }
    
    DispatchQueue.main.async {
      self._setupFavouriteButton(isFavourite: game.isFavorited)
      
      if let url = URL(string: game.backgroundImage) {
        self.gameImageView.af.setImage(withURL: url, placeholderImage: UIImage(named: "placeholder-image"))
      }
      
      self.developerLabel.text = game.developers
      self.titleLabel.text = game.name
      self.releasedDateLabel.text = "Released date: \(game.released)"
      self.ratingLabel.text = game.rating
      self.totalGameLabel.text = "\(game.playtime) played"
      self.descriptionLabel.text = game.description.htmlString
    }
  }
  
  @objc private func favouriteButtonDidPush(_ sender: UIBarButtonItem) {
    _presenter.addDeleteFavorite()
  }
}
