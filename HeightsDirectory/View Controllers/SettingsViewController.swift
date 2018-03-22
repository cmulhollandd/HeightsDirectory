//
//  SettingsViewController.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 2/1/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication

class SettingsViewController: UIViewController {
    // MARK: - Variables
    var biometryType = ""
    
    // MARK: - @IBOutlet
    @IBOutlet var signOutButton: UIButton!
    @IBOutlet var updateEmailButton: UIButton!
    @IBOutlet var newEmailField: UITextField!
    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var newPasswordButton: UIButton!
    @IBOutlet var loginSwitch: UISwitch!
    @IBOutlet var switchLabel: UILabel!
    @IBOutlet var stayLoggedInSwitch: UISwitch!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"
        signOutButton.layer.cornerRadius = signOutButton.frame.height / 2
        signOutButton.layer.borderWidth = 1.0
        signOutButton.layer.borderColor = UIColor(red:0.84, green:0.20, blue:0.23, alpha:1.0).cgColor
        signOutButton.layer.cornerRadius = signOutButton.frame.height / 2
        newPasswordButton.layer.cornerRadius = newPasswordButton.frame.height / 2
        errorMessageLabel.alpha = 0.0
        newEmailField.layer.borderWidth = 0.5
        newEmailField.layer.borderColor = UIColor.lightGray.cgColor
        newEmailField.layer.cornerRadius = newEmailField.frame.height / 5
        updateEmailButton.layer.cornerRadius = updateEmailButton.frame.height / 2
        newPasswordButton.layer.cornerRadius = newPasswordButton.frame.height / 2
        
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            switch context.biometryType {
            case .faceID:
                self.biometryType = "faceID"
            case .touchID:
                self.biometryType = "touchID"
            case .none:
                self.biometryType = "touchID"
                self.loginSwitch.isEnabled = false
            }
        }
        
        if UserDefaults.standard.bool(forKey: "ShouldAutoLoginUser") {
            self.loginSwitch.isOn = true
        }
        
        if UserDefaults.standard.bool(forKey: "ShouldStayLoggedIn") {
            self.stayLoggedInSwitch.isOn = true
        }
        
        self.switchLabel.text = "Login with \(biometryType):"
    }
    
    // MARK: - @IBAction
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func stayLoggedInSwitch(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "ShouldStayLoggedIn")
        } else {
            UserDefaults.standard.set(false, forKey: "ShouldStayLoggedIn")
        }
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            let context = LAContext()
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Give Access") { (success, error) in
                    if success {
                        UserDefaults.standard.set(true, forKey: "ShouldAutoLoginUser")
                        return
                    } else {
                        let ac = UIAlertController(title: "\(self.biometryType) has been disabled for now", message: nil, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        ac.addAction(okAction)
                        UserDefaults.standard.set(false, forKey: "ShouldAutoLoginUser")
                        self.present(ac, animated: true, completion: nil)
                    }
                }
            }
        } else {
            UserDefaults.standard.set(false, forKey: "ShouldAutoLoginUser")
        }
    }
    
    @IBAction func updateEmailButtonPressed(_ sender: UIButton) {
        if newEmailField.text! != "" && checkEmail(newEmailField.text!) {
            // update email through firebase
            // send email verification message
            var firebaseUser = Auth.auth().currentUser!
            firebaseUser.updateEmail(to: newEmailField.text!) {
                (error) in
                if error == nil {
                    firebaseUser =  Auth.auth().currentUser!
                    firebaseUser.sendEmailVerification() {
                        (error) -> Void in
                        if error == nil {
                            let ac = UIAlertController(title: "Successfull sign up", message: "Your should recieve an email with a link to verify your email.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: {
                                (action) -> Void in
                                self.dismiss(animated: true, completion: nil)
                            })
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
                } else {
                    let ac = UIAlertController(title: "Could not update email", message: error!.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    ac.addAction(okAction)
                    self.present(ac, animated: true, completion: nil)
                }
            }
        } else {
            
        }
    }
    @IBAction func emailFieldEditingChanged(_ sender: UITextField) {
        if let text = sender.text {
            if checkEmail(text) {
                newEmailField.layer.borderColor = UIColor.green.cgColor
            } else {
                newEmailField.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    @IBAction func newPasswordPressed(_ sender: UIButton) {
        // send email for new password with firebase
        let userEmail = Auth.auth().currentUser!.email!
        Auth.auth().sendPasswordReset(withEmail: userEmail) {
            (error) -> Void in
            if error == nil {
                let ac = UIAlertController(title: "Email Sent", message: "A link to reset your password has been sent to \(userEmail)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                let openMail = UIAlertAction(title: "Open 'Mail'", style: .default, handler: {
                    (action) -> Void in
                    let mailURl = URL(string: "message://")!
                    UIApplication.shared.open(mailURl, options: [:], completionHandler: nil)
                })
                ac.addAction(okAction)
                ac.addAction(openMail)
                self.present(ac, animated: true, completion: nil)
            } else {
                let ac = UIAlertController(title: "Couldn't Reset Password", message: error!.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                ac.addAction(okAction)
                self.present(ac, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signOutPressed(_ sender: UIButton) {
        // sign out with firebase
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            let ac = UIAlertController(title: "Could not sign out.", message: signOutError.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            ac.addAction(okAction)
            present(ac, animated: true, completion: nil)
            return
        }
        UserDefaults.standard.set(false, forKey: "ShouldAutoLoginUser")
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Methods
    func checkEmail(_ text: String) -> Bool {
        if text.count > 7 {
            if text.contains("@") && text.contains(".") {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
