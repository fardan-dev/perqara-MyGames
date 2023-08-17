//
//  String+Ext.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 17/08/23.
//
import Foundation

extension StringProtocol {
  var htmlAttributedString: NSAttributedString? {
    Data(utf8).htmlAttributedString
  }
  
  var htmlString: String {
    htmlAttributedString?.string ?? ""
  }
}

extension Data {
  var htmlAttributedString: NSAttributedString? {
    do {
      return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    } catch {
      print("error:", error)
      return  nil
    }
  }
  
  var htmlString: String { htmlAttributedString?.string ?? "" }
}
