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
    
    // MARK: - Add favorite
    func addFavorite(recipe: Recipe, completion: @escaping (Bool) -> Void) {
        guard let userId = currentUserId else { completion(false); return }
        
        let recipeRef = db.collection("favorites").document("\(recipe.id)")
        let globalUserRef = recipeRef.collection("users").document(userId)
        let userFavRef = db.collection("users").document(userId).collection("favorites").document("\(recipe.id)")
        
        db.runTransaction({ tx, errPtr in
            let userDoc = try? tx.getDocument(globalUserRef)
            if userDoc?.exists == true { return nil }
            
            let recipeDoc = try? tx.getDocument(recipeRef)
            let oldCount = recipeDoc?.data()?["likeCount"] as? Int ?? 0
            let newCount = oldCount + 1
            
            tx.setData([
                "recipeId": recipe.id,
                "title": recipe.title,
                "image": recipe.image ?? "",
                "readyInMinutes": recipe.readyInMinutes ?? 0,
                "dishTypes": recipe.dishTypes ?? [],
                "likeCount": newCount,
                "updatedAt": FieldValue.serverTimestamp()
            ], forDocument: recipeRef, merge: true)
            
            tx.setData([
                "userId": userId,
                "createdAt": FieldValue.serverTimestamp()
            ], forDocument: globalUserRef)
            
            tx.setData([
                "recipeId": recipe.id,
                "title": recipe.title,
                "image": recipe.image ?? "",
                "readyInMinutes": recipe.readyInMinutes ?? 0,
                "dishTypes": recipe.dishTypes ?? [],
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
        let globalUserRef = recipeRef.collection("users").document(userId)
        let userFavRef = db.collection("users").document(userId).collection("favorites").document("\(recipeId)")
        
        db.runTransaction({ tx, errPtr in
            let userDoc = try? tx.getDocument(globalUserRef)
            if userDoc?.exists != true { return nil }
            
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
            
            tx.deleteDocument(globalUserRef)
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
    func fetchUserFavorites(completion: @escaping ([Recipe]) -> Void) {
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
                    let recipes = snapshot?.documents.compactMap { doc -> Recipe? in
                        guard let id = doc["recipeId"] as? Int,
                              let title = doc["title"] as? String
                        else { return nil }
                        
                        let image = doc["image"] as? String ?? ""
                        let readyInMinutes = doc["readyInMinutes"] as? Int ?? 0
                        let dishTypes = doc["dishTypes"] as? [String] ?? []
                        
                        return Recipe(
                            id: id,
                            title: title,
                            image: image,
                            readyInMinutes: readyInMinutes,
                            dishTypes: dishTypes,
                            missedIngredientCount: 0
                        )
                    } ?? []
                    completion(recipes)
                }
            }
    }
    
    // MARK: - Fetch only favorite IDs
    func fetchAllFavorites(completion: @escaping ([Int]) -> Void) {
        guard let userId = currentUserId else {
            completion([])
            return
        }
        
        db.collection("users")
            .document(userId)
            .collection("favorites")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Favori ID'ler alınamadı:", error.localizedDescription)
                    completion([])
                } else {
                    let ids = snapshot?.documents.compactMap { doc -> Int? in
                        return doc["recipeId"] as? Int
                    } ?? []
                    completion(ids)
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
