//
//  CategoryButton.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 26.08.2025.
//

import SwiftUI

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color(UIColor.secondaryColor).opacity(0.2) : Color.gray.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isSelected ? Color(UIColor.secondaryColor) : Color.clear, lineWidth: 2)
                        )
                )
                .foregroundColor(isSelected ? Color(UIColor.secondaryColor) : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        CategoryButton(
            title: "Vegetables",
            isSelected: true,
            action: { print("Vegetables tapped") }
        )
        
        CategoryButton(
            title: "Dairy",
            isSelected: false,
            action: { print("Dairy tapped") }
        )
    }
    .padding()
}

