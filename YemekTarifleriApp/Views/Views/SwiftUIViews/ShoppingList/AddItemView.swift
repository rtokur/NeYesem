//
//  AddItemView.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 26.08.2025.
//

import Foundation
import SwiftUICore
import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var itemName = ""
    @State private var selectedCategory: String = ""
    
    let existingItems: [ShoppingItem]
    let categoryData: [String: [CategoryItem]]
    @ObservedObject var viewModel: ShoppingListViewModel
    @Binding var list: ShoppingList
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ItemNameInputView(itemName: $itemName)
                    
                    CategorySelectionView(
                        categories: Array(categoryData.keys),
                        selectedCategory: $selectedCategory
                    )
                    
                    SuggestionsView(
                        suggestions: availableSuggestions(),
                        onSelect: { itemName = $0 }
                    )
                    
                    // Save Button
                    Button(action: saveItem) {
                        Text("Add")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color(red: 0.4, green: 0.6, blue: 0.7))
                            )
                    }
                    .disabled(itemName.isEmpty || selectedCategory.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func availableSuggestions() -> [String] {
        guard let items = categoryData[selectedCategory] else { return [] }
        let existingItemNames = Set(existingItems.map { $0.name.lowercased() })
        return items.map { $0.name }
            .filter { !existingItemNames.contains($0.lowercased()) }
    }
    
    private func saveItem() {
        let trimmedName = itemName.trimmingCharacters(in: .whitespacesAndNewlines)
        let newItem = ShoppingItem(name: trimmedName, category: selectedCategory)
        var updatedList = list
        updatedList.items.insert(newItem, at: 0)
        viewModel.updateList(updatedList)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    @Previewable @State var sampleList = ShoppingList(
        title: "Weekly Groceries",
        createdDate: Date(),
        items: [
            ShoppingItem(name: "Tomato", category: "Vegetables"),
            ShoppingItem(name: "Milk", category: "Dairy")
        ]
    )
    
    let sampleViewModel = ShoppingListViewModel()
    
    return AddItemView(
        existingItems: sampleList.items,
        categoryData: [
            "Vegetables": [
                CategoryItem(name: "Carrot"),
                CategoryItem(name: "Broccoli"),
                CategoryItem(name: "Spinach")
            ],
            "Dairy": [
                CategoryItem(name: "Milk"),
                CategoryItem(name: "Cheese")
            ]
        ],
        viewModel: sampleViewModel,
        list: $sampleList
    )
}

