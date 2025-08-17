//
//  DietSelectionView1.swift
//  YemekTarifleriApp
//
//  Created by neodiyadin on 13.08.2025.
//

import SwiftUI

struct DietOption: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct DietSelectionView1: View {
    
    let options: [DietOption] = [
        DietOption(title: "Klasik", imageName: "klasik"),
        DietOption(title: "Şekersiz", imageName: "sekersiz"),
        DietOption(title: "Vejeteryan", imageName: "vejeteryan"),
        DietOption(title: "Vegan", imageName: "vegan"),
        DietOption(title: "Ketojenik", imageName: "ketojenik")
    ]
    
    @State private var selectedOption: UUID?
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Button(action: {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let nav = windowScene.windows.first?.rootViewController as? UINavigationController {
                            nav.popViewController(animated: true)
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    
                    ProgressView(value: 1, total: 3)
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                    
                    Text("1/3")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                Text("Beslenme Tarzınızı Seçin")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                Text("Lorem ipsum dolor sit amet consectetur. Vitae tempus ut semper augue adipiscing aliquet.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(options) { option in
                        Button(action: {
                            selectedOption = option.id
                        }) {
                            HStack(spacing: 8) {
                                Image(option.imageName) // Senin görsellerin buraya gelecek
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 64, height: 64)
                                    .clipShape(Circle())
                                
                                Text(option.title)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .lineLimit(1) // Metnin tek satırda kalmasını sağlar
                                    .minimumScaleFactor(0.5) // Metin sığmazsa boyutunu %50'ye kadar küçültür
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedOption == option.id ? Color.blue : Color.gray.opacity(0.2), lineWidth: 2)
                            )
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
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
                    
                    NavigationLink(destination: DietSelectionView2()) {
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
    DietSelectionView1()
}

// MARK: - UIKit Wrapper
import UIKit

class DietSelectionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUIView()
    }
    
    private func setupSwiftUIView() {
        let dietSelectionView = DietSelectionView1()
        let hostingController = UIHostingController(rootView: dietSelectionView)
        
        // Add the hosting controller as a child
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        // Setup constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
