//
//  DetailWebViewViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import WebKit

public final class DetailWebViewViewController : XUIViewController {
    
    private let urlRequest: NSURLRequest
    private let webView = WKWebView()
    private let businessName: String
    
    public init(url: NSURL, businessName: String) {
        self.urlRequest = NSURLRequest(URL:url)
        self.businessName = businessName
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        // Setup view
        view = webView
        
        // Setup navigation bar
        self.navigationItem.title = businessName
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: nil, action: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Dismiss Button stream
        let dismissButtonStream = self.navigationItem.rightBarButtonItem?.stream("Dismiss Button").ownedBy(self)
        dismissButtonStream?.react { _ in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        // Load request
        webView.loadRequest(urlRequest)
    }
}