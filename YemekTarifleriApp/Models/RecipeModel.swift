//
//  RecipeModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 13.08.2025.
//

import Foundation
import UIKit
import FirebaseFirestore

struct RecipeSearchResponse: Codable {
    let results: [Recipe]
    let totalResults: Int?
}

struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String?
    let readyInMinutes: Int?
    let dishTypes: [String]?
    let missedIngredientCount: Int?
}

struct RecipeDetail: Codable {
    let id: Int
    let title: String
    let summary: String?
    let servings: Int?
    let readyInMinutes: Int?
    let dishTypes: [String]?
    let extendedIngredients: [Ingredient]?
    let analyzedInstructions: [Instruction]?
    let image: String?
    let nutrition: NutritionInfo?
}

struct Ingredient: Codable {
    let id: Int?
    let name: String
    let amount: Double?
    let unit: String?
}

struct Instruction: Codable {
    let name: String
    let steps: [InstructionStep]
}

struct InstructionStep: Codable {
    let number: Int
    let step: String
}

struct NutritionInfo: Codable {
    let nutrients: [Nutrient]
}

struct Nutrient: Codable {
    let name: String
    let amount: Double
    let unit: String
}

struct RecipeUIModel {
    let recipe: Recipe
    var isFavorite: Bool
    var likeCount: Int
    var color: UIColor
}

struct AutocompleteRecipe: Codable {
    let id: Int
    let title: String
}

struct IngredientResult: Decodable {
    let id: Int?
    let name: String
    let image: String?
    let aisle: String?
    let possibleUnits: [String]?
}

struct CategoryModel: Codable {
    let title: String
    let type: String
    let colorHex: String?
}

struct IngredientUIModel: Codable {
    @DocumentID var id: String?
    let name: String
    var amount: Double?
    let unit: String?
    let aisle: String?
}

struct AisleProduct: Codable {
    let name: String
    let units: [String]?
}
