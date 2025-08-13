//
//  CoreDataManger.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 31.07.2025.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: - Save Context
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Core Data kaydedilemedi: \(error.localizedDescription)")
        }
    }
    
    func saveUserProfile(uid: String, email: String, username: String, photoURL: String) {
        let entity = UserProfile(context: context)
        entity.uid = uid
        entity.email = email
        entity.username = username
        entity.photoURL = photoURL
        
        saveContext()
    }
    
    func fetchUserProfile() -> UserProfile? {
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        return try? context.fetch(request).first
    }
    
    func deleteUserProfile() {
        if let profile = fetchUserProfile() {
            context.delete(profile)
            saveContext()
        }
    }
}
