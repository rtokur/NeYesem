//
//  DietSelectionView1.swift
//  YemekTarifleriApp
//
//  Created by neodiyadin on 13.08.2025.
//

import SwiftUI

import Foundation

class DietSelectionViewModel: ObservableObject {
    @Published var selectedOption: DietOption? = nil
    @Published var allergies: Set<String> = []
    @Published var dislikes: Set<String> = []
    
    init(selectedOption: DietOption? = nil,
         allergies: Set<String> = [],
         dislikes: Set<String> = []) {
        self.selectedOption = selectedOption
        self.allergies = allergies
        self.dislikes = dislikes
    }
}

struct DietOption: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct DietSelectionView1: View {
    
    @ObservedObject var viewModel: DietSelectionViewModel
    
    let options: [DietOption] = [
        DietOption(title: "Classic", imageName: "klasik"),
        DietOption(title: "Pescetarian", imageName: "pescetarian"),
        DietOption(title: "Vegetarian", imageName: "vejeteryan"),
        DietOption(title: "Vegan", imageName: "vegan"),
        DietOption(title: "Ketogenic", imageName: "ketojenik"),
        DietOption(title: "Gluten free", imageName: "glutenfree")
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // progress header
                HStack {
                    Button(action: {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let nav = windowScene.windows.first?.rootViewController as? UINavigationController {
                            nav.popViewController(animated: true)
                        }
                    }) {
                        Image(systemName: "arrow.backward")
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
                .padding(.bottom, 20)
                
                Text("Beslenme Tarzınızı Seçin")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                
                Text("Lorem ipsum dolor sit amet consectetur. Vitae tempus ut semper augue adipiscing aliquet.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(options) { option in
                        Button(action: {
                            viewModel.selectedOption = option
                        }) {
                            HStack(spacing: 8) {
                                Image(option.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 64, height: 64)
                                    .clipShape(Circle())
                                
                                Text(option.title)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(viewModel.selectedOption == option ? Color.blue : Color.gray.opacity(0.2), lineWidth: 2)
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
                            mainTabBar.selectedDiet = viewModel.selectedOption?.title
                            window.rootViewController = mainTabBar
                            window.makeKeyAndVisible()
                        }
                    }
                    .foregroundColor(.gray)
                    
                    Spacer()
                    
                    NavigationLink(destination: DietSelectionView2(viewModel: viewModel)) {
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
    DietSelectionView1(viewModel: DietSelectionViewModel())
}

class DietSelectionViewController: UIViewController {
    
    private let viewModel = DietSelectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUIView()
    }
    
    private func setupSwiftUIView() {
        let dietSelectionView = DietSelectionView1(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: dietSelectionView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
