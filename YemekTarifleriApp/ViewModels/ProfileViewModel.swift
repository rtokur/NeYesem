//
//  ProfileViewModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

final class ProfileViewModel {
    
    private let userService: UserServiceProtocol
    var onUserDataFetched: ((UserModel) -> Void)?
    var onError: ((String) -> Void)?
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func loadUserProfile() {
        userService.fetchCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.onUserDataFetched?(user)
            case .failure(let error):
                self?.onError?(error.localizedDescription)
            }
        }
    }
}
