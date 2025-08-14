//
//  HomeViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 13.08.2025.
//
import Foundation

final class HomeViewModel {
    private(set) var recipes: [Recipe] = []
    
    var diet: String?
    var intolerances: [String] = []
    var excludeIngredients: [String] = []
    
    func fetchRecommendedRecipes(query: String? = nil, completion: @escaping () -> Void) {
        SpoonacularService.shared.searchRecipes(
            query: query,
            diet: diet,
            intolerances: intolerances,
            excludeIngredients: excludeIngredients
        ) { [weak self] result in
            switch result {
            case .success(let fetchedRecipes):
                self?.recipes = fetchedRecipes
            case .failure(let error):
                print("Error fetching recipes:", error)
                self?.recipes = []
            }
            completion()
        }
    }
    
    func fetchRecipes(query: String, completion: @escaping () -> Void) {
        SpoonacularService.shared.searchRecipes(query: query) { [weak self] result in
            switch result {
            case .success(let fetchedRecipes):
                self?.recipes = fetchedRecipes
                completion()
            case .failure(let error):
                print("Error fetching recipes:", error)
                self?.recipes = []
                completion()
            }
        }
    }
}
