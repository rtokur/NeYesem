//
//  FavoriteService.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 15.08.2025.
//

import FirebaseAuth
import FirebaseFirestore

final class FavoriteService {
    // MARK: - Properties
    static let shared = FavoriteService()
    private init() {}
    
    private var db: Firestore { Firestore.firestore() }
    
    private var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }
    
    private var categories: [CategoryModel] = {
        guard let url = Bundle.main.url(forResource: "Categories", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([CategoryModel].self, from: data) else { return [] }
        return decoded
    }()
    
    // MARK: - Add favorite
    func addFavorite(recipe: Recipe, completion: @escaping (Bool) -> Void) {
        guard let userId = currentUserId else { completion(false); return }
        
        let recipeRef = db.collection("favorites").document("\(recipe.id)")
        let userFavRef = db.collection("users").document(userId).collection("favorites").document("\(recipe.id)")
        
        let matchedType = recipe.dishTypes?.first { type in
            self.categories.contains(where: { $0.type.lowercased() == type.lowercased() })
        }
        let colorHex = self.categories.first(where: { $0.type.lowercased() == matchedType?.lowercased() })?.colorHex ?? "#808080"
        
        db.runTransaction({ tx, errPtr in
            let recipeDoc = try? tx.getDocument(recipeRef)
            let oldCount = recipeDoc?.data()?["likeCount"] as? Int ?? 0
            let newCount = oldCount + 1
            let calories = recipe.nutrition?.nutrients.first(where: { $0.name.lowercased() == "calories" })?.amount ?? 0
            tx.setData([
                "recipeId": recipe.id,
                "title": recipe.title,
                "image": recipe.image ?? "",
                "readyInMinutes": recipe.readyInMinutes ?? 0,
                "dishTypes": recipe.dishTypes ?? [],
                "likeCount": newCount,
                "calories": calories,
                "updatedAt": FieldValue.serverTimestamp()
            ], forDocument: recipeRef, merge: true)
            
            tx.setData([
                "recipeId": recipe.id,
                "title": recipe.title,
                "image": recipe.image ?? "",
                "readyInMinutes": recipe.readyInMinutes ?? 0,
                "dishTypes": recipe.dishTypes ?? [],
                "colorHex": colorHex,
                "calories": calories,
                "createdAt": FieldValue.serverTimestamp()
            ], forDocument: userFavRef)
            
            return nil
        }) { _, error in
            if let error = error {
                print("Favori eklenemedi:", error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // MARK: - Remove favorite
    func removeFavorite(recipeId: Int, completion: @escaping (Bool) -> Void) {
        guard let userId = currentUserId else { completion(false); return }
        
        let recipeRef = db.collection("favorites").document("\(recipeId)")
        let userFavRef = db.collection("users").document(userId).collection("favorites").document("\(recipeId)")
        
        db.runTransaction({ tx, errPtr in
            let recipeDoc = try? tx.getDocument(recipeRef)
            let oldCount = recipeDoc?.data()?["likeCount"] as? Int ?? 0
            let newCount = max(oldCount - 1, 0)
            
            if newCount == 0 {
                tx.deleteDocument(recipeRef)
            } else {
                tx.updateData([
                    "likeCount": newCount,
                    "updatedAt": FieldValue.serverTimestamp()
                ], forDocument: recipeRef)
            }
            
            tx.deleteDocument(userFavRef)
            
            return nil
        }) { _, error in
            if let error = error {
                print("Favori silinemedi:", error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    
    // MARK: - Check favorite state
    func isFavorite(recipeId: Int, completion: @escaping (Bool) -> Void) {
        guard let userId = currentUserId else { completion(false); return }
        
        let userFavRef = db.collection("users").document(userId).collection("favorites").document("\(recipeId)")
        userFavRef.getDocument { snapshot, error in
            if let error = error {
                print("Favori kontrol hatası:", error.localizedDescription)
                completion(false)
            } else {
                completion(snapshot?.exists ?? false)
            }
        }
    }
    
    // MARK: - Recipe like count
    func getLikeCount(recipeId: Int, completion: @escaping (Int) -> Void) {
        db.collection("favorites")
            .document("\(recipeId)")
            .getDocument { snapshot, error in
                if let error = error {
                    print("Like count alınamadı:", error.localizedDescription)
                    completion(0)
                } else {
                    let count = snapshot?.data()?["likeCount"] as? Int ?? 0
                    completion(count)
                }
            }
    }
    
    // MARK: - Fetch current user's favorites
    func fetchUserFavorites(completion: @escaping ([RecipeUIModel]) -> Void) {
        guard let userId = currentUserId else { completion([]); return }
        
        db.collection("users")
            .document(userId)
            .collection("favorites")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Kullanıcı favorileri alınamadı:", error.localizedDescription)
                    completion([])
                } else {
                    guard let docs = snapshot?.documents else {
                        completion([])
                        return
                    }

                    var favorites: [RecipeUIModel] = []
                    let group = DispatchGroup()

                    for doc in docs {
                        group.enter()
                        
                        guard let id = doc["recipeId"] as? Int,
                              let title = doc["title"] as? String else {
                                  group.leave()
                                  continue
                              }
                        
                        let image = doc["image"] as? String ?? ""
                        let readyInMinutes = doc["readyInMinutes"] as? Int ?? 0
                        let dishTypes = doc["dishTypes"] as? [String] ?? []
                        let createdAt = (doc["createdAt"] as? Timestamp)?.dateValue()
                        let color = (doc["colorHex"] as? String).flatMap { UIColor(hex: $0) } ?? .systemGray
                        let calories = doc["calories"] as? Double

                        var likeCount = 0
                        self.getLikeCount(recipeId: id) { count in
                            likeCount = count

                            let recipe = Recipe(
                                id: id,
                                title: title,
                                image: image,
                                readyInMinutes: readyInMinutes,
                                dishTypes: dishTypes,
                                missedIngredientCount: 0,
                                nutrition: calories != nil ? NutritionInfo(nutrients: [Nutrient(name: "Calories", amount: calories!, unit: "kcal")]) : nil
                            )

                            let uiModel = RecipeUIModel(
                                recipe: recipe,
                                isFavorite: true,
                                likeCount: likeCount,
                                color: color,
                                createdAt: createdAt
                            )

                            favorites.append(uiModel)
                            group.leave()
                        }
                    }

                    group.notify(queue: .main) {
                        completion(favorites)
                    }
                }
            }
    }

    // MARK: - Toggle favorite
    func toggleFavorite(recipe: Recipe, completion: @escaping (Bool) -> Void) {
        isFavorite(recipeId: recipe.id) { isFav in
            if isFav {
                self.removeFavorite(recipeId: recipe.id, completion: completion)
            } else {
                self.addFavorite(recipe: recipe, completion: completion)
            }
        }
    }
}
