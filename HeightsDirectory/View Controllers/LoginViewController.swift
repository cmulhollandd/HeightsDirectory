//
//  LoginViewController.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 1/30/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import UIKit
import Firebase
import Valet
import LocalAuthentication

class LoginViewController: UIViewController {
    // MARK: - Variables
    let identifyer = "edu.heights.loginIdentifyer"
    let myValet = VALValet(identifier: "edu.heights.loginIdentifyer", accessibility: .afterFirstUnlockThisDeviceOnly)!
    var isSaved: Bool = false
    
    // MARK: - @IBOutlet
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var loginErrorLabel: UILabel!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Try and login the user from saved values
        if UserDefaults.standard.bool(forKey: "ShouldStayLoggedIn") {
            self.performSegue(withIdentifier: "loginCompleted", sender: nil)
        }
        
        if UserDefaults.standard.bool(forKey: "ShouldAutoLoginUser") {
            tryAutoLogin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginErrorLabel.alpha = 0.0
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        
    }
    
    // MARK: - @IBAction
    @IBAction func loginButtonPress(_ sender: UIButton) {
        print("\(#function)")
        tryLogin(nil)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        print("\(#function)")
        view.endEditing(true)
        view.endEditing(true)
    }
    
    @IBAction func emailDidReturn(_ sender: UITextField) {
        print("\(#function)")
        passwordField.becomeFirstResponder()
    }
    
    @IBAction func passwordDidReturn(_ sender: UITextField) {
        print("\(#function)")
        passwordField.resignFirstResponder()
        tryLogin(nil)
    }
    
    
    // MARK: - Methods
    func tryLogin(_ sender: UIButton?) {
        print("\(#function)")
        view.endEditing(true)
        if emailField.text! != "" {
            if passwordField.text! != "" {
                Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                    if error == nil {
                        if let user = user {
                            if !user.isEmailVerified {
                                let ac = UIAlertController(title: "Login Failed", message: "Please verify your email before logging in.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                                ac.addAction(okAction)
                                self.present(ac, animated: true, completion: nil)
                                return
                            }
                        }
                        if !self.isSaved {
                            UserDefaults.standard.set(self.emailField.text!, forKey: "heights.username")
                            self.myValet.setString(self.passwordField.text!, forKey: "heights.password")
                            print("Saved the username and password")
                        }
                        self.performSegue(withIdentifier: "loginCompleted", sender: nil)
                    } else {
                        let ac = UIAlertController(title: "Login Failed", message: error!.localizedDescription, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        ac.addAction(okAction)
                        self.present(ac, animated: true, completion: nil)
                    }
                }
            } else {
                self.loginErrorLabel.text = "Enter your password"
                self.loginErrorLabel.alpha = 1.0
            }
        } else {
            self.loginErrorLabel.text = "Enter your email"
            self.loginErrorLabel.alpha = 1.0
        }
    }
    
    
    func tryAutoLogin() {
        if let username = UserDefaults.standard.string(forKey: "heights.username") {
            self.emailField.text = username
            self.isSaved = true
            let myContext = LAContext()
            if let password = myValet.string(forKey: "heights.password") {
                let localizedStringReason = "To login the user"
                var authError: NSError?
                if #available(iOS 8.0, *) {
                    if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                        myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedStringReason) { (success, error) in
                            if success {
                                // User is recognized
                                OperationQueue.main.addOperation {
                                    self.passwordField.text = password
                                    self.tryLogin(nil)
                                }
                            } else {
                                // User isn't recognized
                                print("couldn't recognize user")
                            }
                        }
                    } else {
                        // Couldn't evaluate policy for some reason
                        print("couldn't evaluate policy")
                    }
                } else {
                    // biometrics not yet available
                    print("biometrics not yet avalable")
                }
            } else {
                print("email not yet saved")
            }
        }
    }
}
