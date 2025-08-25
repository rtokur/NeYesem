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
    var name: String?
    var surname: String?
    var email: String?
    var phone: String?
    var photoURL: String?
    
    var diet: String?
    var allergies: [String]
    var dislikes: [String]

    init?(dictionary: [String: Any], uid: String) {
        self.uid = uid
        self.name = dictionary["name"] as? String
        self.surname = dictionary["surname"] as? String
        self.email = dictionary["email"] as? String
        self.phone = dictionary["phone"] as? String
        self.photoURL = dictionary["photoURL"] as? String

        if let preferences = dictionary["preferences"] as? [String: Any] {
            self.diet = preferences["diet"] as? String
            self.allergies = preferences["allergies"] as? [String] ?? []
            self.dislikes = preferences["dislikes"] as? [String] ?? []
        } else {
            self.diet = nil
            self.allergies = []
            self.dislikes = []
        }
    }

    var asFirestore: [String: Any] {
        [
            "uid": uid,
            "name": name ?? "",
            "surname": surname ?? "",
            "email": email ?? "",
            "phone": phone ?? "",
            "photoURL": photoURL ?? "",
            "preferences": [
                "diet": diet ?? "",
                "allergies": allergies,
                "dislikes": dislikes
            ]
        ]
    }
}


