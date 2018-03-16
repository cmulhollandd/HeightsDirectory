//
//  StudentStore.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 2/1/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import Foundation
import UIKit

enum StudentSortOptions {
    case alphabet
    case grade
    case ageHigh
    case ageLow
}

enum StudentRefineOptions {
    case grade(Int)
    case zip(Int)
    case none
}

class StudentStore: NSObject, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell", for: indexPath) as! StudentTableViewCell
        
        let currentStudent = shownStudents[indexPath.row]
        cell.nameLabel.text = "\(currentStudent.firstName) \(currentStudent.lastName)"
        if currentStudent.grade > 3 {
            cell.gradeLabel.text = "\(currentStudent.grade)th grade"
        } else {
            cell.gradeLabel.text = "\(currentStudent.grade)rd grade"
        }
        
        return cell
    }
    
    // MARK: - Variables
    var allStudents = [Student]()
    var shownStudents = [Student]()
    var currentRefinement = StudentRefineOptions.none
    var currentSortment = StudentSortOptions.grade
    
    // MARK: - Functions
    func addStudent(first: String, last: String, birth: String, grade: Int, zip: Int,home: String, motherName: String, fatherName: String, fatherPhone: String?, fatherEmail: String?, motherEmail: String?, motherPhone: String?, street: String, city: String) {
        
        let newStudent = Student(last: last, first: first, birthDate: birth, grade: grade, zip: zip, homePhone: home, motherName: motherName, fatherName: fatherName, fatherPhone: fatherPhone, fatherEmail: fatherEmail, motherEmail: motherEmail, motherPhone: motherPhone, streetAddr: street, cityAddr: city)
        
        allStudents.append(newStudent)
        
        // Check to see if the student should be shown
        switch currentRefinement {
        case .grade(let gradeNum):
            if newStudent.grade == gradeNum {
                shownStudents.append(newStudent)
                return
            }
        case .zip(let zipCode):
            if newStudent.zipCode == zipCode {
                shownStudents.append(newStudent)
                return
            }
        case .none:
            shownStudents.append(newStudent)
        }
        
        sortList(by: currentSortment)
    
    }
    
    func addStudent(from json: Dictionary<String, Any>) {
        let newStudent = Student(from: json)
        
        allStudents.append(newStudent)
        
        // Check to see if the student should be shown
        switch currentRefinement {
        case .grade(let gradeNum):
            if newStudent.grade == gradeNum {
                shownStudents.append(newStudent)
                return
            }
        case .zip(let zipCode):
            if newStudent.zipCode == zipCode {
                shownStudents.append(newStudent)
                return
            }
        case .none:
            shownStudents.append(newStudent)
        }
        
        sortList(by: currentSortment)
        
    }
    
    // Sort students by a SortOption
    func sortList(by format: StudentSortOptions) {
        switch format {
        case .alphabet:
            shownStudents = allStudents.sorted {
                if $0.lastName == $1.lastName {
                    return $0.firstName < $1.firstName
                }
                return $0.lastName < $1.lastName
            }
        case .grade:
            shownStudents = allStudents.sorted {
                $0.grade < $1.grade
            }
        case .ageHigh:
            shownStudents = allStudents.sorted {
                $0.age > $1.age
            }
        case .ageLow:
            shownStudents = allStudents.sorted {
                $0.age < $1.age
            }
        }
    }
    
    func search(for name: String) {
        shownStudents.removeAll()
        for student in allStudents {
            if student.firstName.contains(name) || student.lastName.contains(name) || (student.firstName + " " + student.lastName).contains(name) {
                shownStudents.append(student)
            }
        }
    }
    
    func loadAll() {
        shownStudents = allStudents
    }
}
