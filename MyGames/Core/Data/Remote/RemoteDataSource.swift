//
//  RemoteDataSource.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 15/08/23.
//

import Foundation
import Alamofire
import Foundation
import Combine

protocol RemoteDataSourceProtocol {
  func getGamesList() -> AnyPublisher<[GameResponse], Error>
  func getGameDetail(id: String) -> AnyPublisher<GameResponse, Error>
}

final class RemoteDataSource: NSObject {
  private override init() {}
  static let sharedInstance = RemoteDataSource()
}

extension RemoteDataSource: RemoteDataSourceProtocol {
  func getGamesList() -> AnyPublisher<[GameResponse], Error> {
    Future<[GameResponse], Error> { completion in
      AF
        .request(Endpoints.Gets.games.url,
                 method: .get,
                 parameters: Parameter.defaultParameters(),
                 encoding: URLEncoding.queryString)
        .validate()
        .responseDecodable(of: GamesResponse.self) { response in
          switch response.result {
          case .success(let gameResponses):
            completion(.success(gameResponses.results))
          case .failure:
            completion(.failure(URLError.invalidResponse))
          }
        }
    }.eraseToAnyPublisher()
  }
  
  func getGamesSearchList(parameters: [String: Any]) -> AnyPublisher<[GameResponse], Error> {
    Future<[GameResponse], Error> { completion in
      AF
        .request(Endpoints.Gets.games.url,
                 method: .get,
                 parameters: parameters,
                 encoding: URLEncoding.queryString)
        .validate()
        .responseDecodable(of: GamesResponse.self) { response in
          switch response.result {
          case .success(let gameResponses):
            completion(.success(gameResponses.results))
          case .failure:
            completion(.failure(URLError.invalidResponse))
          }
        }
    }.eraseToAnyPublisher()
  }
  
  func getGameDetail(id: String) -> AnyPublisher<GameResponse, Error> {
    Future<GameResponse, Error> { completion in
      AF
        .request(Endpoints.Gets.gameDetail(id: id).url,
                 method: .get,
                 parameters: Parameter.defaultParameters(),
                 encoding: URLEncoding.queryString)
        .validate()
        .responseDecodable(of: GameResponse.self) { response in
          switch response.result {
          case .success(let gameResponses):
            completion(.success(gameResponses))
          case .failure:
            completion(.failure(URLError.invalidResponse))
          }
        }
    }.eraseToAnyPublisher()
  }
}
