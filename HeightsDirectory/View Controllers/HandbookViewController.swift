//
//  HandbookViewController.swift
//  HeightsDirectory
//
//  Created by Charlie Mulholland on 2/6/18.
//  Copyright © 2018 Charlie Mulholland. All rights reserved.
//

import UIKit
import WebKit

class HandbookViewController: UIViewController {
    // MARK: - Variables
    
    // MARK: - @IBOutlet
    @IBOutlet var webView: WKWebView!
    @IBOutlet var progressView: UIProgressView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        progressView.progress = 0.0
        self.tabBarController!.navigationItem.title = "Handbook"
        self.tabBarController!.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        // Load the handbook web page from heights website
        if let url = URL(string: "https://heights.edu/handbook/") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.navigationItem.searchController = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
}
