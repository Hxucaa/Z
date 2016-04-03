//
//  XUIViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-11.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import ReactiveCocoa
#if DEBUG
    import FLEX
#endif

private let MinimumPressDuration = 4.0

class XUIViewController: RxViewController {
    
    let compositeDisposable = CompositeDisposable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Add gesture recognizer
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(XUIViewController.handleLongPress(_:)))
        gesture.minimumPressDuration = MinimumPressDuration
        self.view.addGestureRecognizer(gesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        #if DEBUG
            if recognizer.state == UIGestureRecognizerState.Began {
                FLEXManager.sharedManager().showExplorer()
            }
        #endif
    }
    
    deinit {
        compositeDisposable.dispose()
    }
}

class XScrollingNavigationViewController : ScrollingNavigationViewController {
    
    let compositeDisposable = CompositeDisposable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Add gesture recognizer
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(XUIViewController.handleLongPress(_:)))
        gesture.minimumPressDuration = MinimumPressDuration
        self.view.addGestureRecognizer(gesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        #if DEBUG
            if recognizer.state == UIGestureRecognizerState.Began {
                FLEXManager.sharedManager().showExplorer()
            }
        #endif
    }
    
    deinit {
        compositeDisposable.dispose()
    }
}