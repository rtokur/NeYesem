//
//  UserModel.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 5.08.2025.
//

import Foundation
import CoreData

struct UserModel {
    let uid: String
    let displayName: String?
    let email: String?
    let phone: String?
    let photoURL: String?
    
    let diet: String?
    let allergies: [String]
    let dislikes: [String]

    init?(dictionary: [String: Any], uid: String) {
        self.uid = uid
        self.displayName = dictionary["username"] as? String
        self.email = dictionary["email"] as? String
        self.phone = dictionary["phone"] as? String
        self.photoURL = dictionary["photoURL"] as? String
        
        self.diet = dictionary["diet"] as? String
        self.allergies = dictionary["allergies"] as? [String] ?? []
        self.dislikes = dictionary["dislikes"] as? [String] ?? []
    }

    var asFirestore: [String: Any] {
        [
            "username": displayName ?? "",
            "email": email ?? "",
            "phone": phone ?? "",
            "photoURL": photoURL ?? "",
            "diet": diet ?? "",
            "allergies": allergies,
            "dislikes": dislikes
        ]
    }
}

