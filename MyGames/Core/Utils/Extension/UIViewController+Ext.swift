//
//  UIViewController+Ext.swift
//  MyGames
//
//  Created by Muhamad Fardan Wardhana on 17/08/23.
//

import UIKit

extension UIViewController {
  func setupNavigationBarView() {
    let appearance = UINavigationBarAppearance()
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.backgroundColor = .black
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    tabBarController?.navigationController?.navigationBar.isHidden = true
  }
  
  func showAlertMessage(message: String) {
    let alert = UIAlertController(title: "MyGames", message: message, preferredStyle: .alert)
    let cancelButton = UIAlertAction(title: "Ok", style: .cancel)
    alert.addAction(cancelButton)
    navigationController?.present(alert, animated: true)
  }
}
