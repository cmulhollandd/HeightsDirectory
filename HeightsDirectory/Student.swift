//
//  Student.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 2/1/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import Foundation

class Student {
    let lastName: String
    let firstName: String
    let birthDate: Date
    let grade: Int
    let zipCode: Int
    var age: Int
    let homePhone: String
    let motherName: String
    let fatherName: String
    let fatherPhone: String?
    let fatherEmail: String?
    let motherEmail: String?
    let motherPhone: String?
    let streetAddress: String
    let cityAddress: String
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "mm/dd/yyyy"
        return df
    }()
    
    init(last: String, first: String, birthDate: String, grade: Int, zip: Int, homePhone: String, motherName: String, fatherName: String, fatherPhone: String?, fatherEmail: String?, motherEmail: String?, motherPhone: String?, streetAddr: String, cityAddr: String) {
        self.lastName = last
        self.firstName = first
        self.birthDate = dateFormatter.date(from: birthDate)!
        self.grade = grade
        self.zipCode = zip
        self.homePhone = homePhone
        self.motherName = motherName
        self.fatherName = fatherName
        self.fatherPhone = fatherPhone
        self.fatherEmail = fatherEmail
        self.motherEmail = motherEmail
        self.motherPhone = motherPhone
        self.streetAddress = streetAddr
        self.cityAddress = cityAddr
        
        // Get age of student
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self.birthDate, to: Date())
        self.age = ageComponents.year!
    }
    
    convenience init(from json: Dictionary<String, Any>) {
        let last = json["lastName"] as! String
        let first = json["firstName"] as! String
        let birth = json["birthDate"] as! String
        let grade = json["grade"] as! Int
        let zip = json["zipCode"] as! Int
        let home = json["homePhone"] as! String
        let momName = json["motherName"] as! String
        let dadName = json["fatherName"] as! String
        let dadPhone = json["fatherPhone"] as! String
        let dadEmail = json["fatherEmail"] as! String
        let momPhone = json["motherPhone"] as! String
        let momEmail = json["motherEmail"] as! String
        let street = json["streetAddress"] as! String
        let city = json["cityAddress"] as! String
        
        self.init(last: last, first: first, birthDate: birth, grade: grade, zip: zip, homePhone: home, motherName: momName, fatherName: dadName, fatherPhone: dadPhone, fatherEmail: dadEmail, motherEmail: momEmail, motherPhone: momPhone, streetAddr: street, cityAddr: city)
    }

}
