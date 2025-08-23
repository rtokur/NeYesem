//
//  RecentViewService.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 15.08.2025.
//

import FirebaseAuth
import FirebaseFirestore

// MARK: - Protocol
protocol RecentViewServiceProtocol {
    func addOrUpdateRecentView(_ recipe: Recipe, completion: ((Result<Void, Error>) -> Void)?)
    func fetchRecentViews(limit: Int, completion: @escaping (Result<[Recipe], Error>) -> Void)
}

final class RecentViewService: RecentViewServiceProtocol {
    // MARK: - Properties
    static let shared = RecentViewService()
    private init() {}

    private let db = Firestore.firestore()
    private var auth: Auth { Auth.auth() }

    // MARK: - Firestore Collection Reference
    private func collectionRef() throws -> CollectionReference {
        guard let uid = auth.currentUser?.uid else {
            throw NSError(domain: "RecentViewService", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        return db.collection("users").document(uid).collection("recentViews")
    }

    // MARK: - Add or Update Recent View
    func addOrUpdateRecentView(_ recipe: Recipe, completion: ((Result<Void, Error>) -> Void)? = nil) {
        do {
            let col = try collectionRef()
            let docId = String(recipe.id)
            let data: [String: Any] = [
                "recipeId": recipe.id,
                "title": recipe.title,
                "image": recipe.image ?? "",
                "readyInMinutes": recipe.readyInMinutes ?? 0,
                "dishTypes": recipe.dishTypes ?? [],
                "viewedAt": FieldValue.serverTimestamp()
            ]
            col.document(docId).setData(data, merge: true) { err in
                if let err = err { completion?(.failure(err)) } else { completion?(.success(())) }
            }
        } catch {
            completion?(.failure(error))
        }
    }

    // MARK: - Fetch Recent Views
    func fetchRecentViews(limit: Int = 20, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        do {
            let col = try collectionRef()
            col.order(by: "viewedAt", descending: true).limit(to: limit).getDocuments { snap, err in
                if let err = err { completion(.failure(err)); return }
                let items: [Recipe] = snap?.documents.compactMap { doc in
                    let data = doc.data()
                    return Recipe(
                        id: data["recipeId"] as? Int ?? 0,
                        title: data["title"] as? String ?? "",
                        image: data["image"] as? String,
                        readyInMinutes: data["readyInMinutes"] as? Int,
                        dishTypes: data["dishTypes"] as? [String],
                        missedIngredientCount: 0
                    )
                } ?? []
                completion(.success(items))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
