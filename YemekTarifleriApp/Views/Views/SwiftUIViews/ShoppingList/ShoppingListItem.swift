//
//  ShoppingListItem.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 26.08.2025.
//

import SwiftUI

struct ShoppingListItem: View {
    let list: ShoppingList
    
    private var relativeDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: list.createdDate, relativeTo: Date())
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(list.title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(relativeDate)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                Text(list.progressString)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.system(size: 14, weight: .medium))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
    }
}

#Preview {
    let sampleList = ShoppingList(
        title: "Weekly Groceries",
        createdDate: Date().addingTimeInterval(-3600),
        items: [
            ShoppingItem(name: "Tomato", category: "Vegetables"),
            ShoppingItem(name: "Milk", category: "Dairy", isCompleted: true),
            ShoppingItem(name: "Bread", category: "Bakery")
        ]
    )
    
    return ShoppingListItem(list: sampleList)
}

