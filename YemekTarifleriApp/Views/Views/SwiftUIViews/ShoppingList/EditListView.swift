//
//  EditListView.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 26.08.2025.
//

import SwiftUI

struct EditListView: View {
    @Binding var list: ShoppingList
    @ObservedObject var viewModel: ShoppingListViewModel
    @State private var showingAddItem = false
    
    var body: some View {
        VStack {
            List {
                ForEach($list.items) { $item in
                    ListItemRow(item: $item, viewModel: viewModel, list: $list)
                }
                .onDelete { indexSet in
                    let itemsToDelete = indexSet.map { list.items[$0] }
                    list.items.removeAll { item in
                        itemsToDelete.contains { $0.id == item.id }
                    }
                    viewModel.updateList(list)
                }
            }
            .listStyle(.plain)
            
            Button("Add Item") {
                showingAddItem = true
            }
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .medium))
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(RoundedRectangle(cornerRadius: 25).fill(Color(red: 0.4, green: 0.6, blue: 0.7)))
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .navigationTitle(list.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddItem) {
            AddItemView(
                existingItems: list.items,
                categoryData: viewModel.categoryData,
                viewModel: viewModel,
                list: $list
            )
        }
    }
}

#Preview {
    @Previewable @State var sampleList = ShoppingList(
        title: "Weekly Groceries",
        createdDate: Date(),
        items: [
            ShoppingItem(name: "Tomato", category: "Vegetables"),
            ShoppingItem(name: "Milk", category: "Dairy", isCompleted: true),
            ShoppingItem(name: "Bread", category: "Bakery")
        ]
    )
    
    let sampleViewModel = ShoppingListViewModel()
    sampleViewModel.categoryData = [
        "Vegetables": [CategoryItem(name: "Carrot")],
        "Dairy": [CategoryItem(name: "Cheese")],
        "Bakery": [CategoryItem(name: "Bread")]
    ]
    
    return NavigationView {
        EditListView(list: $sampleList, viewModel: sampleViewModel)
    }
}


