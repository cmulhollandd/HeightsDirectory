//
//  FacultyStore.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 2/9/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import Foundation
import UIKit

class FacultyStore: NSObject, UITableViewDataSource {

    var allFaculty = [Faculty]()
    var shownFaculty = [Faculty]()
    
    func addFaculty(first: String, last: String, title: String, degrees: String, phone: String, email: String, bio: String, years: Int) {
        let newFac = Faculty(first: first, last: last, degrees: degrees, title: title, phone: phone, email: email, bio: bio, years: years)
        
        allFaculty.append(newFac)
        shownFaculty.append(newFac)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownFaculty.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FacultyTableViewCell", for: indexPath) as! FacultyTableViewCell
        let currentFac = shownFaculty[indexPath.row]
        cell.nameLabel.text = "\(currentFac.firstName) \(currentFac.lastName)"
        
        return cell
    }
    
    
    
    func search(for name: String) {
        shownFaculty.removeAll()
        for fac in allFaculty {
            if fac.firstName.contains(name) || fac.lastName.contains(name) {
                shownFaculty.append(fac)
            }
        }
    }
    
    func loadAll() {
        shownFaculty = allFaculty
    }
}
