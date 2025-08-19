//
//  MainTabBarViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 19.08.2025.
//

import Foundation

final class MainTabBarViewModel: ObservableObject {
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func savePreferences(diet: String?, allergies: [String], dislikes: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        userService.saveUserPreferences(
            diet: diet,
            allergies: allergies,
            dislikes: dislikes,
            completion: completion
        )
    }
}
