//
//  HomeViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 13.08.2025.
//

import Foundation

final class HomeViewModel {
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

    // MARK: - Bindings
    var onRecommendedUpdated: (() -> Void)?
    var onSearchSuggestionsUpdated: (() -> Void)?
    var onRecentViewedUpdated: (() -> Void)?
    var onError: ((String) -> Void)?

    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    // MARK: - Recommended Recipes
    func fetchRecommendedRecipes() {
            userService.fetchCurrentUser { [weak self] result in
                switch result {
                case .success(let user):
                    var diet: String?
                    if user.diet != "Classic" {
                        diet = user.diet
                    }
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
                                self?.recommendedRecipes = recipes.map {
                                    RecipeUIModel(recipe: $0, isFavorite: false, likeCount: 0)
                                }
                                self?.onRecommendedUpdated?()
                                
                            case .failure(let error):
                                self?.recommendedRecipes = []
                                self?.onError?("Önerilen tarifler alınamadı: \(error.localizedDescription)")
                            }
                        }
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError?("Kullanıcı bilgileri alınamadı: \(error.localizedDescription)")
                    }
                }
            }
        }


    // MARK: - Search Suggestions
    func fetchSearchSuggestions(query: String) {
        SpoonacularService.shared.searchRecipes(query: query,
                                                diet: nil,
                                                intolerances: [],
                                                excludeIngredients: []) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    self?.searchSuggestions = recipes.map {
                        RecipeUIModel(recipe: $0, isFavorite: false, likeCount: 0)
                    }
                case .failure(let error):
                    self?.searchSuggestions = []
                    self?.onError?("Arama önerileri alınamadı: \(error.localizedDescription)")
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
                    self?.recentViewedRecipes = recipes.map {
                        RecipeUIModel(recipe: $0, isFavorite: false, likeCount: 0)
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
        let recipe: Recipe
        switch listType {
        case .recommended:
            guard index < recommendedRecipes.count else { completion(false); return }
            recipe = recommendedRecipes[index].recipe
        case .search:
            guard index < searchSuggestions.count else { completion(false); return }
            recipe = searchSuggestions[index].recipe
        case .recent:
            guard index < recentViewedRecipes.count else { completion(false); return }
            recipe = recentViewedRecipes[index].recipe
        }

        FavoriteService.shared.toggleFavorite(recipe: recipe) { success in
            DispatchQueue.main.async { completion(success) }
        }
    }
}

// MARK: - List Type
enum ListType {
    case recommended
    case search
    case recent
}
