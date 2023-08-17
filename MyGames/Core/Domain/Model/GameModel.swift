//
//  GameModel.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 15/08/23.
//

struct GameModel: Equatable, Identifiable {
  var id: String = ""
  var backgroundImage: String = ""
  var name: String = ""
  var released: String = ""
  var description: String = ""
  var rating: String = ""
  var platforms: String = ""
  var genres: String = ""
  var publishers: String = ""
  var developers: String = ""
  var tags: String = ""
  var website: String = ""
  var playtime: String = ""
  var isFavorited: Bool = false
}
