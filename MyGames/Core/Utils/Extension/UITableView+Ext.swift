//
//  UITableView+Ext.swift
//  MyGames
//
//  Created by telkom on 16/08/23.
//

import UIKit

extension UITableViewCell {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  static var nibName: String {
    return String(describing: self )
  }
  
  static var nib: UINib? {
    if Bundle.main.path(forResource: nibName, ofType: "nib") != nil {
      return UINib(nibName: self.nibName, bundle: nil)
    }
    return nil
  }
}

extension UITableView {
  func registerCell<T: UITableViewCell>(_: T.Type) {
    if let nib = T.nib {
      self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    } else {
      self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
  }
  
  func dequeueCell<T: UITableViewCell>(_: T.Type, indexPath: IndexPath) -> T {
    return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
  }
}
