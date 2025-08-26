//
//  welcome2.swift
//  YemekTarifleriApp
//
//  Created by neodiyadin on 11.08.2025.
//

import SwiftUI
import UIKit



struct welcome2: View {
    
    @State private var showLogin = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("choose")

            HStack(spacing: 8) {
                Circle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 16, height: 16)
                Circle()
                    .fill(Color.blue)
                    .frame(width: 16, height: 16)
                Circle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 16, height: 16)
            }
            .padding(.bottom, 20)
            
            Text("Today’s Recipe is Ready!")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 20)
            
            Text("Stop wondering “What should I cook today?” Get recipes tailored to your fridge and see what’s missing from your pantry.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 10)
            
            Spacer()
            
            
            
            HStack {
                Button("Skip") {
                    showLogin = true
                }
                .foregroundColor(.gray)
                .fullScreenCover(isPresented: $showLogin) {
                    LoginRegisterWrapper() 
                }
                
                Spacer()
                
                NavigationLink(destination: welcome3()) {
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
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    welcome2()
}
