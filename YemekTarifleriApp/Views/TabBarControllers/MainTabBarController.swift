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
        let homeTabBarItem = UITabBarItem(title: "Anasayfa", image: UIImage(named: "home"), tag: 0)
        homeTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        homeViewController.tabBarItem = homeTabBarItem
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.setNavigationBarHidden(true, animated: true)
        
        let favoriteViewController = FavoriteViewController()
        let favoriteTabBarItem = UITabBarItem(title: "Favoriler", image: UIImage(named: "heart"), tag: 1)
        favoriteTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        favoriteViewController.tabBarItem = favoriteTabBarItem
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
        favoriteNavigationController.setNavigationBarHidden(true, animated: true)
        
        let fridgeViewController = FridgeViewController()
        let fridgeTabBarItem = UITabBarItem(title: "Dolabım", image: UIImage(named: "fridge"), tag: 2)
        fridgeTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        fridgeViewController.tabBarItem = fridgeTabBarItem
        let fridgeNavigationController = UINavigationController(rootViewController: fridgeViewController)
        fridgeNavigationController.setNavigationBarHidden(true, animated: true)
        
        let profileViewController = ProfileViewController()
        let profileTabBarItem = UITabBarItem(title: "Profil", image: UIImage(named: "profile"), tag: 3)
        profileTabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        profileViewController.tabBarItem = profileTabBarItem
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
