//
//  HomeViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 13.08.2025.
//

import Foundation

final class HomeViewModel {
    private(set) var recommendedRecipes: [Recipe] = []
    private(set) var searchSuggestions: [Recipe] = []
    private(set) var recentViewedRecipes: [Recipe] = []
    
    var diet: String?
    var intolerances: [String] = []
    var excludeIngredients: [String] = []
    
    // MARK: - Recommended
    func fetchRecommendedRecipes(completion: @escaping () -> Void) {
        SpoonacularService.shared.searchRecipes(
            query: nil,
            diet: diet,
            intolerances: intolerances,
            excludeIngredients: excludeIngredients
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRecipes):
                    self?.recommendedRecipes = fetchedRecipes
                case .failure(let error):
                    print("Error fetching recommended:", error)
                    self?.recommendedRecipes = []
                }
                completion()
            }
        }
    }
    
    // MARK: - Search Suggestions
    func fetchSearchSuggestions(query: String, completion: @escaping () -> Void) {
        SpoonacularService.shared.searchRecipes(
            query: query,
            diet: diet,
            intolerances: intolerances,
            excludeIngredients: excludeIngredients
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRecipes):
                    self?.searchSuggestions = fetchedRecipes
                case .failure(let error):
                    print("Error fetching suggestions:", error)
                    self?.searchSuggestions = []
                }
                completion()
            }
        }
    }
    
    // MARK: - Recent Viewed
    func fetchRecentViewed(limit: Int = 20, completion: @escaping () -> Void) {
        RecentViewService.shared.fetchRecentViews(limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self?.recentViewedRecipes = items
                case .failure(let err):
                    print("Error fetching recent:", err)
                    self?.recentViewedRecipes = []
                }
                completion()
            }
        }
    }
    
    // MARK: - Favorites
    func toggleFavorite(recipe: Recipe, completion: @escaping (Bool) -> Void) {
        FavoriteService.shared.toggleFavorite(recipe: recipe, completion: completion)
    }
    
    func isFavorite(recipeId: Int, completion: @escaping (Bool) -> Void) {
        FavoriteService.shared.isFavorite(recipeId: recipeId, completion: completion)
    }
    
    // MARK: - Likes
    func getLikeCount(recipeId: Int, completion: @escaping (Int) -> Void) {
        FavoriteService.shared.getLikeCount(recipeId: recipeId) { count in
            DispatchQueue.main.async {
                completion(count)
            }
        }
    }
}
