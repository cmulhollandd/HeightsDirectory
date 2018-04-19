//
//  FacultyViewConytroller.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 1/31/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import UIKit
import Firebase

class FacultyViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate {
    // MARK: - Variables
    var facultyStore = FacultyStore()
    var searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - @IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController!.navigationItem.title = "Faculty"
        self.tabBarController!.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.tabBarController!.navigationItem.searchController = self.searchController
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = facultyStore
        
        facultyStore.addFaculty(first: "John", last: "Beatty", title: "IT Director, Computer Science", degrees: "B.S. Virginia Polytechnic Institute and State University", phone: "(301)365-0227,274", email: "jbeatty@heights.edu", bio: "John serves at The Heights as Director of Information Technology. He is also an alumnus, graduating from The Heights in 2007; he went on the study Computer Science, Business and Math at Virginia Tech, finishing in 2010. He worked for a number of technology companies and startups in the D.C. area, as well as releasing iPhone apps on his own. John resides in Fairfax with his wife and two boys.", years: 4)
        facultyStore.addFaculty(first: "Larry", last: "Kilmer", title: "Mathmatics, Physical Education", degrees: "B.A. University of Maryland", phone: "(301)365-0227,239", email: "lkilmer@heights.edu", bio: "Larry began teaching at The Heights in 2006.  He graduated from the University of Maryland in 1982.  He spent several years teaching in public school before going to work for the Navy in Special Projects.  He returned to teaching and coaching in 1989 at St John’s Episcopal and St Peter’s in Olney.  He then worked full time as a math, physical education teacher and coach at Sandy Spring Friends School.  Prior to joining The Heights, he worked at the Academy of the Holy Cross as the athletic director, assistant athletic director, and a U.S. and World Studies teacher.  His coaching experience there included varsity soccer, freshman lacrosse, and several basketball teams. Larry teaches mathematics and physical education in the Middle School, and coaches the seventh grade lacrosse team. Larry and his wife, Jennifer, have eleven children on the roster of the Kilmer team.", years: 12)
        facultyStore.addFaculty(first: "Michael", last: "Hude", title: "College Counselor, 9th Grade Core", degrees: "B.A. University of Dallas; M.A. Catholic University of America", phone: "(301)365-0227,164", email: "mhude@heights.edu", bio: "Michael Hude joined the faculty at The Heights in 2009 and teaches ninth grade English and history, while also serving as a College Counselor. Prior to coming to The Heights, Michael served as the Director of the Elementary Tenley Achievement Program (TAP), a non-profit organization that mentors at-risk youth in the greater Washington, D.C. area. Michael earned a B.A. in philosophy with a concentration in classical languages from the University of Dallas. He then earned an M.A. from The Catholic University of America and taught courses in ancient and modern philosophy to its undergraduates. Michael, his wife Patty, and their children Elizabeth, Maximilian, and Emma, make their home in Frederick, Maryland.", years: 9)
        tableView.reloadSections(IndexSet(), with: UITableViewRowAnimation.automatic)
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.white
        let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textField!.textColor = UIColor.white
        searchController.searchBar.delegate = self
        self.tabBarController!.navigationItem.searchController = self.searchController
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showFacultyDetail":
            let destinationVC = segue.destination as! FacultyDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            destinationVC.faculty = facultyStore.shownFaculty[index]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
        default:
            print("unknown segue identifier")
        }
    }
    
    // MARK: - UISearchBarDelegate protocall
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            facultyStore.search(for: searchText)
        } else {
            facultyStore.loadAll()
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text != "" {
            facultyStore.search(for: text)
        } else {
            facultyStore.loadAll()
        }
        tableView.reloadData()
    }
}
