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
    
    func fetchRecommendedRecipes(completion: @escaping () -> Void) {
        SpoonacularService.shared.searchRecipes(
            query: nil,
            diet: diet,
            intolerances: intolerances,
            excludeIngredients: excludeIngredients
        ) { [weak self] result in
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
    
    func fetchSearchSuggestions(query: String, completion: @escaping () -> Void) {
        SpoonacularService.shared.searchRecipes(
            query: query,
            diet: diet,
            intolerances: intolerances,
            excludeIngredients: excludeIngredients
        ) { [weak self] result in
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
    
    func fetchRecentViewed(limit: Int = 20, completion: @escaping () -> Void) {
        RecentViewService.shared.fetchRecentViews(limit: limit) { [weak self] result in
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
