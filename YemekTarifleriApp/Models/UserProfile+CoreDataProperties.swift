//
//  UserProfile+CoreDataProperties.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 7.08.2025.
//
//

import Foundation
import CoreData

extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var uid: String?
    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var photoURL: String?
}

extension UserProfile : Identifiable {

}
