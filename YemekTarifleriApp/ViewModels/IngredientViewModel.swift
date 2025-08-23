//
//  IngredientViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 20.08.2025.
//

import Foundation
import FirebaseFirestore

final class IngredientViewModel {
    // MARK: - Properties
    private let fridgeService: FridgeServiceProtocol
    private var aisles: [String: [AisleProduct]] = [:] {
        didSet { updateSelectedAisleProducts() }
    }

    private(set) var suggestions: [IngredientResult] = [] {
        didSet { onSuggestionsUpdated?() }
    }
    
    private(set) var selectedAisleProducts: [AisleProduct] = [] {
        didSet { onProductsUpdated?() }
    }
    
    var selectedProducts: [IngredientUIModel] = []
    var selectedAisle: String? {
        didSet { updateSelectedAisleProducts() }
    }
    
    var allAisles: [String] {
        return Array(aisles.keys)
    }
    
    // MARK: - Events
    var onSuggestionsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    var onProductsUpdated: (() -> Void)?
    var onSaveCompleted: ((Result<Void, Error>) -> Void)?
    
    // MARK: - Init
    init(service: FridgeServiceProtocol = FridgeService()) {
        self.fridgeService = service
        loadAislesFromJSON()
    }
    
    // MARK: - Methods
    func fetchSuggestions(query: String) {
        SpoonacularService.shared.autocompleteIngredients(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self?.suggestions = items
                case .failure(let error):
                    self?.suggestions = []
                    self?.onError?("Ingredient suggestions fetch failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveSelectedProductsToFridge() {
        fridgeService.saveProducts(selectedProducts) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.selectedProducts.removeAll()
                    self?.onSaveCompleted?(.success(()))
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func selectAisle(_ aisle: String) {
        selectedAisle = aisle
    }
    
    func addProduct(_ product: AisleProduct, to aisle: String) {
        if aisles[aisle] == nil { aisles[aisle] = [] }
        
        if !aisles[aisle]!.contains(where: { $0.name == product.name }) {
            aisles[aisle]?.append(product)
            updateSelectedAisleProducts()
        }
    }
    
    func products(for aisle: String) -> [AisleProduct] {
        return aisles[aisle] ?? []
    }
    
    func aisle(for ingredientName: String) -> String? {
        return aisles.first { $0.value.contains(where: { $0.name == ingredientName }) }?.key
    }
    
    // MARK: - Private
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
    
    private func updateSelectedAisleProducts() {
        if let aisle = selectedAisle {
            selectedAisleProducts = aisles[aisle] ?? []
        } else {
            selectedAisleProducts = aisles.values.flatMap { $0 }
        }
    }
}
