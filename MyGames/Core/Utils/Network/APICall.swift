//
//  APICall.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 15/08/23.
//

import Foundation

struct APICall {
  static let baseURL: String = {
    guard let filePath = Bundle.main.path(forResource: "Constant", ofType: "plist")  else {
      fatalError("Couldn't find file 'Constant.plist'.")
    }
    
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let url = plist?.object(forKey: "base-url") as? String else {
      fatalError("Couldn't find key 'base-url' in 'Constant.plist'.")
    }
    
    return url
  }()
}

protocol Endpoint {
  var url: String { get }
}

enum Endpoints {
  enum Gets: Endpoint {
    case games
    case gameDetail(id: String)
    
    public var url: String {
      switch self {
      case .games: return "\(APICall.baseURL)games"
      case .gameDetail(let id): return "\(APICall.baseURL)games/\(id)"
      }
    }
  }
}

struct Parameter {
  static func defaultParameters() -> [String: Any] {
    guard let filePath = Bundle.main.path(forResource: "Constant", ofType: "plist")  else {
      fatalError("Couldn't find file 'Constant.plist'.")
    }
    
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let apiKey = plist?.object(forKey: "rawg-api-key") as? String else {
      fatalError("Couldn't find key 'rawg-api-key' in 'Constant.plist'.")
    }
    
    return ["key": apiKey]
  }
}
