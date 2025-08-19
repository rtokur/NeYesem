//
//  FavoriteViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 15.08.2025.
//

import Foundation

final class FavoriteViewModel {
    
    // MARK: - Properties
    private(set) var favorites: [RecipeUIModel] = [] {
        didSet { self.onFavoritesUpdated?() }
    }
    
    var onFavoritesUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Fetch Favorites
    func fetchFavorites() {
        FavoriteService.shared.fetchUserFavorites { [weak self] recipes in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                let uniqueRecipes = Dictionary(grouping: recipes, by: { $0.id })
                    .compactMap { $0.value.first }
                
                self.favorites = uniqueRecipes.map { recipe in
                    RecipeUIModel(recipe: recipe, isFavorite: true, likeCount: 0)
                }
                
                for (index, item) in self.favorites.enumerated() {
                    FavoriteService.shared.getLikeCount(recipeId: item.recipe.id) { count in
                        DispatchQueue.main.async {
                            if index < self.favorites.count {
                                self.favorites[index].likeCount = count
                                self.onFavoritesUpdated?()
                            }
                        }
                    }
                }
            }
        }
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
    
    // MARK: - Helper Methods
    func numberOfItems() -> Int {
        return favorites.count
    }
    
    func item(at index: Int) -> RecipeUIModel? {
        guard index >= 0 && index < favorites.count else { return nil }
        return favorites[index]
    }
    
    // MARK: - Filter Favorites by Meal Type
    func filterFavorites(by mealType: String?) -> [RecipeUIModel] {
        guard let mealType = mealType, !mealType.isEmpty, mealType != "All recipes" else {
            return favorites
        }
        return favorites.filter { model in
            model.recipe.dishTypes?.contains(where: { $0.lowercased() == mealType.lowercased() }) ?? false
        }
    }
}
