//
//  SignInViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-16.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

public final class AccountViewController: XUIViewController {
    
    private var viewmodel: IAccountViewModel!
    private var dismissCallback: CompletionHandler?
    public var containerVC : ContainerViewController!
    
    public func bindToViewModel(viewModel: IAccountViewModel, dismissCallback: CompletionHandler? = nil) {
        self.viewmodel = viewModel
        self.dismissCallback = dismissCallback
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        self.dismissViewControllerAnimated(true, completion: nil)
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    Call this to dismiss the view controller
    */
    public func dismissViewController() {
        self.dismissViewControllerAnimated(true, completion: dismissCallback)
    }
    
    public override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "embedSegue") {
            self.containerVC = segue.destinationViewController as! ContainerViewController;
        }
    }
}
