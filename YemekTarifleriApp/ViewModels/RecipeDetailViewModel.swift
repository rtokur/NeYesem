//
//  RecipeDetailViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 14.08.2025.
//

import Foundation

final class RecipeDetailViewModel {
    
    private let recipeId: Int
    private(set) var recipeDetail: RecipeDetail?
    
    var onDataFetched: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(recipeId: Int) {
        self.recipeId = recipeId
    }
    
    func fetchRecipeDetail() {
        SpoonacularService.shared.getRecipeDetail(recipeId: recipeId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.recipeDetail = detail
                    self?.onDataFetched?()
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }
    
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
        "Kaç kişilik: \(recipeDetail?.servings ?? 0)"
    }
    
    var timeText: String {
        "Hazırlama Süresi: \(recipeDetail?.readyInMinutes ?? 0) dk"
    }
    
    var typeText: String {
        "Tip: \(recipeDetail?.dishTypes?.joined(separator: ", ") ?? "-")"
    }
    
    var caloriesText: String {
        if let cal = recipeDetail?.nutrition?.nutrients.first(where: { $0.name == "Calories" }) {
            return "Kalori: \(Int(cal.amount)) \(cal.unit)"
        }
        return "Kalori bilgisi yok"
    }
    
    var ingredientsText: String {
        guard let ingredients = recipeDetail?.extendedIngredients else { return "" }
        return ingredients.map { "- \($0.name) \($0.amount ?? 0) \($0.unit ?? "")" }
                          .joined(separator: "\n")
    }
    
    var instructionsText: String {
        guard let steps = recipeDetail?.analyzedInstructions?.first?.steps else { return "" }
        return steps.map { "\($0.number). \($0.step)" }.joined(separator: "\n")
    }
}
