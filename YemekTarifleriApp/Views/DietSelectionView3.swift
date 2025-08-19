//
//  DietSelectionView3.swift
//  YemekTarifleriApp
//
//  Created by neodiyadin on 14.08.2025.
//

import SwiftUI

struct DietSelectionView3: View {
    @ObservedObject var viewModel: DietSelectionViewModel
    
    @State private var dontlikeItems: [String] = ["Tomato", "Cheese", "Egg", "Pistachio", "Sugar", "Pepper"]
    @State private var searchText3: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.backward")
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
            .padding(.bottom, 20)
            
            // Başlık
            Text("Sevmediğiniz ürünleri ekleyin")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            Text("Lorem ipsum dolor sit amet consectetur. Vitae tempus ut semper augue adipiscing aliquet.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.bottom, 20)
            
            // Grid
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
                ForEach(dontlikeItems, id: \.self) { item in
                    Button(action: {
                        if viewModel.dislikes.contains(item) {
                            viewModel.dislikes.remove(item)
                        } else {
                            viewModel.dislikes.insert(item)
                        }
                    }) {
                        Text(item)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(viewModel.dislikes.contains(item) ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                                    .background(viewModel.dislikes.contains(item) ? Color.red.opacity(0.1) : Color.white)
                            )
                            .foregroundColor(viewModel.dislikes.contains(item) ? .red : .black)
                            .font(.subheadline)
                    }
                }
            }
            .padding(.horizontal)
            
            // Arama kutusu
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Ürün ekle", text: $searchText3, onCommit: {
                    if !searchText3.isEmpty {
                        viewModel.dislikes.insert(searchText3)
                        if !dontlikeItems.contains(searchText3) {
                            dontlikeItems.append(searchText3)
                        }
                        searchText3 = ""
                    }
                })
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal)
            
            Spacer()
            
            // Alt buton - Bitir
            Button(action: {
                print("Selected Diet:", viewModel.selectedOption?.title ?? "nil")
                print("Selected Allergies:", viewModel.allergies)
                print("Selected Dislikes:", viewModel.dislikes)
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    
                    let mainTabBar = MainTabBarController()
                    mainTabBar.selectedDiet = viewModel.selectedOption?.title
                    mainTabBar.selectedAllergies = Array(viewModel.allergies)
                    mainTabBar.selectedDislikes = Array(viewModel.dislikes)
                    
                    window.rootViewController = mainTabBar
                    window.makeKeyAndVisible()
                }
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
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    DietSelectionView3(viewModel: DietSelectionViewModel())
}
