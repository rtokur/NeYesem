//
//  ListItemRow.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 26.08.2025.
//

import SwiftUI

struct ListItemRow: View {
    @Binding var item: ShoppingItem
    @ObservedObject var viewModel: ShoppingListViewModel
    @Binding var list: ShoppingList
    
    var body: some View {
        HStack(spacing: 12) {
            // Nokta
            Circle()
                .fill(Color(red: 0.4, green: 0.6, blue: 0.7))
                .frame(width: 8, height: 8)
            
            // Yazı + kategori
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.7))
                    .strikethrough(item.isCompleted)
                
                Text(item.category) 
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Checkbox
            Button(action: {
                item.isCompleted.toggle()
                viewModel.updateList(list)
            }) {
                Image(systemName: item.isCompleted ? "checkmark.square.fill" : "square")
                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.7))
                    .font(.system(size: 20))
            }
        }
        .contentShape(Rectangle())
    }
}

//#Preview {
//    @Previewable @State var sampleItem = ShoppingItem(
//        name: "Tomato",
//        category: "Vegetables",
//        isCompleted: false
//    )
//    
//    return ListItemRow(item: $sampleItem)
//        .padding()
//}
