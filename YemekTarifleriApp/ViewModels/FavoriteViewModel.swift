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
            FavoriteService.shared.fetchUserFavorites { [weak self] favorites in
                guard let self = self else { return }
                
                self.favorites = favorites
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
    
    // MARK: - Filter Favorites by Multiple Meal Types
    func filterFavorites(by mealTypes: [String]) -> [RecipeUIModel] {
        guard !mealTypes.isEmpty else {
            return favorites
        }
        return favorites.filter { recipeUI in
            guard let dishTypes = recipeUI.recipe.dishTypes?.map({ $0.lowercased() }) else { return false }
            return mealTypes.contains { dishTypes.contains($0.lowercased()) }
        }
    }
    
    // MARK: - Sort Favorites by Option
    func sortFavorites(by option: String) {
        switch option {
        case "Newest First":
            favorites.sort { ($0.createdAt ?? Date.distantPast) > ($1.createdAt ?? Date.distantPast) }
        case "Oldest First":
            favorites.sort { ($0.createdAt ?? Date.distantPast) < ($1.createdAt ?? Date.distantPast) }
        case "Alphabetical (A→Z)":
            favorites.sort { $0.recipe.title.lowercased() < $1.recipe.title.lowercased() }
        case "Alphabetical (Z→A)":
            favorites.sort { $0.recipe.title.lowercased() > $1.recipe.title.lowercased() }
        case "Preparation Time (Short → Long)":
            favorites.sort { ($0.recipe.readyInMinutes ?? 0) < ($1.recipe.readyInMinutes ?? 0) }
        case "Preparation Time (Long → Short)":
            favorites.sort { ($0.recipe.readyInMinutes ?? 0) > ($1.recipe.readyInMinutes ?? 0) }
        case "Calories (Low → High)":
            favorites.sort {
                let cal0 = $0.recipe.nutrition?.nutrients.first(where: { $0.name.lowercased() == "calories" })?.amount ?? 0
                let cal1 = $1.recipe.nutrition?.nutrients.first(where: { $0.name.lowercased() == "calories" })?.amount ?? 0
                return cal0 < cal1
            }

        case "Calories (High → Low)":
            favorites.sort {
                let cal0 = $0.recipe.nutrition?.nutrients.first(where: { $0.name.lowercased() == "calories" })?.amount ?? 0
                let cal1 = $1.recipe.nutrition?.nutrients.first(where: { $0.name.lowercased() == "calories" })?.amount ?? 0
                return cal0 > cal1
            }
        default:
            break
        }

        onFavoritesUpdated?()
    }
}
