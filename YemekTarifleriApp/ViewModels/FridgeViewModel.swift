//
//  FridgeViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 22.08.2025.
//

import Foundation
import FirebaseFirestore

final class FridgeViewModel {
    // MARK: - Properties
    private let service: FridgeServiceProtocol
    
    private(set) var fridgeItems: [IngredientUIModel] = [] {
        didSet { groupItemsByAisle() }
    }
    
    private(set) var groupedItems: [String: [IngredientUIModel]] = [:] {
        didSet { onFridgeUpdated?() }
    }
    
    private(set) var selectedAisle: String? {
        didSet { filterGroupedItems() }
    }
    
    private(set) var filteredItems: [IngredientUIModel] = [] {
        didSet { onFridgeUpdated?() }
    }
    
    var recommendedRecipes: [RecipeUIModel] = [] {
        didSet { onRecipesUpdated?() }
    }
    
    private(set) var categories: [CategoryModel] = []

    private(set) var aisles: [String: [AisleProduct]] = [:]
    
    var allAisles: [String] {
        return Array(aisles.keys)
    }
    
    var onRecipesUpdated: (() -> Void)?
    var onFridgeUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Init
    init(service: FridgeServiceProtocol = FridgeService()) {
        self.service = service
        loadAislesFromJSON()
        loadCategoriesFromJSON()
    }
    
    // MARK: - Public Methods
    func fetchFridgeItems() {
        service.fetchFridgeItems { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self?.fridgeItems = items
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func updateFridgeItem(_ item: IngredientUIModel) {
        service.updateFridgeItem(item) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    if let index = self?.fridgeItems.firstIndex(where: { $0.id == item.id }) {
                        self?.fridgeItems[index] = item
                    }
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteFridgeItem(_ item: IngredientUIModel, completion: ((Int?) -> Void)? = nil) {
        service.deleteFridgeItem(item) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    if let index = self?.fridgeItems.firstIndex(where: { $0.id == item.id }) {
                        self?.fridgeItems.remove(at: index)
                        completion?(index)
                    } else {
                        completion?(nil)
                    }
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                    completion?(nil)
                }
            }
        }
    }
    
    func selectAisle(_ aisle: String?) {
        selectedAisle = aisle
    }
    
    func toggleFavorite(in index: Int, completion: @escaping (Bool) -> Void) {
        guard index < recommendedRecipes.count else { completion(false); return }
        var recipeModel = recommendedRecipes[index]
        
        FavoriteService.shared.toggleFavorite(recipe: recipeModel.recipe) { success in
            if success {
                recipeModel.isFavorite.toggle()
                if recipeModel.isFavorite {
                    recipeModel.likeCount += 1
                } else {
                    recipeModel.likeCount -= 1
                }
                self.recommendedRecipes[index] = recipeModel
            }
            completion(success)
        }
    }
    
    func fetchRecipesFromFridge() {
        let ingredients = filteredItems.map { $0.name }.joined(separator: ",")
        SpoonacularService.shared.searchRecipesByIngredients(ingredients: ingredients) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let recipes):
                    let group = DispatchGroup()
                    var uiModels: [RecipeUIModel] = []
                    
                    for summary in recipes {
                        group.enter()
                        
                        let randomCategory = self.categories.randomElement()
                        let color = randomCategory?.colorHex.flatMap { UIColor(hex: $0) } ?? .systemGray
                        
                        let recipe = Recipe(
                            id: summary.id,
                            title: summary.title,
                            image: summary.image,
                            readyInMinutes: summary.readyInMinutes,
                            dishTypes: [randomCategory?.title ?? ""],
                            missedIngredientCount: summary.missedIngredientCount,
                            nutrition: nil
                        )
                        
                        FavoriteService.shared.isFavorite(recipeId: summary.id) { isFav in
                            FavoriteService.shared.getLikeCount(recipeId: summary.id) { likeCount in
                                let model = RecipeUIModel(
                                    recipe: recipe,
                                    isFavorite: isFav,
                                    likeCount: likeCount,
                                    color: color,
                                    createdAt: Date()
                                )
                                uiModels.append(model)
                                group.leave()
                            }
                        }
                    }
                    
                    group.notify(queue: .main) {
                        self.recommendedRecipes = uiModels
                        self.onRecipesUpdated?()
                    }
                    
                case .failure(let error):
                    print("Recipe fetch error:", error)
                }
            }
        }
    }

    // MARK: - Private Methods
    private func groupItemsByAisle() {
        var grouped: [String: [IngredientUIModel]] = [:]
        for item in fridgeItems {
            grouped[item.aisle ?? "", default: []].append(item)
        }
        groupedItems = grouped
        filterGroupedItems()
    }
    
    private func filterGroupedItems() {
        if let aisle = selectedAisle {
            filteredItems = groupedItems[aisle] ?? []
        } else {
            filteredItems = fridgeItems
        }
    }
    
    private func loadAislesFromJSON() {
        guard let url = Bundle.main.url(forResource: "Aisle", withExtension: "json") else {
            print("Aisle.json not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([String: [AisleProduct]].self, from: data)
            self.aisles = decoded
        } catch {
            print("Aisles JSON decode error: \(error)")
        }
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
}

