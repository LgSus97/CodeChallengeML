//
//  TabBarController.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 25/04/25.
//

import UIKit


/// A custom UITabBarController that manages the main application tabs.
final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    // MARK: - Setup

    /// Sets up the view controllers for each tab.
    private func setupTabs() {
        let homeViewController = SearchProductsRouter().getView()
        let homeVC = UINavigationController(rootViewController: homeViewController)
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)

        let favoritesViewController = FavoritesRouter().getView()
        let favoritesVC = UINavigationController(rootViewController: favoritesViewController)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 1)
        
        viewControllers = [homeVC, favoritesVC]
    }
}
