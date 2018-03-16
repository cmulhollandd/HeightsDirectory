//
//  FacultyDetailViewController.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 2/7/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import UIKit
import MessageUI
import Contacts

class FacultyDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    // MARK: - @IBOutlets
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var degreeLabel: UILabel!
    @IBOutlet var phoneNumberButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var bioTextView: UITextView!
    @IBOutlet var yearsLabel: UILabel!
    
    // MARK: - Variables
    var faculty: Faculty!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        lastNameLabel.text = faculty.lastName
        firstNameLabel.text = faculty.firstName
        titleLabel.text = faculty.title
        degreeLabel.text = faculty.degrees
        phoneNumberButton.setTitle(faculty.phone, for: .normal)
        emailButton.setTitle(faculty.email, for: .normal)
        bioTextView.text = faculty.bio
        yearsLabel.text = "Years at The Heights: \(faculty.yearsAtHeights)"
    }
    
    // MARK: - @IBActions
    @IBAction func phoneButtonPressed(_ sender: UIButton) {
        if let url = URL(string: sender.titleLabel!.text!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // notify the user that the phone number isn't valid
            let ac = UIAlertController(title: "Invalid Phone Number", message: "this phone number could not be found", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            let contactAction = UIAlertAction(title: "Contact Us", style: .default, handler: {
                (action) -> Void in
                
                let mc = MFMailComposeViewController()
                mc.setSubject("report a problem")
                mc.setToRecipients(["csdirectory1718@gmail.com"])
                mc.setMessageBody("Describe problem below this line\n\n\nattNum: \(self.faculty.phone)\nattName: \(self.faculty.firstName) \(self.faculty.lastName)", isHTML: false)
                mc.mailComposeDelegate = self
                self.present(mc, animated: true, completion: nil)
                })
            ac.addAction(okAction)
            if MFMailComposeViewController.canSendMail() {
                ac.addAction(contactAction)
            }
            present(ac, animated: true, completion: nil)
        }
    }
    
    @IBAction func emailButtonPressed(_ sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        let mc = MFMailComposeViewController()
        mc.setToRecipients([sender.titleLabel!.text!])
        mc.mailComposeDelegate = self
        self.present(mc, animated: true, completion: nil)
    }
    
    @IBAction func addToContacts(_ sender: UIBarButtonItem) {
        let contact = CNMutableContact()
        contact.givenName = faculty.firstName
        contact.familyName = faculty.lastName
        contact.jobTitle = faculty.title
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberMain,
            value:CNPhoneNumber(stringValue:faculty.phone))
        ]
        contact.emailAddresses = [CNLabeledValue(
            label: CNLabelHome,
            value: faculty.email as NSString)
        ]
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier:nil)
        do {
            try store.execute(saveRequest)
        } catch {
            print("error")
            return
        }
        
        let ac = UIAlertController(title: "Contact Added", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
    
    // MARK: - Delegate methods
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Cancelled")
            controller.dismiss(animated: true, completion: nil)
        case .failed:
            print("failed")
            controller.dismiss(animated: true, completion: nil)
        case .saved:
            print("saved")
            controller.dismiss(animated: true, completion: nil)
        case .sent:
            print("sent")
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
}
