//
//  CategoryViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 20.08.2025.
//

import Foundation
import UIKit

final class CategoryViewModel {

    // MARK: - Properties
    private(set) var categories: [CategoryModel] = []
    
    var onSuggestionsUpdated: (([CategoryModel]) -> Void)?
    private(set) var searchSuggestions: [CategoryModel] = [] {
        didSet { onSuggestionsUpdated?(searchSuggestions) }
    }
    
    private var recipes: [RecipeUIModel] = []
    private(set) var filteredRecipes: [RecipeUIModel] = [] {
        didSet { onRecipesUpdated?() }
    }
    
    // MARK: - Search Suggestions for StackView
    private(set) var searchSuggestionsRecipes: [RecipeUIModel] = [] {
        didSet { onSearchSuggestionsUpdated?() }
    }
    var onSearchSuggestionsUpdated: (() -> Void)?
    
    var onRecipesUpdated: (() -> Void)?
    var selectedCategory: String?

    var allCategories: [CategoryModel] {
        return categories
    }
    
    // MARK: - Init
    init() {
        loadCategoriesFromJSON()
    }
    
    private func loadCategoriesFromJSON() {
        guard let url = Bundle.main.url(forResource: "Categories", withExtension: "json") else {
            print("Categories.json not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([CategoryModel].self, from: data)
            categories = decoded
        } catch {
            print("Failed to load Categories.json:", error)
        }
    }
    
    // MARK: - Category Autocomplete
    func fetchAutocompleteSuggestions(query: String) {
        let lowercasedQuery = query.lowercased()
        guard lowercasedQuery.count >= 2 else {
            searchSuggestions = []
            return
        }
        
        let filtered = categories.filter { $0.title.lowercased().contains(lowercasedQuery) }
        searchSuggestions = filtered
    }

    // MARK: - Fetch Recipes for CollectionView
    func fetchRecipes(for category: String) {
        selectedCategory = category
        SpoonacularService.shared.searchRecipes(query: category, diet: nil, intolerances: [], excludeIngredients: []) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    let group = DispatchGroup()
                    var uiModels: [RecipeUIModel] = []
                    
                    for recipe in recipes {
                        group.enter()
                        
                        let matchedType = recipe.dishTypes?.first { type in
                            self.categories.contains { $0.title.lowercased() == type.lowercased() }
                        }
                        let color = matchedType
                            .flatMap { type in
                                self.categories.first { $0.title.lowercased() == type.lowercased() }?.colorHex
                            }
                            .flatMap { UIColor(hex: $0) } ?? .systemGray
                        
                        FavoriteService.shared.isFavorite(recipeId: recipe.id) { isFav in
                            FavoriteService.shared.getLikeCount(recipeId: recipe.id) { likeCount in
                                let model = RecipeUIModel(
                                    recipe: recipe,
                                    isFavorite: isFav,
                                    likeCount: likeCount,
                                    color: color
                                )
                                uiModels.append(model)
                                group.leave()
                            }
                        }
                    }
                    
                    group.notify(queue: .main) {
                        self.recipes = uiModels
                        self.filteredRecipes = uiModels
                    }
                    
                case .failure(let error):
                    print("Error fetching recipes:", error.localizedDescription)
                    self.recipes = []
                    self.filteredRecipes = []
                }
            }
        }
    }

    // MARK: - Autocomplete Recipes for SearchBar (StackView)
    func fetchAutocompleteRecipes(query: String) {
        guard let category = selectedCategory, !query.isEmpty else {
            searchSuggestionsRecipes = []
            return
        }

        SpoonacularService.shared.searchRecipes(query: "\(category) \(query)", diet: nil, intolerances: [], excludeIngredients: []) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    self?.searchSuggestionsRecipes = recipes.map {
                        RecipeUIModel(recipe: $0, isFavorite: false, likeCount: 0, color: .gray)
                    }
                case .failure(let error):
                    self?.searchSuggestionsRecipes = []
                    print("Error fetching autocomplete recipes:", error.localizedDescription)
                }
            }
        }
    }

    func toggleFavorite(at index: Int, completion: @escaping (Bool) -> Void) {
        guard index < filteredRecipes.count else {
            completion(false)
            return
        }
        
        var recipeModel = filteredRecipes[index]
        
        FavoriteService.shared.toggleFavorite(recipe: recipeModel.recipe) { [weak self] success in
            guard let self = self else { completion(false); return }
            
            if success {
                DispatchQueue.main.async {
                    recipeModel.isFavorite.toggle()
                    recipeModel.likeCount += recipeModel.isFavorite ? 1 : -1
                    
                    self.filteredRecipes[index] = recipeModel
                    
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }

    // MARK: - CollectionView Helpers
    func numberOfItems() -> Int {
        return filteredRecipes.count
    }
    
    func item(at index: Int) -> RecipeUIModel? {
        guard index < filteredRecipes.count else { return nil }
        return filteredRecipes[index]
    }
}
