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
                
                Image("eat")
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 16, height: 16)
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 16, height: 16)
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 16, height: 16)
                }
                .padding(.bottom, 20)
                
                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 215/255, green: 94/255, blue: 83/255))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 1)
                
                
                Text("No more thinking “What should I eat today?” Find the best recipes for your style, taste, and ingredients on hand.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 1)
                
                Spacer()
                
                Button(action: {
                    print("Başla butonuna tıklandı")
                    self.showLogin = true
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
                .padding(.bottom, 20)
                
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    Button("Log in") {
                        print("devam Yap butonuna tıklandı")
                        self.showLogin = true
                    }
                    .foregroundColor(Color(red: 38/255, green: 81/255, blue: 100/255))
                    .fullScreenCover(isPresented: $showLogin) {
                        LoginRegisterWrapper()
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
