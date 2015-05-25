//
//  SignInViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-16.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var selectPictureButton: UIButton!
    
    let imagePicker = UIImagePickerController()
        var accountVM: IAccountViewModel?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //UserService.updateProfilePicture(pickedImage)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectPictureButtonPressed(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func continueButtonPressed(sender: AnyObject) {
        let displayName : String = displayNameField.text
        
        if displayName.isEmpty {
            println("Name field is empty")
        } else {
            accountVM!.updateBirthday((birthdayPicker.date))
            accountVM!.updateDisplayName(displayNameField.text)
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
