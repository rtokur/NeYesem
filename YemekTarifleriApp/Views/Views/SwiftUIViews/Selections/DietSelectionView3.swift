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
            
            Text("Add ingredients you don’t like")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            Text("Lorem ipsum dolor sit amet consectetur. Vitae tempus ut semper augue adipiscing aliquet.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.bottom, 20)
            
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
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Add Ingredient", text: $searchText3, onCommit: {
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
            
            Button(action: {
                print("Selected Diet:", viewModel.selectedOption?.title ?? "nil")
                print("Selected Allergies:", viewModel.allergies)
                print("Selected Dislikes:", viewModel.dislikes)
                viewModel.savePreferences { result in
                        switch result {
                        case .success:
                            print("✅ Preferences saved")

                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first {
                                
                                let mainTabBar = MainTabBarController()
                                
                                window.rootViewController = mainTabBar
                                window.makeKeyAndVisible()
                            }
                            
                        case .failure(let error):
                            print("❌ Save failed: \(error.localizedDescription)")
                        }
                    }
            }) {
                Text("Get Started")
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
