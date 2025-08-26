//
//  ShoppingListViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 26.08.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

final class ShoppingListViewModel: ObservableObject {
    @Published var shoppingLists: [ShoppingList] = []
    @Published var categoryData: [String: [CategoryItem]] = [:]
    private let db = Firestore.firestore()

    init() {
        loadCategories()
        fetchListsFromFirebase()
    }
    
    // MARK: - Load Aisle.json
    private func loadCategories() {
        guard let url = Bundle.main.url(forResource: "Aisle", withExtension: "json") else {
            print("Aisle.json bulunamadı")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([String: [CategoryItem]].self, from: data)
            self.categoryData = decoded
            print("Aisle loaded: \(self.categoryData.keys)")
        } catch {
            print("Aisle.json decode error: \(error)")
        }
    }
    
    // MARK: - Fetch lists
    func fetchListsFromFirebase() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userID).collection("shoppingLists")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else { return }
                
                self.shoppingLists = documents.compactMap { doc in
                    let data = doc.data()
                    guard let idStr = data["id"] as? String,
                          let id = UUID(uuidString: idStr),
                          let title = data["title"] as? String,
                          let timestamp = data["createdDate"] as? Timestamp,
                          let itemsArray = data["items"] as? [[String: Any]] else { return nil }
                    
                    let items = itemsArray.compactMap { itemDict -> ShoppingItem? in
                        guard let name = itemDict["name"] as? String,
                              let category = itemDict["category"] as? String,
                              let isCompleted = itemDict["isCompleted"] as? Bool else { return nil }
                        return ShoppingItem(
                            id: UUID(uuidString: itemDict["id"] as? String ?? "") ?? UUID(),
                            name: name,
                            category: category,
                            unit: itemDict["unit"] as? String,
                            isCompleted: isCompleted
                        )
                    }
                    
                    return ShoppingList(id: id, title: title, createdDate: timestamp.dateValue(), items: items)
                }
            }
    }
    
    // MARK: - Add list
    func addList(_ list: ShoppingList) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        shoppingLists.append(list)
        
        let docData: [String: Any] = [
            "id": list.id.uuidString,
            "title": list.title,
            "createdDate": Timestamp(date: list.createdDate),
            "items": list.items.map { item in
                [
                    "id": item.id.uuidString,
                    "name": item.name,
                    "category": item.category,
                    "isCompleted": item.isCompleted
                ]
            }
        ]
        
        db.collection("users").document(userID).collection("shoppingLists")
            .document(list.id.uuidString)
            .setData(docData)
    }
    
    func updateList(_ list: ShoppingList) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        if let index = shoppingLists.firstIndex(where: { $0.id == list.id }) {
            shoppingLists[index] = list
        }

        let docData: [String: Any] = [
            "id": list.id.uuidString,
            "title": list.title,
            "createdDate": Timestamp(date: list.createdDate),
            "items": list.items.map { item in
                [
                    "id": item.id.uuidString,
                    "name": item.name,
                    "category": item.category,
                    "isCompleted": item.isCompleted
                ]
            }
        ]

        db.collection("users").document(userID).collection("shoppingLists")
            .document(list.id.uuidString)
            .setData(docData)
    }
    
    // MARK: - Delete list
    func deleteList(_ list: ShoppingList) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        shoppingLists.removeAll { $0.id == list.id }
        
        db.collection("users").document(userID).collection("shoppingLists")
            .document(list.id.uuidString)
            .delete()
    }
}
