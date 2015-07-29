//
//  GenderPickerViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-19.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

protocol GenderPickerViewControllerDelegate : class {
    
    func genderPickerVCDismissed(gender : String?)
}

public final class GenderPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var genderPicker: UIPickerView!
    
    weak var delegate : GenderPickerViewControllerDelegate?
    var genderData = ["男", "女"]
    
    var currentDate : NSDate? {
        didSet {
            updatePickerCurrentDate()
        }
    }
    
    convenience init() {
        self.init(nibName: "GenderPickerViewController", bundle: nil)
    }
    
    private func updatePickerCurrentDate() {
        
        if let _currentDate = self.currentDate {
            if let _genderPicker = self.genderPicker {
                //_genderPicker = _currentDate
            }
        }
    }
    
    @IBAction func okAction(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) {
            
            let selectedIndex = self.genderPicker.selectedRowInComponent(0)
            self.delegate?.genderPickerVCDismissed(self.genderData[selectedIndex])
        }
    }
    
    public override func viewDidLoad() {
        genderPicker.delegate = self
        genderPicker.dataSource = self
        updatePickerCurrentDate()
    }
    
    public override func viewDidDisappear(animated: Bool) {
        
        self.delegate?.genderPickerVCDismissed(nil)
    }
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if row == 0
        {
            return "男"
        }else {
            return "女"
        }
    }
}