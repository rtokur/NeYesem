//
//  MealService.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 13.08.2025.
//
import Foundation

final class SpoonacularService {
    static let shared = SpoonacularService()
    private init() {}
    
    private let apiKey = "9e8a593aff3a4cacaa86b6bbc0347da9"
    
    func searchRecipes(query: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        searchRecipes(query: query, diet: nil, intolerances: [], excludeIngredients: [], completion: completion)
    }
    
    func searchRecipes(
        query: String?,
        diet: String?,
        intolerances: [String],
        excludeIngredients: [String],
        completion: @escaping (Result<[Recipe], Error>) -> Void
    ) {
        let urlString = "https://api.spoonacular.com/recipes/complexSearch"
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "apiKey", value: apiKey),
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
        
        var components = URLComponents(string: urlString)
        components?.queryItems = queryItems
        
        guard let finalURL = components?.url else {
            completion(.failure(NSError(domain: "URL Error", code: -1)))
            return
        }
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(RecipeSearchResponse.self, from: data)
                completion(.success(decoded.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getRecipeDetail(recipeId: Int, completion: @escaping (Result<RecipeDetail, Error>) -> Void) {
        let urlString = "https://api.spoonacular.com/recipes/\(recipeId)/information?apiKey=\(apiKey)&includeNutrition=true"
        
        guard let url = URL(string: urlString) else {
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
                let decoded = try JSONDecoder().decode(RecipeDetail.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
