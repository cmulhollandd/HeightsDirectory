//
//  Faculty.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 2/9/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import Foundation

class Faculty {
    let firstName: String
    let lastName: String
    let degrees: String
    let title: String
    let phone: String
    let email: String
    let bio: String
    let yearsAtHeights: Int
    
    init(first: String, last: String, degrees: String, title: String, phone: String, email: String, bio: String, years: Int) {
        self.firstName = first
        self.lastName = last
        self.degrees = degrees
        self.title = title
        self.phone = phone
        self.email = email
        self.bio = bio
        self.yearsAtHeights = years
    }
}
