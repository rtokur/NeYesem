//
//  welcome3.swift
//  YemekTarifleriApp
//
//  Created by neodiyadin on 11.08.2025.
//

import SwiftUI

struct welcome3: View {
    
    @State private var showLogin = false
    
    var body: some View {
            VStack {
                Spacer()
                
                Image("eat") // Resmin adı Assets'e eklediğin isim olmalı
                
                Text("Hoşgeldin!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 215/255, green: 94/255, blue: 83/255))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 1)
                
                
                Text("Bugün ne yesem diye düşünme! Tarzına, damak zevkine ve dolabına göre en uygun tarifler burada.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .padding(.top, 1)
                
                Spacer()
                
                Button(action: {
                    print("Başla butonuna tıklandı")
                    // Burada ana ekrana yönlendirme yapılabilir
                    self.showLogin = true
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
                
                
                HStack {
                    Text("Zaten hesabın var mı?")
                        .foregroundColor(.gray)
                    Button("Giriş yap") {
                        print("devam Yap butonuna tıklandı")
                        // Login ekranına yönlendirme yapılabilir
                        self.showLogin = true
                    }
                    .foregroundColor(Color(red: 38/255, green: 81/255, blue: 100/255))
                    .fullScreenCover(isPresented: $showLogin) {
                        LoginRegisterWrapper() // SwiftUI içinde UIKit ekranı
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 40)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
        }
        
}

#Preview {
    welcome3()
}
