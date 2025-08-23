//
//  MealService.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 13.08.2025.
//
import Foundation

final class SpoonacularService {
    // MARK: - Properties
    static let shared = SpoonacularService()
    private init() {}
    
    private let apiKey = "9e8a593aff3a4cacaa86b6bbc0347da9"
    
    // MARK: - Generic API Request
    private func performRequest<T: Decodable>(urlString: String,
                                              queryItems: [URLQueryItem] = [],
                                              completion: @escaping (Result<T, Error>) -> Void) {
        var components = URLComponents(string: urlString)
        var items = queryItems
        items.append(URLQueryItem(name: "apiKey", value: apiKey))
        components?.queryItems = items
        
        guard let url = components?.url else {
            completion(.failure(NSError(domain: "URL Error", code: -1)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1)))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Recipe Search
    func searchRecipes(query: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        searchRecipes(query: query, diet: nil, intolerances: [], excludeIngredients: [], completion: completion)
    }
    
    func searchRecipes(query: String?,
                       diet: String?,
                       intolerances: [String],
                       excludeIngredients: [String],
                       completion: @escaping (Result<[Recipe], Error>) -> Void) {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "addRecipeInformation", value: "true"),
            URLQueryItem(name: "number", value: "8")
        ]
        
        if let query = query, !query.isEmpty {
            queryItems.append(URLQueryItem(name: "query", value: query))
        }
        if let diet = diet, !diet.isEmpty {
            queryItems.append(URLQueryItem(name: "diet", value: diet))
        }
        if !intolerances.isEmpty {
            queryItems.append(URLQueryItem(name: "intolerances", value: intolerances.joined(separator: ",")))
        }
        if !excludeIngredients.isEmpty {
            queryItems.append(URLQueryItem(name: "excludeIngredients", value: excludeIngredients.joined(separator: ",")))
        }
        
        performRequest(urlString: "https://api.spoonacular.com/recipes/complexSearch",
                       queryItems: queryItems) { (result: Result<RecipeSearchResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Recipe Detail
    func getRecipeDetail(recipeId: Int, completion: @escaping (Result<RecipeDetail, Error>) -> Void) {
        performRequest(urlString: "https://api.spoonacular.com/recipes/\(recipeId)/information",
                       queryItems: [URLQueryItem(name: "includeNutrition", value: "true")],
                       completion: completion)
    }
    
    // MARK: - Autocomplete Recipes
    func autocompleteRecipes(query: String, completion: @escaping (Result<[AutocompleteRecipe], Error>) -> Void) {
        performRequest(urlString: "https://api.spoonacular.com/recipes/autocomplete",
                       queryItems: [URLQueryItem(name: "query", value: query),
                                    URLQueryItem(name: "number", value: "10")],
                       completion: completion)
    }

    // MARK: - Autocomplete Ingredients
    func autocompleteIngredients(query: String, completion: @escaping (Result<[IngredientResult], Error>) -> Void) {
        performRequest(urlString: "https://api.spoonacular.com/food/ingredients/autocomplete",
                       queryItems: [URLQueryItem(name: "query", value: query),
                                    URLQueryItem(name: "number", value: "10"),
                                    URLQueryItem(name: "metaInformation", value: "true")],
                       completion: completion)
    }
    
    // MARK: - Search Recipes by Ingredients
    func searchRecipesByIngredients(ingredients: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        performRequest(urlString: "https://api.spoonacular.com/recipes/findByIngredients",
                       queryItems: [URLQueryItem(name: "ingredients", value: ingredients),
                                    URLQueryItem(name: "number", value: "2"),
                                    URLQueryItem(name: "ranking", value: "2"),
                                    URLQueryItem(name: "ignorePantry", value: "false")],
                       completion: completion)
    }
}
