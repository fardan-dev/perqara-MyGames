//
//  GameMapper.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 15/08/23.
//

final class GameMapper {
  static func mapGameResponsesToDomains(input gamesResponse: [GameResponse]) -> [GameModel] {
    return gamesResponse.map { result in
      let newGame = GameModel(id: "\(result.id ?? 0)", backgroundImage: result.backgroundImage ?? "", name: result.name ?? "", released: result.released ?? "", description: result.description ?? "", rating: "\(result.rating ?? 0)", platforms: "", genres: "", publishers: "", developers: "", tags: "", website: "", isFavorited: false)
      return newGame
    }
  }
  
  static func mapGameResponseToDomain(input gameResponse: GameResponse) -> GameModel {
    var platformString: String? {
      var listString = [String]()
      for item in gameResponse.platforms ?? [] {
        listString.append(item.platform?.name ?? "")
      }
      return listString.joined(separator: ", ")
    }
    
    return GameModel(
      id: "\(gameResponse.id ?? 0)",
      backgroundImage: gameResponse.backgroundImage ?? "",
      name: gameResponse.name ?? "",
      released: gameResponse.released ?? "",
      description: gameResponse.description ?? "",
      rating: "\(gameResponse.rating ?? 0)",
      platforms: platformString ?? "",
      genres: mapGenericModelToString(items: gameResponse.genres),
      publishers: mapGenericModelToString(items: gameResponse.publishers),
      developers: mapGenericModelToString(items: gameResponse.developers),
      tags: mapGenericModelToString(items: gameResponse.tags),
      website: gameResponse.website ?? "",
      playtime: "\(gameResponse.playtime ?? 0)",
      isFavorited: false
    )
  }
  
  static func mapGenericModelToString(items: [GenericModel]?) -> String {
    var listString = [String]()
    for item in items ?? [] {
      listString.append(item.name ?? "")
    }
    return listString.joined(separator: ", ")
  }
}
