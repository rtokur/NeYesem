//
//  NewListView.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 26.08.2025.
//

import SwiftUICore
import SwiftUI

struct NewListView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ShoppingListViewModel
    @State private var listName = ""
    @State private var items: [ShoppingItem] = []
    @State private var newItemName = ""
    @State private var selectedCategory: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack {
                    ListNameInputView(listName: $listName)
                    
                    CategorySelectionView(
                        categories: Array(viewModel.categoryData.keys),
                        selectedCategory: $selectedCategory
                    )
                    
                    // Custom input
                    HStack {
                        TextField("Enter custom item name", text: $newItemName)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5)))
                        
                        Button(action: addCustomItem) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color(UIColor.secondaryColor))
                                .clipShape(Circle())
                        }
                        .disabled(newItemName.isEmpty || selectedCategory.isEmpty)
                    }
                    .padding(.horizontal, 20)
                    
                    SuggestionsView(
                        suggestions: availableSuggestions(),
                        onSelect: addSuggestion
                    )
                    
                    ItemsListView(items: $items)
                }
            }
            
            // Save button
            Button(action: saveList) {
                Text("Create List")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(UIColor.primaryColor)))
            }
            .disabled(listName.isEmpty || items.isEmpty)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .navigationTitle("Create New List")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func availableSuggestions() -> [String] {
        guard let categoryItems = viewModel.categoryData[selectedCategory] else { return [] }
        let existingItemNames = Set(items.map { $0.name.lowercased() })
        return categoryItems.map { $0.name }
            .filter { !existingItemNames.contains($0.lowercased()) }
    }
    
    private func addCustomItem() {
        let trimmedName = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty, !selectedCategory.isEmpty else { return }
        
        let newItem = ShoppingItem(name: trimmedName, category: selectedCategory)
        items.insert(newItem, at: 0)
        newItemName = ""
    }
    
    private func addSuggestion(_ suggestion: String) {
        let newItem = ShoppingItem(name: suggestion, category: selectedCategory)
        items.insert(newItem, at: 0)
    }
    
    private func saveList() {
        let newList = ShoppingList(title: listName, createdDate: Date(), items: items)
        viewModel.addList(newList)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let sampleViewModel = ShoppingListViewModel()
    sampleViewModel.categoryData = [
        "Vegetables": [
            CategoryItem(name: "Tomato"),
            CategoryItem(name: "Carrot")
        ],
        "Dairy": [
            CategoryItem(name: "Milk"),
            CategoryItem(name: "Cheese")
        ]
    ]
    
    return NavigationView {
        NewListView(viewModel: sampleViewModel)
    }
}

