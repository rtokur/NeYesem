//
//  FavoriteViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 15.08.2025.
//

import Foundation

final class FavoriteViewModel {
    
    // MARK: - Properties
    private(set) var favorites: [Recipe] = [] {
        didSet { self.onFavoritesUpdated?() }
    }
    
    var likeCount: Int = 0 {
        didSet { onLikeCountChanged?(likeCount) }
    }
    
    var onFavoritesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLikeCountChanged: ((Int) -> Void)?
    
    // MARK: - Fetch Favorites
    func fetchFavorites() {
        FavoriteService.shared.fetchUserFavorites { [weak self] recipes in
            DispatchQueue.main.async {
                self?.favorites = recipes
            }
        }
    }
    
    // MARK: - Get Like Count
    func getLikeCount(recipeId: Int, completion: @escaping (Int) -> Void) {
        FavoriteService.shared.getLikeCount(recipeId: recipeId, completion: completion)
    }
    
    // MARK: - Toggle Favorite
    func toggleFavorite(recipe: Recipe) {
        FavoriteService.shared.toggleFavorite(recipe: recipe) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.fetchFavorites() 
                } else {
                    self?.onError?("Favori güncellenemedi")
                }
            }
        }
    }
    
    // MARK: - Check Favorite
    func isFavorite(recipeId: Int, completion: @escaping (Bool) -> Void) {
        FavoriteService.shared.isFavorite(recipeId: recipeId, completion: completion)
    }
    
    // MARK: - Helper Methods
    func numberOfItems() -> Int {
        return favorites.count
    }
    
    func item(at index: Int) -> Recipe? {
        guard index >= 0 && index < favorites.count else { return nil }
        return favorites[index]
    }
}
