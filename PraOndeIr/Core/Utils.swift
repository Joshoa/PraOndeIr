//
//  Utils.swift
//  PraOndeIr
//
//  Created by Marcos Joshoa on 29/02/20.
//  Copyright © 2020 Marcos Joshoa. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureNavigationBar(largeTitleColor: UIColor = .white, backgoundColor: UIColor = UIColor(named: "main")!, tintColor: UIColor = .white, title: String, preferredLargeTitle: Bool = true) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.backgroundColor = backgoundColor
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.title = title
            
        }
    }
}
