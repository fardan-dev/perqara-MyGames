//
//  GameListTableViewCell.swift
//  MyGames
//
//  Created by telkom on 16/08/23.
//

import UIKit
import AlamofireImage

class GameListTableViewCell: UITableViewCell {
  @IBOutlet weak var gameImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var releaseDataLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  
  var gameModel: GameModel? {
    didSet {
      setupView()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  private func setupView() {
    guard let gameModel = gameModel else { return }
    
    if let url = URL.init(string: gameModel.backgroundImage) {
      gameImageView.af
        .setImage(
          withURL: url,
          placeholderImage: UIImage(named: "placeholder-image")
        )
    }
    
    titleLabel.text = gameModel.name
    releaseDataLabel.text = "Released date: \(gameModel.released)"
    ratingLabel.text = gameModel.rating
  }
}
