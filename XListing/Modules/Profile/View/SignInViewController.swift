//
//  SignInViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-16.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var displayNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func continueButtonPressed(sender: AnyObject) {
        let displayName : String = displayNameField.text
        
        if displayName.isEmpty {
            println("Name field is empty")
        } else {
            UserService.updateBirthday((birthdayPicker.date))
            UserService.updateDisplayName(displayNameField.text)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
