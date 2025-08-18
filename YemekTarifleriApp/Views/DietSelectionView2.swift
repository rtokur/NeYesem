//
//  DietSelectionView3.swift
//  YemekTarifleriApp
//
//  Created by neodiyadin on 13.08.2025.
//

import SwiftUI

struct DietSelectionView2: View {
    
    @State private var allergyItems: [String] = ["Domates", "Peynir", "Yumurta", "Fıstık", "Kakao", "Biber"]
    @State private var selectedItems: Set<String> = []
    @State private var searchText: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.backward")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    
                    ProgressView(value: 2, total: 3)
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    
                    Text("2/3")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                // Başlık
                Text("Alerjiniz olan ürünleri ekleyin")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                Text("Lorem ipsum dolor sit amet consectetur. Vitae tempus ut semper augue adipiscing aliquet.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(allergyItems, id: \.self) { item in
                        Button(action: {
                            if selectedItems.contains(item) {
                                selectedItems.remove(item)
                            } else {
                                selectedItems.insert(item)
                            }
                        }) {
                            Text(item)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(selectedItems.contains(item) ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                                        .background(selectedItems.contains(item) ? Color.red.opacity(0.1) : Color.white)
                                )
                                .foregroundColor(selectedItems.contains(item) ? .red : .black)
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Arama kutusu
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Ürün ekle", text: $searchText)
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
                    Button("Geç") {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            
                            let mainTabBar = MainTabBarController()
                            
                            window.rootViewController = mainTabBar
                            window.makeKeyAndVisible()
                        }
                    }
                    .foregroundColor(.gray)
                    
                    Spacer()
                    
                    NavigationLink(destination: DietSelectionView3()) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                            .frame(width: 80, height: 50)
                            .background(Color(red: 41/255, green: 128/255, blue: 158/255))
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DietSelectionView2()
}



