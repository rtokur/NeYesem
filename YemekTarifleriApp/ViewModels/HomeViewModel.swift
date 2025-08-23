//
//  HomeViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 13.08.2025.
//

import Foundation
import UIKit

final class HomeViewModel {
    
    // MARK: - Properties
    private let userService: UserServiceProtocol
    private(set) var recommendedRecipes: [RecipeUIModel] = [] {
        didSet { onRecommendedUpdated?() }
    }
    private(set) var searchSuggestions: [RecipeUIModel] = [] {
        didSet { onSearchSuggestionsUpdated?() }
    }
    private(set) var recentViewedRecipes: [RecipeUIModel] = [] {
        didSet { onRecentViewedUpdated?() }
    }

    private(set) var categories: [CategoryModel] = []
    // MARK: - Bindings
    var onRecommendedUpdated: (() -> Void)?
    var onSearchSuggestionsUpdated: (() -> Void)?
    var onRecentViewedUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - Init
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        loadCategoriesFromJSON(limit: 5)
    }
    
    // MARK: - Load Categories
    private func loadCategoriesFromJSON(limit: Int = 5) {
        guard let url = Bundle.main.url(forResource: "Categories", withExtension: "json") else {
            print("Categories.json not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([CategoryModel].self, from: data)
            self.categories = Array(decoded.prefix(limit))
        } catch {
            print("Failed to decode Categories.json:", error)
        }
    }
    
    // MARK: - Recommended Recipes
    func fetchRecommendedRecipes() {
        userService.fetchCurrentUser { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let user):
                var diet: String?
                if user.diet != "Classic" { diet = user.diet }
                let allergies = user.allergies
                let dislikes = user.dislikes

                SpoonacularService.shared.searchRecipes(
                    query: nil,
                    diet: diet,
                    intolerances: allergies,
                    excludeIngredients: dislikes
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let recipes):
                            let group = DispatchGroup()
                            var uiModels: [RecipeUIModel] = []

                            for recipe in recipes {
                                group.enter()

                                let matchedType = recipe.dishTypes?.first { type in
                                    self.categories.contains(where: { $0.title.lowercased() == type.lowercased() })
                                }
                                let color = self.categories.first(where: { $0.title.lowercased() == matchedType?.lowercased() })?.colorHex.flatMap { UIColor(hex: $0) } ?? .systemGray

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
                                self.recommendedRecipes = uiModels
                                self.onRecommendedUpdated?()
                            }

                        case .failure(let error):
                            self.recommendedRecipes = []
                            self.onError?("Önerilen tarifler alınamadı: \(error.localizedDescription)")
                        }
                    }
                }

            case .failure(let error):
                DispatchQueue.main.async {
                    self.onError?("Kullanıcı bilgileri alınamadı: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Search Suggestions
    func fetchAutocompleteSuggestions(query: String) {
        SpoonacularService.shared.autocompleteRecipes(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let suggestions):
                    self?.searchSuggestions = suggestions.map {
                        RecipeUIModel(recipe: Recipe(id: $0.id,
                                                     title: $0.title,
                                                     image: nil,
                                                    readyInMinutes: nil,
                                                     dishTypes: nil,
                                                     missedIngredientCount: 0),
                                      isFavorite: false,
                                      likeCount: 0,
                                      color: .gray)
                    }
                case .failure(let error):
                    self?.searchSuggestions = []
                    self?.onError?("Autocomplete önerileri alınamadı: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Recent Viewed
    func fetchRecentViewed(limit: Int = 20) {
        RecentViewService.shared.fetchRecentViews(limit: limit) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let recipes):
                        guard let self = self else { return }

                        let group = DispatchGroup()
                        var uiModels: [RecipeUIModel] = []

                        for recipe in recipes {
                            group.enter()

                            let matchedType = recipe.dishTypes?.first { type in
                                self.categories.contains(where: { $0.title.lowercased() == type.lowercased() })
                            }
                            let color = self.categories.first(where: { $0.title.lowercased() == matchedType?.lowercased() })?.colorHex.flatMap { UIColor(hex: $0) } ?? .systemGray

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
                            self.recentViewedRecipes = uiModels
                            self.onRecentViewedUpdated?()
                        }

                    case .failure(let error):
                        self?.recentViewedRecipes = []
                        self?.onError?("Son görüntülenen tarifler alınamadı: \(error.localizedDescription)")
                    }
                }
            }
    }

    // MARK: - Toggle Favorite
    func toggleFavorite(in listType: ListType, at index: Int, completion: @escaping (Bool) -> Void) {
        var recipeModel: RecipeUIModel
        
        switch listType {
        case .recommended:
            guard index < recommendedRecipes.count else { completion(false); return }
            recipeModel = recommendedRecipes[index]
        case .search:
            guard index < searchSuggestions.count else { completion(false); return }
            recipeModel = searchSuggestions[index]
        case .recent:
            guard index < recentViewedRecipes.count else { completion(false); return }
            recipeModel = recentViewedRecipes[index]
        }

        FavoriteService.shared.toggleFavorite(recipe: recipeModel.recipe) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    recipeModel.isFavorite.toggle()
                    if recipeModel.isFavorite {
                        recipeModel.likeCount += 1
                    } else {
                        recipeModel.likeCount -= 1
                    }

                    switch listType {
                    case .recommended:
                        self?.recommendedRecipes[index] = recipeModel
                    case .search:
                        self?.searchSuggestions[index] = recipeModel
                    case .recent:
                        self?.recentViewedRecipes[index] = recipeModel
                    }

                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }
}

// MARK: - List Type
enum ListType {
    case recommended
    case search
    case recent
}
