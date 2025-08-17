//
//  welcome1.swift
//  YemekTarifleriApp
//
//  Created by neodiyadin on 11.08.2025.
//
/*
import SwiftUI

struct welcome1: View {
    
    @State private var showLogin = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image("dream") // Assets.xcassets içine ekle
                
                // Boncuk Indicators (ilk sayfa aktif)
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 16, height: 16)
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 16, height: 16)
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 16, height: 16)
                }
                .padding(.bottom, 20)
                
                Text("Evdeki Malzemelerle Neler Yapabilirim?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                Text("Dolabındaki malzemeleri gir, onlara özel tarif önerileri al")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                Spacer()
                
                HStack {
                    Button("Geç") {
                        print("Geç butonuna tıklandı")
                        // İstersen burada son ekrana yönlendirebiliriz.
                    }
                    .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // NavigationLink BUTON gibi davranacak
                    NavigationLink(destination: welcome2()) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                            .frame(width: 80, height: 50)
                            .background(Color(red: 41/255, green: 128/255, blue: 158/255))
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    welcome1()
}


*/







import SwiftUI
import UIKit

// UIKit ekranını SwiftUI'da kullanabilmek için wrapper
struct LoginRegisterWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LoginRegisterViewController {
        return LoginRegisterViewController()
    }
    
    func updateUIViewController(_ uiViewController: LoginRegisterViewController, context: Context) {
        // Gerekirse güncelleme yapılır
    }
}

struct welcome1: View {
    
    @State private var showLogin = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image("dream") // Assets.xcassets içine ekle
                
                // Boncuk Indicators (ilk sayfa aktif)
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 16, height: 16)
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 16, height: 16)
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 16, height: 16)
                }
                .padding(.bottom, 20)
                
                Text("Evdeki Malzemelerle Neler Yapabilirim?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                Text("Dolabındaki malzemeleri gir, onlara özel tarif önerileri al")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                Spacer()
                
                HStack {
                    Button("Geç") {
                        showLogin = true
                    }
                    .foregroundColor(.gray)
                    .fullScreenCover(isPresented: $showLogin) {
                        LoginRegisterWrapper() // SwiftUI içinde UIKit ekranı
                    }
                    
                    Spacer()
                    
                    // NavigationLink BUTON gibi davranacak
                    NavigationLink(destination: welcome2()) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                            .frame(width: 80, height: 50)
                            .background(Color(red: 41/255, green: 128/255, blue: 158/255))
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    welcome1()
}
