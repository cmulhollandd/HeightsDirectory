//
//  StudentsViewController.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 1/31/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication

class StudentsViewController: UIViewController, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    // MARK: - Variables
    var studentStore = StudentStore()
    let searchController = UISearchController(searchResultsController: nil)
    let redColor = UIColor(red:0.82, green:0.07, blue:0.11, alpha:1.0)
    let impactController = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - @IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var alphabetButton: UIButton!
    @IBOutlet var gradeButton: UIButton!
    @IBOutlet var ageHighButton: UIButton!
    @IBOutlet var ageLowButton: UIButton!
    @IBOutlet var sortView: UIView!
    @IBOutlet var sortViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Configure tableView
        tableView.delegate = self
        tableView.dataSource = studentStore
        
        spinner.startAnimating()
        // Add dummy data
        studentStore.addStudent(first: "Charlie", last: "Mulholland", birth: "04/04/2002", grade: 10, zip: 20850, home: "(301)762-6106", motherName: "Becky", fatherName: "Steve", fatherPhone: "(301)807-6564", fatherEmail: "mulholland15@gmail.com", motherEmail: "mulholland4@verizon.net", motherPhone: "(301)221-4371", street: "817 Aster Blvd.", city: "Rockville MD 20850")
        studentStore.addStudent(first: "Xavier", last: "Arguello", birth: "11/14/1999", grade: 12, zip: 20816, home: "(301)320-3579", motherName: "Lourdes", fatherName: "Xavier", fatherPhone: "(240)723-0342", fatherEmail: "xavier95@hotmail.com", motherEmail: "lourdes981@yahoo.com", motherPhone: "(301)452-0458", street: "6306 Massachusetts Ave.", city: "Bethesda MD 20816")
        studentStore.addStudent(first: "Santi", last: "Arguello", birth: "03-02-2002", grade: 10, zip: 20816, home: "(301)320-3579", motherName: "Lourdes", fatherName: "Xavier", fatherPhone: "(240)723-0342", fatherEmail: "xavier95@hotmail.com", motherEmail: "lourdes981@yahoo.com", motherPhone: "(301)452-0458", street: "6306 Massachusetts Ave.", city: "Bethesda MD 20816")
        
        tableView.reloadData()
        spinner.stopAnimating()
        
        // Configure search Controller
        self.tabBarController!.navigationController!.navigationBar.backgroundColor = redColor
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.clipsToBounds = true
        let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textField!.textColor = UIColor.white
        searchController.searchBar.delegate = self
        self.tabBarController!.navigationItem.searchController = self.searchController
        
        // Configure sortView
        sortViewLeadingConstraint.constant = -175
        sortView.layer.shadowColor = UIColor.darkGray.cgColor
        sortView.layer.shadowOpacity = 1
        sortView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        // Configure sort Buttons
        alphabetButton.layer.cornerRadius = alphabetButton.frame.height / 4
        alphabetButton.layer.borderWidth = 1.0
        alphabetButton.layer.borderColor = redColor.cgColor
        
        gradeButton.layer.cornerRadius = gradeButton.frame.height / 4
        gradeButton.layer.borderWidth = 1.0
        gradeButton.layer.borderColor = UIColor.clear.cgColor
        
        ageHighButton.layer.cornerRadius = ageHighButton.frame.height / 4
        ageHighButton.layer.borderWidth = 1.0
        ageHighButton.layer.borderColor = UIColor.clear.cgColor
        
        ageLowButton.layer.cornerRadius = ageLowButton.frame.height / 4
        ageLowButton.layer.borderWidth = 1.0
        ageLowButton.layer.borderColor = UIColor.clear.cgColor
        
        studentStore.sortList(by: .alphabet)
        
        let context = LAContext()
        var biometry = "FaceID"
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            switch context.biometryType {
            case .faceID:
                biometry = "faceID"
            case .touchID:
                biometry = "touchID"
            case .none:
                biometry = ""
            }
        }
        if !UserDefaults.standard.bool(forKey: "ApplicationHasBeenOpened"), biometry != "" {
            let ac = UIAlertController(title: "Login with \(biometry)", message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                UserDefaults.standard.set(true, forKey: "ShouldAutoLoginUser")
            }
            
            let noAction = UIAlertAction(title: "No", style: .default) { (action) in
                UserDefaults.standard.set(false, forKey: "ShouldAutoLoginUser")
            }
            
            ac.addAction(yesAction)
            ac.addAction(noAction)
            present(ac, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController!.navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController!.navigationItem.title = "Students"
        self.tabBarController!.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        self.tabBarController!.navigationItem.searchController = self.searchController
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showStudentDetail":
            let destinationVC = segue.destination as! StudentDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            destinationVC.student = studentStore.shownStudents[index]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        default:
            print("unknown segue identifier")
        }
    }
    
    func switchSortButtons() {
        switch studentStore.currentSortment {
        case .ageHigh:
            ageHighButton.layer.borderColor = redColor.cgColor
            ageLowButton.layer.borderColor = UIColor.clear.cgColor
            gradeButton.layer.borderColor = UIColor.clear.cgColor
            alphabetButton.layer.borderColor = UIColor.clear.cgColor
        case .ageLow:
            ageHighButton.layer.borderColor = UIColor.clear.cgColor
            ageLowButton.layer.borderColor = redColor.cgColor
            gradeButton.layer.borderColor = UIColor.clear.cgColor
            alphabetButton.layer.borderColor = UIColor.clear.cgColor
        case .alphabet:
            ageHighButton.layer.borderColor = UIColor.clear.cgColor
            ageLowButton.layer.borderColor = UIColor.clear.cgColor
            gradeButton.layer.borderColor = UIColor.clear.cgColor
            alphabetButton.layer.borderColor = redColor.cgColor
        case .grade:
            ageHighButton.layer.borderColor = UIColor.clear.cgColor
            ageLowButton.layer.borderColor = UIColor.clear.cgColor
            gradeButton.layer.borderColor = redColor.cgColor
            alphabetButton.layer.borderColor = UIColor.clear.cgColor
        }
    }

    // MARK: - @IBActions
    @IBAction func alphabetButtonPressed(_ sender: UIButton) {
        studentStore.currentSortment = .alphabet
        studentStore.sortList(by: .alphabet)
        switchSortButtons()
        tableView.reloadData()
    }
    
    @IBAction func gradeButtonPressed(_ sender: UIButton) {
        studentStore.currentSortment = .grade
        studentStore.sortList(by: .grade)
        switchSortButtons()
        tableView.reloadData()
    }
    
    @IBAction func ageHighButtonPressed(_ sender: UIButton) {
        studentStore.currentSortment = .ageHigh
        studentStore.sortList(by: .ageHigh)
        switchSortButtons()
        tableView.reloadData()
    }
    
    @IBAction func ageLowButtonPressed(_ sender: UIButton) {
        studentStore.currentSortment = .ageLow
        studentStore.sortList(by: .ageLow)
        switchSortButtons()
        tableView.reloadData()
    }
    
    @IBAction func panRecognized(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.view).x
            if translation > 0 { // swipe right
                if sortViewLeadingConstraint.constant < 20 { // if the view isn't already out
                    self.sortViewLeadingConstraint.constant += translation / 10
                    self.view.layoutIfNeeded()
                }
            } else { // swipe left
                if sortViewLeadingConstraint.constant > -175 { // if the view isn't all the way in
                    self.sortViewLeadingConstraint.constant += translation / 10
                    self.view.layoutIfNeeded()
                }
            }
        } else if sender.state == .ended {
            if sortViewLeadingConstraint.constant < -100 {
                UIView.animate(withDuration: 0.15, animations: {
                    self.sortViewLeadingConstraint.constant = -175
                    self.view.layoutIfNeeded()
                })
            } else {
                UIView.animate(withDuration: 0.15, animations: {
                    self.sortViewLeadingConstraint.constant = 0
                    self.view.layoutIfNeeded()
                }) { (completion) in
                    self.impactController.impactOccurred()
                }
            }
        }
    }
    
    
    // MARK: - UISearchBarDelegate protocall
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            studentStore.search(for: searchText)
        } else {
            studentStore.loadAll()
        }
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("\(#function)")
        if let text = searchBar.text, text != "" {
            studentStore.search(for: text)
        } else {
            studentStore.loadAll()
        }
        tableView.reloadData()
    }
    
}
