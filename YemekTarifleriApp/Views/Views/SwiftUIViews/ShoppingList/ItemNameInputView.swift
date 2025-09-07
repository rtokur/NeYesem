//
//  ItemNameInputView.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 26.08.2025.
//

import SwiftUI

struct ItemNameInputView: View {
    @Binding var itemName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Item Name")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            TextField("Enter item name", text: $itemName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

#Preview {
    @Previewable @State var sampleName = "Tomato"
    
    return ItemNameInputView(itemName: $sampleName)
}

