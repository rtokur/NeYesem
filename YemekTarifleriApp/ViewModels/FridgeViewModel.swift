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
    
    private(set) var aisles: [String: [AisleProduct]] = [:]
    
    var recommendedRecipes: [RecipeUIModel] = [] {
        didSet { onRecipesUpdated?() }
    }
    
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
    
    func fetchRecipesFromFridge() {
        let ingredients = filteredItems.map { $0.name }.joined(separator: ",")
        SpoonacularService.shared.searchRecipesByIngredients(ingredients: ingredients) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes): 
                    self?.recommendedRecipes = recipes.map { summary in

                        let recipe = Recipe(
                            id: summary.id,
                            title: summary.title,
                            image: summary.image,
                            readyInMinutes: summary.readyInMinutes,
                            dishTypes: summary.dishTypes,
                            missedIngredientCount: summary.missedIngredientCount
                        )
                        
                        return RecipeUIModel(
                            recipe: recipe,
                            isFavorite: false,
                            likeCount: 0,
                            color: .gray
                        )
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
}

