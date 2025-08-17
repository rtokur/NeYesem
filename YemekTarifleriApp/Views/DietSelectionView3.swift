//
//  DietSelectionView3.swift
//  YemekTarifleriApp
//
//  Created by neodiyadin on 14.08.2025.
//

import SwiftUI

struct DietSelectionView3: View {
    
    @State private var dontlikeItems: [String] = ["Domates", "Peynir", "Yumurta", "Fıstık", "Kakao", "Biber"]
    @State private var selectedItems3: Set<String> = []
    @State private var searchText3: String = ""
    
    let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Button(action: {
                        // Geri gitme aksiyonu
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    
                    ProgressView(value: 3, total: 3)
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    
                    Text("3/3")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                
                // Başlık
                Text("Sevmediğiniz ürünleri ekleyin")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                Text("Lorem ipsum dolor sit amet consectetur. Vitae tempus ut semper augue adipiscing aliquet.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(dontlikeItems, id: \.self) { item in
                        Button(action: {
                            if selectedItems3.contains(item) {
                                selectedItems3.remove(item)
                            } else {
                                selectedItems3.insert(item)
                            }
                        }) {
                            Text(item)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedItems3.contains(item) ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                                        .background(selectedItems3.contains(item) ? Color.red.opacity(0.1) : Color.white)
                                )
                                .foregroundColor(selectedItems3.contains(item) ? .red : .black)
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Arama kutusu
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Ürün ekle", text: $searchText3)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)
                
                Spacer()
                
                // Alt butonlar
                HStack {
                    
                    Button(action: {
                        print("Başla butonuna tıklandı")
                        // Burada ana ekrana yönlendirme yapılabilir
                    }) {
                        Text("Başla")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(red: 41/255, green: 128/255, blue: 158/255))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                    }
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DietSelectionView3()
}
