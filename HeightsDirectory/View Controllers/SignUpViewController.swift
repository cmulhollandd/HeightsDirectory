//
//  SignUpViewController.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 2/1/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    // MARK: - Variables
    private let secretKey = "Charlie"
    
    // MARK: - @IBOutlet
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var confirmPassField: UITextField!
    @IBOutlet var codeField: UITextField!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0.0
        
        emailField.layer.borderWidth = 0.5
        emailField.layer.cornerRadius = emailField.frame.height / 5
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.layer.borderWidth = 0.5
        passwordField.layer.cornerRadius = passwordField.frame.height / 5
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        confirmPassField.layer.borderWidth = 0.5
        confirmPassField.layer.cornerRadius = confirmPassField.frame.height / 5
        confirmPassField.layer.borderColor = UIColor.lightGray.cgColor
        codeField.layer.borderWidth = 0.5
        codeField.layer.cornerRadius = codeField.frame.height / 5
        codeField.layer.borderColor = UIColor.lightGray.cgColor
        confirmButton.layer.cornerRadius = confirmButton.frame.height / 2
    }
    
    // MARK: - @IBAction
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emailChanged(_ sender: UITextField) {
        if let text = sender.text {
            if text.index(of: "@") != nil && text.index(of: ".") != nil && text.count > 6{
                emailField.layer.borderColor = UIColor.green.cgColor
            } else {
                emailField.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        if let text = sender.text {
            if checkPassword(text) {
                passwordField.layer.borderColor = UIColor.green.cgColor
            } else {
                passwordField.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    @IBAction func confirmChanged(_ sender: UITextField) {
        if let text = sender.text {
            if text == passwordField.text! {
                confirmPassField.layer.borderColor = UIColor.green.cgColor
            } else {
                confirmPassField.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    @IBAction func codeChanged(_ sender: UITextField) {
        if let text = sender.text {
            if text == secretKey {
                codeField.layer.borderColor = UIColor.green.cgColor
            } else {
                codeField.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        if emailField.layer.borderColor == UIColor.green.cgColor && passwordField.layer.borderColor == UIColor.green.cgColor && confirmPassField.layer.borderColor == UIColor.green.cgColor && codeField.layer.borderColor == UIColor.green.cgColor {
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                if error == nil {
                    if let user = user {
                        user.sendEmailVerification() {
                            (error) -> Void in
                            if error == nil {
                                let ac = UIAlertController(title: "Successfull sign up", message: "Your should recieve an email with a link to verify your email.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                                let openMail = UIAlertAction(title: "Open 'Mail'", style: .default, handler: {
                                    (UIAlertAction) -> Void in
                                    let mailURL = URL(string: "message://")!
                                    if UIApplication.shared.canOpenURL(mailURL) {
                                        UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
                                    } else {
                                        print("current device doesn't support this")
                                    }
                                })
                                ac.addAction(okAction)
                                ac.addAction(openMail)
                                self.present(ac, animated: true, completion: nil)
                            }
                        }
                    }
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Methods
    func checkPassword(_ pass: String) -> Bool {
        if pass.count < 8 {
            return false
        } else {
            if pass.contains("1") || pass.contains("2") || pass.contains("3") || pass.contains("4") || pass.contains("5") || pass.contains("6") || pass.contains("7") || pass.contains("8") || pass.contains("9") || pass.contains("0") {
                if pass.contains("Q") || pass.contains("W") || pass.contains("E") || pass.contains("R") || pass.contains("T") || pass.contains("Y") || pass.contains("U") || pass.contains("I") || pass.contains("O") || pass.contains("P") || pass.contains("A") || pass.contains("S") || pass.contains("D") || pass.contains("F") || pass.contains("F") || pass.contains("G") || pass.contains("H") || pass.contains("J") || pass.contains("K") || pass.contains("L") || pass.contains("Z") || pass.contains("X") || pass.contains("C") || pass.contains("V") || pass.contains("B") || pass.contains("N") || pass.contains("M") {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
    }
}

