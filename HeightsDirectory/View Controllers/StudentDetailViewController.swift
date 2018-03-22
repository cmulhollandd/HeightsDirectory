//
//  StudentDetailViewController.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 2/6/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import ContactsUI
import MessageUI

class StudentDetailViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK: - Variables
    var addrLon = 0.0
    var addrLat = 0.0
    var student: Student!
    let df: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "mm/dd/yyyy"
        return df
    }()
    let redColor = UIColor(red:0.84, green:0.20, blue:0.23, alpha:1.0)
    
    // @IBOutlet
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var gradeLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var streetAddrLabel: UILabel!
    @IBOutlet var cityAddrLabel: UILabel!
    @IBOutlet var homePhoneButton: UIButton!
    @IBOutlet var motherInfoLabel: UILabel!
    @IBOutlet var fatherInfoLabel: UILabel!
    @IBOutlet var fatherEmailButton: UIButton!
    @IBOutlet var fatherPhoneButton: UIButton!
    @IBOutlet var motherEmailButton: UIButton!
    @IBOutlet var motherPhoneButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var fatherAddContact: UIButton!
    @IBOutlet var motherAddContact: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.layer.cornerRadius = mapView.frame.height / 10
        self.navigationController?.navigationBar.prefersLargeTitles = false
        firstNameLabel.text = student.firstName
        lastNameLabel.text = student.lastName
        gradeLabel.text = "\(student.grade)"
        birthdayLabel.text = df.string(from: student.birthDate)
        streetAddrLabel.text = student.streetAddress
        cityAddrLabel.text = student.cityAddress
        motherInfoLabel.text = "\(student.motherName)'s Phone and email"
        fatherInfoLabel.text = "\(student.fatherName)'s Phone and email"
        homePhoneButton.setTitle(student.homePhone, for: .normal)
        fatherPhoneButton.setTitle(student.fatherPhone, for: .normal)
        fatherEmailButton.setTitle(student.fatherEmail, for: .normal)
        motherEmailButton.setTitle(student.motherEmail, for: .normal)
        motherPhoneButton.setTitle(student.motherPhone, for: .normal)
        fatherAddContact.layer.borderWidth = 1.0
        fatherAddContact.layer.cornerRadius = fatherAddContact.frame.height / 2
        fatherAddContact.layer.borderColor = redColor.cgColor
        motherAddContact.layer.borderWidth = 1.0
        motherAddContact.layer.cornerRadius = motherAddContact.frame.height / 2
        motherAddContact.layer.borderColor = redColor.cgColor

        setPinOnMap()
    }
    
    // MARK: - @IBAction
    @IBAction func homePhoneButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "tel://\(sender.titleLabel!.text!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func fatherEmailButtonPressed(_ sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        if let email = student.fatherEmail {
            let vc = MFMailComposeViewController()
            vc.setToRecipients([email])
            vc.mailComposeDelegate = self
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func fatherPhoneButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "tel://\(sender.titleLabel!.text!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func motherEmailButtonPressed(_ sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        if let email = student.motherEmail {
            let vc = MFMailComposeViewController()
            vc.setToRecipients([email])
            vc.mailComposeDelegate = self
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func motherPhoneButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "tel://\(sender.titleLabel!.text!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func fatherAddContactPress(_ sender: UIButton) {
        let contact = CNMutableContact()
        let addr = CNMutablePostalAddress()
        let addrData = formatAddress()
        addr.street = student.streetAddress
        addr.city = addrData.1
        addr.state = addrData.2
        addr.postalCode = addrData.3
        contact.givenName = student.fatherName
        contact.familyName = student.lastName
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberMain,
            value:CNPhoneNumber(stringValue:(student.fatherPhone)!))
        ]
        contact.emailAddresses = [CNLabeledValue(
            label: CNLabelHome,
            value: student.fatherEmail! as NSString)
        ]
        contact.postalAddresses = [CNLabeledValue(
            label: CNLabelHome,
            value: addr)
        ]
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        do {
            try store.execute(saveRequest)
        } catch {
            print("error")
            return
        }
        
        let messageString = "\(student.fatherName) \(student.lastName) was added to contacts"
        let ac = UIAlertController(title: "Contact Added", message: messageString, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func motherAddContactPress(_ sender: UIButton) {
        let contact = CNMutableContact()
        let addr = CNMutablePostalAddress()
        let addrData = formatAddress()
        addr.street = student.streetAddress
        addr.city = addrData.1
        addr.state = addrData.2
        addr.postalCode = addrData.3
        contact.givenName = student.motherName
        contact.familyName = student.lastName
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberMain,
            value:CNPhoneNumber(stringValue:(student.motherPhone)!))
        ]
        contact.emailAddresses = [CNLabeledValue(
            label: CNLabelHome,
            value: student.motherEmail! as NSString)
        ]
        contact.postalAddresses = [CNLabeledValue(
            label: CNLabelHome,
            value: addr)
        ]
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        do {
            try store.execute(saveRequest)
        } catch {
            print("error")
            return
        }
        
        let messageString = "\(student.motherName) \(student.lastName) was added to contacts"
        let ac = UIAlertController(title: "Contact Added", message: messageString, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func mapTapped(_ sender: UITapGestureRecognizer) {
        let longitude = addrLon
        let latitude = addrLat
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(student.streetAddress) \(student.cityAddress)"
        mapItem.openInMaps(launchOptions: options)
    }
    
    // MARK: - Functions
    func setPinOnMap() {
        let address = "\(student.streetAddress) \(student.cityAddress)"
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    return
            }
            self.addrLon = location.coordinate.longitude
            self.addrLat = location.coordinate.latitude
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            annotation.title = address
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 39.0278, longitude: -77.1636)
            let latitudinalMeters: CLLocationDistance = 200000
            let longitudinalMeters: CLLocationDistance = 200000
            let region = MKCoordinateRegionMakeWithDistance(coordinate, latitudinalMeters, longitudinalMeters)
            self.mapView.setRegion(region, animated: true) 
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func formatAddress() -> (String, String, String, String) {
        var results = (student.streetAddress, "", "", "")
        let addrElements = student.cityAddress.split(separator: " ")
        results.1 = String(addrElements[0])
        results.2 = String(addrElements[1])
        results.3 = String(addrElements[2])
        print(results)
        return results
    }
    
    // MARK: - Message delegate methods
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            print("Cancelled by the user")
            controller.dismiss(animated: true, completion: nil)
        case .failed:
            print("Action failed unexpectedly")
            controller.dismiss(animated: true, completion: nil)
        case .sent:
            print("Message sent successfully")
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Cancelled by user")
            controller.dismiss(animated: true, completion: nil)
        case .failed:
            print("Message send failed")
            controller.dismiss(animated: true, completion: nil)
        case .sent:
            print("Message sent successfully")
            controller.dismiss(animated: true, completion: nil)
        case .saved:
            print("Message saved but not sent")
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
