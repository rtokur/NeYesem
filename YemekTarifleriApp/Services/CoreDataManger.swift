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
}
