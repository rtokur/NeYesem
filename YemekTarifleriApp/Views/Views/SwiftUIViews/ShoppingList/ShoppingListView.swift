//
//  zzzzzzzz.swift
//  shoppingLists
//
//  Created by neodiyadin on 24.08.2025.
//

import SwiftUI

struct ShoppingListView: View {
    @StateObject private var viewModel = ShoppingListViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                // New List Button
                NavigationLink(destination: NewListView(viewModel: viewModel)) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Create New List")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(UIColor.primaryColor))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding()
                }
                
                // List Items
                if viewModel.shoppingLists.isEmpty {
                    Text("No shopping lists yet")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach($viewModel.shoppingLists) { $list in
                            ZStack {
                                ShoppingListItem(list: list)
                                NavigationLink(destination: EditListView(list: $list, viewModel: viewModel)) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                            .listRowSeparator(.hidden)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let listToDelete = viewModel.shoppingLists[index]
                                viewModel.deleteList(listToDelete)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                Spacer()
            }
            .navigationTitle("My Shopping Lists")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left") // ok ikonu
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Color(UIColor.Color10))
                    }
                }
            }

        }
    }
    
    private func binding(for list: ShoppingList) -> Binding<ShoppingList> {
        guard let index = viewModel.shoppingLists.firstIndex(where: { $0.id == list.id }) else {
            fatalError("List not found")
        }
        return $viewModel.shoppingLists[index]
    }
}

#Preview {
    let sampleViewModel = ShoppingListViewModel()
    sampleViewModel.shoppingLists = [
        ShoppingList(
            title: "Weekly Groceries",
            createdDate: Date().addingTimeInterval(-3600),
            items: [
                ShoppingItem(name: "Tomato", category: "Vegetables"),
                ShoppingItem(name: "Milk", category: "Dairy", isCompleted: true),
                ShoppingItem(name: "Bread", category: "Bakery")
            ]
        ),
        ShoppingList(
            title: "Party Supplies",
            createdDate: Date().addingTimeInterval(-86400),
            items: [
                ShoppingItem(name: "Chips", category: "Snacks"),
                ShoppingItem(name: "Soda", category: "Beverages")
            ]
        )
    ]
    
    return ShoppingListView()
        .environmentObject(sampleViewModel)
}



