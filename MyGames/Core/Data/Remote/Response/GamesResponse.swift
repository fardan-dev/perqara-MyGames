//
//  GamesResponse.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 15/08/23.
//

struct GamesResponse: Decodable {
  var results: [GameResponse]
}

struct GameResponse: Decodable {
  let id: Int32?
  let name, released: String?
  let backgroundImage: String?
  let rating: Double?
  let ratingTop: Int?
  let description: String?
  let playtime: Int?
  let publishers: [GenericModel]?
  let platforms: [PlatformModel]?
  let genres: [GenericModel]?
  let developers: [GenericModel]?
  let tags: [GenericModel]?
  let website: String?

  enum CodingKeys: String, CodingKey {
    case id, name, released
    case backgroundImage = "background_image"
    case rating
    case ratingTop = "rating_top"
    case description, platforms, genres, playtime
    case publishers, developers, tags, website
  }
}

struct PlatformModel: Decodable {
  let platform: GenericModel?
  let releasedAt: String?

  enum CodingKeys: String, CodingKey {
    case platform
    case releasedAt = "released_at"
  }
}

struct GenericModel: Decodable {
  let id: Int?
  let name: String?
}
