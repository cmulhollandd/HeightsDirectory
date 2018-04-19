//
//  Student+CoreDataProperties.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 4/13/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var lastName: String?
    @NSManaged public var firstName: String?
    @NSManaged public var birthDate: NSDate?
    @NSManaged public var grade: Int32
    @NSManaged public var zipCode: Int32
    @NSManaged public var age: Int32
    @NSManaged public var homePhone: String?
    @NSManaged public var motherName: String?
    @NSManaged public var fatherName: String?
    @NSManaged public var fatherPhone: String?
    @NSManaged public var fatherEmail: String?
    @NSManaged public var motherEmail: String?
    @NSManaged public var motherPhone: String?
    @NSManaged public var streetAddress: String?
    @NSManaged public var cityAddress: String?

}
