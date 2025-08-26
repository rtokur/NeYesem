//
//  CategorySelectionView.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 26.08.2025.
//

import SwiftUI

struct CategorySelectionView: View {
    let categories: [String]
    @Binding var selectedCategory: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Category")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        CategoryButton(
                            title: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, 0)
            }
            .frame(height: 50)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

#Preview {
    @Previewable @State var selected = "Vegetables"
    
    return CategorySelectionView(
        categories: ["Vegetables", "Dairy", "Meat", "Bakery"],
        selectedCategory: $selected
    )
}
