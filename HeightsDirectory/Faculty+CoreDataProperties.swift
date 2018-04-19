//
//  Faculty+CoreDataProperties.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 4/13/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//
//

import Foundation
import CoreData


extension Faculty {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Faculty> {
        return NSFetchRequest<Faculty>(entityName: "Faculty")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var degrees: String?
    @NSManaged public var title: String?
    @NSManaged public var phone: String?
    @NSManaged public var email: String?
    @NSManaged public var bio: String?
    @NSManaged public var yearsAtHeights: Int32

}
