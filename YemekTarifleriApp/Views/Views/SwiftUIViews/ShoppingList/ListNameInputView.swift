//
//  ListNameInputView.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 26.08.2025.
//

import SwiftUI

struct ListNameInputView: View {
    @Binding var listName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("List Name")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            TextField("Shopping List", text: $listName)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10).fill(Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

#Preview {
    @Previewable @State var sampleName = "Weekly Groceries"
    
    return ListNameInputView(listName: $sampleName)
        .padding()
}

