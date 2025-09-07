//
//  FridgeService.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 22.08.2025.
//

import Foundation
import FirebaseFirestore

// MARK: - Protocol
protocol FridgeServiceProtocol {
    func fetchFridgeItems(completion: @escaping (Result<[IngredientUIModel], Error>) -> Void)
    func updateFridgeItem(_ item: IngredientUIModel, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteFridgeItem(_ item: IngredientUIModel, completion: @escaping (Result<Void, Error>) -> Void)
    func saveProducts(_ products: [IngredientUIModel], completion: @escaping (Result<Void, Error>) -> Void)
}

final class FridgeService: FridgeServiceProtocol {
    // MARK: - Properties
    private let db = Firestore.firestore()

    // MARK: - Firestore Collection Reference
    private func fridgeCollection(for uid: String) -> CollectionReference {
        db.collection("users").document(uid).collection("fridges")
    }

    // MARK: - Fetch Fridge Items
    func fetchFridgeItems(completion: @escaping (Result<[IngredientUIModel], Error>) -> Void) {
        guard let uid = AuthManager().currentUser?.uid else {
            completion(.failure(NSError(domain: "Auth", code: 401,
                                        userInfo: [NSLocalizedDescriptionKey: "Kullanıcı giriş yapmamış"])))
            return
        }

        fridgeCollection(for: uid).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let docs = snapshot?.documents else {
                completion(.success([]))
                return
            }

            let items = docs.compactMap { try? $0.data(as: IngredientUIModel.self) }
            completion(.success(items))
        }
    }

    // MARK: - Update Fridge Item
    func updateFridgeItem(_ item: IngredientUIModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = AuthManager().currentUser?.uid, let id = item.id else {
            completion(.failure(NSError(domain: "Auth", code: 401,
                                        userInfo: [NSLocalizedDescriptionKey: "Kullanıcı giriş yapmamış veya id eksik"])))
            return
        }

        do {
            try fridgeCollection(for: uid).document(id).setData(from: item, merge: true)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Delete Fridge Item
    func deleteFridgeItem(_ item: IngredientUIModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = AuthManager().currentUser?.uid, let id = item.id else {
            completion(.failure(NSError(domain: "Auth", code: 401,
                                        userInfo: [NSLocalizedDescriptionKey: "Kullanıcı giriş yapmamış veya id eksik"])))
            return
        }

        fridgeCollection(for: uid).document(id).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Save Multiple Products
    func saveProducts(_ products: [IngredientUIModel],
                      completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = AuthManager().currentUser?.uid else {
            completion(.failure(NSError(
                domain: "Auth",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "Kullanıcı giriş yapmamış"]
            )))
            return
        }
        
        let fridgeRef = db.collection("users").document(uid).collection("fridges")
        let group = DispatchGroup()
        var lastError: Error?
        
        for product in products {
            let key = "\(product.name.lowercased())_\(product.aisle?.lowercased() ?? "")"
            let docRef = fridgeRef.document(key)
            
            group.enter()
            docRef.getDocument { snapshot, error in
                if let error = error {
                    lastError = error
                    group.leave()
                    return
                }
                
                if snapshot?.exists == true {
                    lastError = NSError(
                        domain: "Fridge",
                        code: 409,
                        userInfo: [NSLocalizedDescriptionKey: "\(product.name) is already in the fridge."]
                    )
                    group.leave()
                    return
                } else {
                    let ingredient = IngredientUIModel(
                        id: key,
                        name: product.name,
                        amount: product.amount,
                        unit: product.unit,
                        aisle: product.aisle
                    )
                    do {
                        try docRef.setData(from: ingredient)
                    } catch {
                        lastError = error
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = lastError {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
