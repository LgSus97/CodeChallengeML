//
//  TabBarController.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 25/04/25.
//

import UIKit

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        let homeViewController = SearchProductsRouter().getView()
        let homeVC = UINavigationController(rootViewController: homeViewController)
        homeVC.tabBarItem = UITabBarItem(title: "Inicio", image: UIImage(systemName: "house"), tag: 0)

        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
        favoritesVC.tabBarItem = UITabBarItem(title: "Favoritos", image: UIImage(systemName: "heart"), tag: 1)
        
        viewControllers = [homeVC, favoritesVC]
    }
}
