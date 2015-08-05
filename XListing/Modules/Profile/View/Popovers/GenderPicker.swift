//
//  GenderPicker.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-19.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public final class GenderPicker : NSObject, UIPopoverPresentationControllerDelegate, GenderPickerViewControllerDelegate {
    
    public typealias GenderCallback = (gender : String, forTextField : UITextField)->()
    
    var genderPickerVC : GenderPickerViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    var dataChanged : GenderCallback?
    var presented = false
    
    public init(forTextField: UITextField) {
        
        genderPickerVC = GenderPickerViewController()
        self.textField = forTextField
        super.init()
    }
    
    public func pick(inViewController : UIViewController, initGender : String?, dataChanged : GenderCallback) {
        
        if presented {
            return  // we are busy
        }
        
        genderPickerVC.delegate = self
        genderPickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        genderPickerVC.preferredContentSize = CGSizeMake(500,170)
        
        popover = genderPickerVC.popoverPresentationController
        if let _popover = popover {
            
            var height = (UIScreen.mainScreen().bounds.size.height)/2
            var width = (UIScreen.mainScreen().bounds.size.width)/2
            
            _popover.sourceView = textField
            _popover.sourceRect = CGRectMake(width-250,height-250,0,0)
            _popover.delegate = self
            _popover.permittedArrowDirections = UIPopoverArrowDirection.allZeros
            self.dataChanged = dataChanged
            inViewController.presentViewController(genderPickerVC, animated: true, completion: nil)
            presented = true
        }
    }
    
    public func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.None
    }
    
    func genderPickerVCDismissed(gender : String?) {
        
        if let _dataChanged = dataChanged {
            
            if let _gender = gender {
                
                _dataChanged(gender: _gender, forTextField: textField)
                
            }
        }
        presented = false
    }
}