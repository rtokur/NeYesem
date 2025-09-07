//
//  RecipeDetailViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 14.08.2025.
//

import Foundation

final class RecipeDetailViewModel {
    
    // MARK: - Properties
    private let recipeId: Int
    private(set) var recipeDetail: RecipeDetail?

    var onLikeCountChanged: ((Int) -> Void)?
    var onDataFetched: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onFavoriteStatusChanged: ((Bool) -> Void)?

    private(set) var isFavorited: Bool = false {
        didSet { onFavoriteStatusChanged?(isFavorited) }
    }

    private(set) var likeCount: Int = 0 {
        didSet { onLikeCountChanged?(likeCount) }
    }
    
    // MARK: - Init
    init(recipeId: Int) {
        self.recipeId = recipeId
    }
    
    // MARK: - Fetch Recipe Detail
    func fetchRecipeDetail() {
        SpoonacularService.shared.getRecipeDetail(recipeId: recipeId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.recipeDetail = detail
                    self?.onDataFetched?()
                    self?.updateFavoriteStatus()
                    self?.fetchLikeCount()
                    self?.trackCurrentAsRecent()
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
    
    // MARK: - Minimal Recipe
    func makeMinimalRecipe() -> Recipe? {
        guard let recipeDetail = recipeDetail else { return nil }
        return Recipe(
            id: recipeDetail.id,
            title: recipeDetail.title,
            image: recipeDetail.image,
            readyInMinutes: recipeDetail.readyInMinutes,
            dishTypes: recipeDetail.dishTypes,
            missedIngredientCount: 0,
            nutrition: nil
        )
    }
    
    // MARK: - Favorite Check
    private func updateFavoriteStatus() {
        FavoriteService.shared.isFavorite(recipeId: recipeId) { [weak self] isFav in
            DispatchQueue.main.async {
                self?.isFavorited = isFav
            }
        }
    }
    
    func toggleFavorite() {
        guard let recipe = makeMinimalRecipe() else { return }
        
        FavoriteService.shared.toggleFavorite(recipe: recipe) { [weak self] success in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if success {
                    self.isFavorited.toggle()
                    self.fetchLikeCount()
                } else {
                    self.onError?(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Favori güncellenemedi"]))
                }
            }
        }
    }
    
    // MARK: - Recent Tracking
    func trackCurrentAsRecent() {
        guard let recipe = makeMinimalRecipe() else { return }
        RecentViewService.shared.addOrUpdateRecentView(recipe, completion: nil)
    }
    
    // MARK: - Like Count
    func fetchLikeCount() {
        FavoriteService.shared.getLikeCount(recipeId: recipeId) { [weak self] count in
            DispatchQueue.main.async {
                self?.likeCount = count
            }
        }
    }
    
    // MARK: - Computed Properties for UI
    var imageUrl: URL? {
        guard let urlString = recipeDetail?.image else { return nil }
        return URL(string: urlString)
    }
    
    var titleText: String {
        recipeDetail?.title ?? ""
    }
    
    var descriptionText: String {
        let html = recipeDetail?.summary ?? ""
        return html.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
    
    var servingsText: String {
        "\(recipeDetail?.servings ?? 0)"
    }
    
    var timeText: String {
        "\(recipeDetail?.readyInMinutes ?? 0)"
    }
    
    var typeText: String {
        recipeDetail?.dishTypes?.first ?? "-"
    }
    
    var caloriesText: String {
        if let cal = recipeDetail?.nutrition?.nutrients.first(where: { $0.name == "Calories" }) {
            return "\(Int(cal.amount))"
        }
        return "Kalori bilgisi yok"
    }
    
    var ingredientsText: [String] {
        guard let ingredients = recipeDetail?.extendedIngredients else { return [] }
        return ingredients.map { ing in
            let name = ing.name.capitalized
            let amt = (ing.amount ?? 0)
            let unit = ing.unit?.isEmpty == false ? " \(ing.unit!)" : ""
            return amt > 0 ? "\(Int(amt))\(unit) \(name)" : name
        }
    }
    
    var instructionItems: [InstructionStep] {
        guard let steps = recipeDetail?.analyzedInstructions?.first?.steps else { return [] }
        return steps.map { InstructionStep(number: $0.number, step: $0.step) }
    }
}
