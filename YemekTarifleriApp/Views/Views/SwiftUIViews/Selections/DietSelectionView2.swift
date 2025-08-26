//
//  DietSelectionView3.swift
//  YemekTarifleriApp
//
//  Created by neodiyadin on 13.08.2025.
//

import SwiftUI

struct DietSelectionView2: View {
    @State private var allergyItems: [String] = ["Tomato", "Cheese", "Egg", "Pistachio", "Sugar", "Pepper"]
    @State private var searchText: String = ""
    @ObservedObject var viewModel: DietSelectionViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HeaderView(presentationMode: presentationMode)
            
            TitleSection()
            
            AllergyGrid(
                items: allergyItems,
                selected: viewModel.allergies
            ) { item in
                if viewModel.allergies.contains(item) {
                    viewModel.allergies.remove(item)
                } else {
                    viewModel.allergies.insert(item)
                }
            }
            .padding(.horizontal)
            
            SearchBar(
                text: $searchText,
                onCommit: {
                    if !searchText.isEmpty {
                        viewModel.allergies.insert(searchText)
                        if !allergyItems.contains(searchText) {
                            allergyItems.append(searchText)
                        }
                        searchText = ""
                    }
                }
            )
            .padding(.horizontal)
            
            Spacer()
            
            FooterButtons(viewModel: viewModel)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct HeaderView: View {
    var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
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
    }
}

struct TitleSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Add ingredients you’re allergic to")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Lorem ipsum dolor sit amet consectetur. Vitae tempus ut semper augue adipiscing aliquet.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
}

struct AllergyGrid: View {
    let items: [String]
    let selected: Set<String>
    let onToggle: (String) -> Void
    
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(items, id: \.self) { item in
                Button(action: { onToggle(item) }) {
                    Text(item)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selected.contains(item) ? Color.red : Color.gray.opacity(0.3), lineWidth: 1)
                                .background(selected.contains(item) ? Color.red.opacity(0.1) : Color.white)
                        )
                        .foregroundColor(selected.contains(item) ? .red : .black)
                        .font(.subheadline)
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var onCommit: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Add Ingredient", text: $text, onCommit: onCommit)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}

struct FooterButtons: View {
    @ObservedObject var viewModel: DietSelectionViewModel
    
    var body: some View {
        HStack {
            Button("Skip") {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    
                    let mainTabBar = MainTabBarController()
                    window.rootViewController = mainTabBar
                    window.makeKeyAndVisible()
                }
            }
            .foregroundColor(.gray)
            
            Spacer()
            
            NavigationLink(destination: DietSelectionView3(viewModel: viewModel)) {
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

#Preview {
    DietSelectionView2(viewModel: DietSelectionViewModel())
}
