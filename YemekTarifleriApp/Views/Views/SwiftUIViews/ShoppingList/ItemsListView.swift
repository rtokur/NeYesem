//
//  ItemsListView.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 26.08.2025.
//

import SwiftUI

struct ItemsListView: View {
    @Binding var items: [ShoppingItem]
    
    var body: some View {
        if !items.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Items in List")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.top, 12)
                
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(items) { item in
                        HStack {
                            Text(item.name)
                                .font(.system(size: 14))
                            Spacer()
                            Text(item.category)
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                            
                            Button(action: {
                                items.removeAll { $0.id == item.id }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.red)
                                    .font(.system(size: 12))
                            }
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1))
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    @Previewable @State var sampleItems: [ShoppingItem] = [
        ShoppingItem(name: "Tomato", category: "Vegetables"),
        ShoppingItem(name: "Milk", category: "Dairy"),
        ShoppingItem(name: "Bread", category: "Bakery", isCompleted: true)
    ]
    
    return ItemsListView(items: $sampleItems)
}

