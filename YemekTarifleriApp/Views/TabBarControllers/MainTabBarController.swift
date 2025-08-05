//
//  MainTabBarController.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 4.08.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue(CustomTabBar(), forKey: "tabBar")
        setupTabs()
        
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = UIColor.textColor300.cgColor
        tabBar.clipsToBounds = true
        
        (tabBar as? CustomTabBar)?.setCenterButtonAction(target: self, action: #selector(centerButtonTapped))
    }
    
    //MARK: - Functions
    private func setupTabs() {
        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(systemName: "house"), tag: 0)
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.setNavigationBarHidden(true, animated: true)
        
        let favoriteViewController = FavoriteViewController()
        favoriteViewController.tabBarItem = UITabBarItem(title: "Favoriler", image: UIImage(systemName: "heart"), tag: 1)
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
        favoriteNavigationController.setNavigationBarHidden(true, animated: true)
        
        let fridgeViewController = FridgeViewController()
        fridgeViewController.tabBarItem = UITabBarItem(title: "Dolabım", image: UIImage(systemName: "takeoutbag.and.cup.and.straw"), tag: 2)
        let fridgeNavigationController = UINavigationController(rootViewController: fridgeViewController)
        fridgeNavigationController.setNavigationBarHidden(true, animated: true)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person"), tag: 3)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        profileNavigationController.setNavigationBarHidden(true, animated: true)
        
        let dummyViewController = UIViewController()
        dummyViewController.tabBarItem.isEnabled = false
        
        viewControllers = [
            homeNavigationController,
            favoriteNavigationController,
            dummyViewController,
            fridgeNavigationController,
            profileNavigationController
        ]
        
        tabBar.tintColor = .secondaryColor
    }
    
    //MARK: - Actions
    @objc private func centerButtonTapped() {
        let createRecipeViewController = CreateRecipeViewController()
        navigationController?.pushViewController(createRecipeViewController, animated: true)
    }
}
