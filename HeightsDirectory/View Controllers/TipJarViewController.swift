//
//  TipJarViewController.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 4/17/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import UIKit
import StoreKit


class TipJarViewController: UIViewController {
    
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var oneDollarButton: UIButton!
    @IBOutlet var twoDollarButton: UIButton!
    @IBOutlet var fiveDollarButton: UIButton!
    @IBOutlet var tenDollarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        oneDollarButton.layer.cornerRadius = oneDollarButton.frame.height / 10
        twoDollarButton.layer.cornerRadius = twoDollarButton.frame.height / 10
        fiveDollarButton.layer.cornerRadius = fiveDollarButton.frame.height / 10
        tenDollarButton.layer.cornerRadius = tenDollarButton.frame.height / 10
    }
    
    
    @IBAction func oneDollarPressed(_ sender: UIButton) {
        print("\(#function)")
    }
    
    @IBAction func twoDollarPressed(_ sender: UIButton) {
        print("\(#function)")
    }
    
    @IBAction func fiveDollarPressed(_ sender: UIButton) {
        print("\(#function)")
    }
    
    @IBAction func tenDollarPressed(_ sender: UIButton) {
        print("\(#function)")
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
