//
//  UserModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

import Foundation

struct UserModel {
    let uid: String
    let displayName: String
    let email: String
    
    init?(dictionary: [String: Any], uid: String) {
        guard let displayName = dictionary["displayName"] as? String,
              let email = dictionary["email"] as? String else {
            return nil
        }
        self.uid = uid
        self.displayName = displayName
        self.email = email
    }
}
