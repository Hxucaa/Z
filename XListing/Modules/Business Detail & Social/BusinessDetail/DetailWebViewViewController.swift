//
//  DetailWebViewViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-09.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import UIKit
import WebKit

final class DetailWebViewViewController : XUIViewController {
    
    private let urlRequest: NSURLRequest
    private let webView = WKWebView()
    private let businessName: String
    
    init(url: NSURL, businessName: String) {
        self.urlRequest = NSURLRequest(URL:url)
        self.businessName = businessName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Setup view
        view = webView
        
        // Setup navigation bar
        self.navigationItem.title = businessName
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: #selector(dismiss))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load request
        webView.loadRequest(urlRequest)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
