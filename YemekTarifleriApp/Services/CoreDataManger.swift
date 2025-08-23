//
//  CoreDataManger.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 31.07.2025.
//

import UIKit
import CoreData

final class CoreDataManager {
    //MARK: - Properties
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
            print("Core Data could not be saved: \(error.localizedDescription)")
        }
    }
    
    // MARK: - User Profile Management
    func saveUserProfile(uid: String, email: String, name: String, surname: String, photoURL: String) {
        let profile = UserProfile(context: context)
        profile.uid = uid
        profile.email = email
        profile.name = name
        profile.surname = surname
        profile.photoURL = photoURL
        
        do {
            try context.save()
        } catch {
            print("Error saving user profile: \(error.localizedDescription)")
        }
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
