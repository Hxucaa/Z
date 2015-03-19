//
//  ViewController.swift
//  XListing
//
//  Created by Lance on 2015-03-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit

class ViewController: UIViewController {

    @IBOutlet weak var featuredButton: UIButton!
    @IBOutlet weak var resultTextView: UITextView!
    
    private var featuredButtonSignal: Signal<NSString?>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        PopulateParse.Populate()
        
        var f = FeaturedListPresenter()
        f.getList()
        
        featuredButtonSignal = featuredButton?.buttonSignal("haha")
        
        (resultTextView, "text") <~ featuredButtonSignal!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

