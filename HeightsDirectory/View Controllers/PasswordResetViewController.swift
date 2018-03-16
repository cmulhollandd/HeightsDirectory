//
//  PasswordResetViewController.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 1/31/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import UIKit
import Firebase

class PasswordResetViewController: UIViewController {
    // MARK: - @IBOutlet
    @IBOutlet var errorMessageLabel: UILabel!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var resetButton: UIButton!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorMessageLabel.alpha = 0.0
        resetButton.layer.cornerRadius = resetButton.frame.height / 2
    }
    
    // MARK: - @IBAction
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        if let email = emailField.text {
            Auth.auth().sendPasswordReset(withEmail: email) {
                (error) -> Void in
                if error == nil {
                    let ac = UIAlertController(title: "Email Sent", message: "A link to reset your password has been sent to \(email)", preferredStyle: .alert)
                    let greatAction = UIAlertAction(title: "Great!", style: .cancel, handler: {
                        (action) -> Void in
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                    ac.addAction(greatAction)
                    self.present(ac, animated: true, completion: nil)
                } else {
                    let ac = UIAlertController(title: "Couldn't Reset Password", message: error!.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    ac.addAction(okAction)
                    self.present(ac, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}
