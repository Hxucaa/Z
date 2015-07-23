//
//  ProfileEditViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

private let UserIcon = "\u{f007}"
private let GenderIcon = "\u{f228}"
private let BirthdayIcon = "\u{f06b}"
private let StatusIcon = "\u{f0a1}"
private let EmailIcon = "\u{f003}"
private let PhoneIcon = "\u{f095}"
private let XIcon = "\u{f00d}"

public final class ProfileEditViewController: XUIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewmodel: ProfileEditViewModel!
    private var genderTitle: String!
    private var editButton: UIButton!
    private let imagePicker = UIImagePickerController()
    private var profilePicture: UIImageView!
    private var popDatePicker : PopoverDatePicker?
    private var birthdayTextField : UITextField!
    private var shouldAdjustForKeyboard : Bool = false
    
    private var nicknameCell : NicknameTableViewCell!
    private var whatsupCell : WhatsupTableViewCell!
    private var birthdayCell : BirthdayTableViewCell!
    private var genderCell : GenderTableViewCell!
    private var phoneCell : PhoneEmailTableViewCell!
    private var emailCell : PhoneEmailTableViewCell!

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupImagePicker()
        setUpProfilePicture()
        setupDismissButton()
        setupSaveButton()
        // Do any additional setup after loading the view.
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewWillAppear(animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.view.endEditing(true)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    public func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        setUpTableViewCells()
        tableView.reloadData()
    }
    
    public func setUpTableViewCells() {
        setUpNicknameCell()
        setUpGenderCell()
        setUpBirthdayCell()
        setUpWhatsupCell()
        setUpPhoneEmailCell()
    }
    
    public func setUpNicknameCell() {
        nicknameCell = tableView.dequeueReusableCellWithIdentifier("NicknameCell") as! NicknameTableViewCell
        nicknameCell.textField.placeholder = "昵称"
        viewmodel.nickname <~ nicknameCell.textField.rac_text
        nicknameCell.editProfilePicButton.addTarget(self, action: "chooseProfilePictureSource", forControlEvents: UIControlEvents.TouchUpInside)
        nicknameCell.textField.delegate = self
    }
    
    public func setUpWhatsupCell() {
        whatsupCell = tableView.dequeueReusableCellWithIdentifier("WhatsupCell") as! WhatsupTableViewCell
        whatsupCell.textField.delegate = self
        whatsupCell.textField.placeholder = "心情"
    }
    
    public func setUpBirthdayCell() {
        birthdayCell = tableView.dequeueReusableCellWithIdentifier("BirthdayCell") as! BirthdayTableViewCell
        birthdayCell.delegate = self
        birthdayCell.birthdayTextField.delegate = self
        birthdayCell.birthdayTextField.placeholder = "生日"
    }
    
    public func setUpGenderCell() {
        genderCell = tableView.dequeueReusableCellWithIdentifier("GenderCell") as! GenderTableViewCell
        genderCell.genderIcon.text = GenderIcon
        if (genderTitle == nil) {
            genderTitle = "性别"
        }
        genderCell.genderButton.setTitle(genderTitle, forState: UIControlState.Normal)
        genderCell.genderButton.addTarget(self, action: "chooseGender", forControlEvents: UIControlEvents.TouchUpInside)
        genderCell.editProfilePicButton.addTarget(self, action: "chooseProfilePictureSource", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    public func setUpPhoneEmailCell() {
        phoneCell = tableView.dequeueReusableCellWithIdentifier("PhoneEmailCell") as! PhoneEmailTableViewCell
        phoneCell.textField.delegate = self
        phoneCell.textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        emailCell = tableView.dequeueReusableCellWithIdentifier("PhoneEmailCell") as! PhoneEmailTableViewCell
        emailCell.textField.delegate = self
        emailCell.textField.keyboardType = UIKeyboardType.EmailAddress
    }
    
    public func chooseGender() {
        var alert = UIAlertController(title: "Choose a gender", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        var maleAction = UIAlertAction(title: "男", style: UIAlertActionStyle.Default) { UIAlertAction -> Void in
            self.viewmodel.gender.put(Gender.Male)
            self.genderTitle = "男"
            self.genderCell.genderButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        }
        var femaleAction = UIAlertAction(title: "女", style: UIAlertActionStyle.Default) { UIAlertAction -> Void in
            self.viewmodel.gender.put(Gender.Female)
            self.genderTitle = "女"
            self.genderCell.genderButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
            }
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(maleAction)
        alert.addAction(femaleAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    public func chooseProfilePictureSource() {
        var alert = UIAlertController(title: "选择上传方式", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        var galleryAction = UIAlertAction(title: "在相册中选取", style: UIAlertActionStyle.Default) { UIAlertAction -> Void in
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        var cameraAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { UIAlertAction -> Void in
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    public func dismissView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setupSaveButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Done, target: self, action: "saveAction")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
    }
    
    public func saveAction() {
        if (viewmodel.allInputsValid.value) {
            // Button action
            let submitAction = Action<UIBarButtonItem, Bool, NSError> { [weak self] button in
                let updateProfileAndHUD = HUD.show()
                    |> mapError { _ in NSError() }
                    |> then(self!.viewmodel.updateProfile)
                    // dismiss HUD based on the result of update profile signal
                    |> HUD.onDismissWithStatusMessage(errorHandler: { error -> String in
                        AccountLogError(error.description)
                        return error.customErrorDescription
                    })
                
                let HUDDisappear = HUD.didDissappearNotification() |> mapError { _ in NSError() }
                
                // combine the latest signal of update profile and hud dissappear notification
                // once update profile is done properly and HUD is disappeared, proceed to next step
                return combineLatest(updateProfileAndHUD, HUDDisappear)
                    |> map { success, notificationMessage -> Bool in
                        self?.dismissViewControllerAnimated(true, completion: nil)
                        return success
                }
            }
            submitAction.unsafeCocoaAction.execute(self.navigationItem.rightBarButtonItem!)
        } else {
            var alert = UIAlertController(title: "提交失败啦", message: "请填写昵称,性别,生日和上传一张照片😊", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    public func setupDismissButton() {
        var dismissButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "dismissView")
        dismissButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = dismissButton
    }
    
    
    public func bindToViewModel(viewmodel: ProfileEditViewModel) {
        self.viewmodel = viewmodel
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    public func presentUIImagePicker () {
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    private func setUpProfilePicture () {
        self.profilePicture = UIImageView(frame: CGRectMake(0, 0, 80, 80)) as UIImageView
        var myImage: UIImage = UIImage(named: "curry")!
        self.profilePicture.image = myImage
        self.profilePicture.layer.cornerRadius = CGFloat(self.profilePicture.frame.width) / 2
        self.profilePicture.layer.masksToBounds = true
        self.profilePicture.userInteractionEnabled = true
    }
    
    public func chooseBirthday (textField: UITextField) {
        popDatePicker = PopoverDatePicker(forTextField: textField)
    }
    
    // Call this method somewhere in your view controller setup code.
    public func registerForKeyboardNotifications ()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Called when the UIKeyboardWillShowNotification is sent.
    public func keyboardWillShow(notification: NSNotification)
    {
        var contentInsets:UIEdgeInsets
        var deviceWidth = UIScreen.mainScreen().bounds.size.width
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, 224, 0.0)
        
        if (shouldAdjustForKeyboard) {
        tableView.contentInset = contentInsets
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1), atScrollPosition: .Top, animated: true)
        tableView.scrollIndicatorInsets = contentInsets
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    public func keyboardWillBeHidden(notification: NSNotification)
    {
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0)
        tableView.contentInset = UIEdgeInsetsMake(64,0,0,0)
        shouldAdjustForKeyboard = false
    }
    
}

extension ProfileEditViewController: UITableViewDataSource, UITableViewDelegate {
    
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
            case 0: return 4
            case 1: return 2
            default: return 0
        }
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    /**
    Asks the data source for a cell to insert in a particular location of the table view. (required)
    
    :param: tableView A table-view object requesting the cell.
    :param: indexPath An index path locating a row in tableView.
    
    :returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var datePickerCell = tableView.dequeueReusableCellWithIdentifier("DatePicker") as! DatePickerTableViewCell
        switch (indexPath.section) {
            case 0:
                switch(indexPath.row) {
                case 0: return nicknameCell
                case 1:
                    genderCell.genderButton.setTitle(genderTitle, forState: UIControlState.Normal)
                    return genderCell
                case 2: return birthdayCell
                case 3: return whatsupCell
                default : print("error rendering cell")
                }
            case 1:
                switch(indexPath.row) {
                case 0:
                    emailCell.icon.text = EmailIcon
                    emailCell.textField.placeholder = "邮件"
                    return emailCell
                case 1:
                    phoneCell.icon.text = PhoneIcon
                    phoneCell.textField.placeholder = "电话"
                    return phoneCell
                default: print("error rendering cell")
            }
            default: print("error rendering cell")
        }
        
        return phoneCell
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {return "隐私信息"} else {return ""}
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var deviceWidth = UIScreen.mainScreen().bounds.size.width
        var picYCoord: CGFloat
        var profilePicView: UIView = UIView(frame: CGRectMake(deviceWidth-90, -245, 85, 100))
        profilePicView.addSubview(self.profilePicture)
        
        let header: UITableViewHeaderFooterView =  UITableViewHeaderFooterView(frame: CGRectMake(100, 0, 100, 100))
        header.addSubview(profilePicView)
        return header
    }
    
    public func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel.textColor = UIColor.grayColor()
        header.textLabel.font = UIFont.boldSystemFontOfSize(18)
        header.textLabel.frame = header.frame
        header.textLabel.textAlignment = NSTextAlignment.Left
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0 && indexPath.row == 4) {
            return 162
        } else {
            return 60
        }
    }
}

extension ProfileEditViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
    Tells the delegate that the user picked a still image or movie.
    
    :param: picker The controller object managing the image picker interface.
    :param: info   A dictionary containing the original image and the edited image, if an image was picked; or a filesystem URL for the movie, if a movie was picked. The dictionary also contains any relevant editing information. The keys for this dictionary are listed in Editing Information Keys.
    */
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.viewmodel.profileImage <~ MutableProperty<UIImage?>(pickedImage)
            self.profilePicture.image = pickedImage
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        self.tableView.reloadData()
        
    }
    
    /**
    Tells the delegate that the user cancelled the pick operation.
    
    :param: picker The controller object managing the image picker interface.
    */
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.tableView.reloadData()
    }
}

extension ProfileEditViewController : UITextFieldDelegate {
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
            textField.resignFirstResponder()
        if (textField === birthdayTextField) {
            self.view.endEditing(true)
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate : NSDate? = formatter.dateFromString(birthdayTextField.text)
            
            let dataChangedCallback : PopoverDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                self.birthdayTextField.text = dateFormatter.stringFromDate(newDate)
            }
            
            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            // Limit the choices on date picker
            let ageLimit = viewmodel.ageLimit
            var datePicker : UIDatePicker = popDatePicker!.datePickerVC.datePicker
            datePicker.minimumDate = ageLimit.floor
            datePicker.maximumDate = ageLimit.ceil
            self.viewmodel.birthday <~ datePicker.rac_date
            return false
        } else {
            return true
        }
    }
    
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        if (textField === phoneCell.textField || textField === emailCell.textField) {
            shouldAdjustForKeyboard = true
        }
    }
}

extension ProfileEditViewController : BirthdayCellTableViewCellDelegate {
    public func setUpBirthdayPopover (textField : UITextField) {
        birthdayTextField = textField
        if (popDatePicker == nil) {
            popDatePicker = PopoverDatePicker(forTextField: textField)
            
        }
    }
}