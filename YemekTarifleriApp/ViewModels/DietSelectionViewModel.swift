//
//  DietSelectionViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 21.08.2025.
//

import Foundation

class DietSelectionViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedOption: DietOption? = nil
    @Published var allergies: Set<String> = []
    @Published var dislikes: Set<String> = []
    
    // MARK: - Dependencies
    private let userService: UserServiceProtocol
    
    // MARK: - Initialization
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    // MARK: - Public Methods
    func savePreferences(completion: @escaping (Result<Void, Error>) -> Void) {
        let diet = selectedOption?.title
        let allergiesArray = Array(allergies)
        let dislikesArray = Array(dislikes)
        
        savePreferences(diet: diet, allergies: allergiesArray, dislikes: dislikesArray, completion: completion)
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
