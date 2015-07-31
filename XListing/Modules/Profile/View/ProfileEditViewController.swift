//
//  ProfileEditViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

public final class ProfileEditViewController: XUIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var viewmodel: ProfileEditViewModel!
    private var shouldAdjustForKeyboard : Bool = false
    
    // MARK: UI Elements
    private var genderTitle: String!
    private var editButton: UIButton!
    private let imagePicker = UIImagePickerController()
    private var profilePicture: UIImageView!
    private var popDatePicker : PopoverDatePicker?
    private var popGenderPicker : GenderPicker?
    private var birthdayTextField : UITextField!
    private var genderTextField : UITextField!
    
    // MARK: Enums
    private enum Section : Int {
        case Primary, 隐私信息
    }
    
    private enum Primary : Int {
        case Nickname, Gender, Birthday, Whatsup
    }
    
    private enum 隐私信息 : Int {
        case Email, Phone
    }
    
    // MARK: View Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupImagePicker()
        setUpProfilePicture()
        setupDismissButton()
        setupSaveButton()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // allow keyboard dismissal by tapping anywhere else on the screen
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "endEditing:")
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
        // dismisses the keyboard and remove keyboard observers before dismissing the view
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.view.endEditing(true)
    }
    
    public func bindToViewModel(viewmodel: ProfileEditViewModel) {
        self.viewmodel = viewmodel
    }
    
    // ends text editing and dismisses the keyboard
    public func endEditing(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - Setup Code
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.reloadData()
    }
    
    private func setupSaveButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Done, target: self, action: "saveAction")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    private func setupDismissButton() {
        var dismissButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "dismissView")
        dismissButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = dismissButton
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    private func setUpProfilePicture () {
        self.profilePicture = UIImageView(frame: CGRectMake(0, 0, 80, 80)) as UIImageView
        var myImage: UIImage = UIImage(data: viewmodel.currentUser.value!.profileImg!.getData())!
        viewmodel.profileImage.put(myImage)
        self.profilePicture.image = myImage
        self.profilePicture.layer.cornerRadius = CGFloat(self.profilePicture.frame.width) / 2
        self.profilePicture.layer.masksToBounds = true
        self.profilePicture.userInteractionEnabled = true
    }
    
    // MARK: Actions
    
    // Present an action sheet to choose between a profile picture 
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
    
    public func saveAction() {
        // Check if all required fields are complete
        if (viewmodel.allInputsValid.value) {
            // Create the button action to update the fields in the DB with new data
            let submitAction = Action<UIBarButtonItem, Bool, NSError> { [weak self] button in
                let updateProfileAndHUD = HUD.show()
                    |> mapError { _ in NSError() }
                    |> then(self!.viewmodel.updateProfile)
                    // dismiss HUD based on the result of update profile signal
                    |> HUD.dismissWithStatusMessage(errorHandler: { error -> String in
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
            // popup alert to the user to fill out all the required fields
            var alert = UIAlertController(title: "提交失败啦", message: "请填写昵称,性别,生日和上传一张照片😊", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    public func presentUIImagePicker () {
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
    }

    // MARK: Keyboard Methods
    
    // registers the notifications for keyboard reactions
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
    
    public func prepareToPresentDatePopover () {
        // dismiss keyboard
        self.view.endEditing(true)
        // set up date formatting style in the popover
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        
        // start the date picker with the most recently chosen value if it exists
        let initDate : NSDate? = formatter.dateFromString(birthdayTextField.text)
        
        let dataChangedCallback : PopoverDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
            // set the date format in the text field
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.birthdayTextField.text = dateFormatter.stringFromDate(newDate)
        }
        // present the popover
        popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
        // Limit the choices on date picker based on age
        let ageLimit = viewmodel.ageLimit
        var datePicker : UIDatePicker = popDatePicker!.datePickerVC.datePicker
        datePicker.minimumDate = ageLimit.floor
        datePicker.maximumDate = ageLimit.ceil
        self.viewmodel.birthday <~ datePicker.rac_date
    }
    
    public func prepareToPresentGenderPopover () {
        self.view.endEditing(true)
        
        let dataChangedCallback : GenderPicker.GenderCallback = { (gender : String, forTextField : UITextField) -> () in
            self.genderTextField.text = gender
            if (gender == "男") {
                self.viewmodel.gender.put(Gender.Male)
            } else if (gender == "女"){
                self.viewmodel.gender.put(Gender.Female)
            }
        }
        // present the popover
        popGenderPicker!.pick(self, initGender: genderTextField.text, dataChanged: dataChangedCallback)
    }
}

// MARK: Table View

extension ProfileEditViewController: UITableViewDataSource, UITableViewDelegate {
    
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue:section)! {
        case .Primary: return 4
        case .隐私信息: return 2
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
        switch Section(rawValue: indexPath.section)! {
        case .Primary:
            switch Primary(rawValue: indexPath.row)! {
            case .Nickname:
                var nicknameCell = tableView.dequeueReusableCellWithIdentifier("NicknameCell") as! NicknameTableViewCell
                nicknameCell.delegate = self
                nicknameCell.textField.text = viewmodel.currentUser.value?.nickname
                nicknameCell.setUpEditProfileButton()
                viewmodel.nickname <~ nicknameCell.textField.rac_text
                return nicknameCell
            case .Gender:
                var genderCell = tableView.dequeueReusableCellWithIdentifier("GenderCell") as! GenderTableViewCell
                genderCell.delegate = self
                var existingGender = viewmodel.currentUser.value?.gender
                if (existingGender != nil) {
                    genderCell.textField.text = viewmodel.currentUser.value?.gender
                    existingGender == "男" ? viewmodel.gender.put(Gender.Male) : viewmodel.gender.put(Gender.Female)
                }
                genderCell.setUpEditProfileButton()
                return genderCell
            case .Birthday:
                var birthdayCell = tableView.dequeueReusableCellWithIdentifier("BirthdayCell") as! BirthdayTableViewCell
                birthdayCell.delegate = self
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                var existingBirthday : NSDate = viewmodel.currentUser.value!.birthday!
                birthdayCell.birthdayTextField.text = dateFormatter.stringFromDate(existingBirthday)
                viewmodel.birthday.put(existingBirthday)
                return birthdayCell
            case .Whatsup:
                var whatsupCell = tableView.dequeueReusableCellWithIdentifier("WhatsupCell") as! WhatsupTableViewCell
                return whatsupCell
            }
        case .隐私信息:
            switch 隐私信息(rawValue: indexPath.row)! {
            case .Email:
                var emailCell = tableView.dequeueReusableCellWithIdentifier("PhoneEmailCell") as! PhoneEmailTableViewCell
                emailCell.delegate = self
                emailCell.initialize("Email")
                return emailCell
            case .Phone:
                var phoneCell = tableView.dequeueReusableCellWithIdentifier("PhoneEmailCell") as! PhoneEmailTableViewCell
                phoneCell.delegate = self
                phoneCell.initialize("Phone")
                return phoneCell
            }
        }
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Section.隐私信息.rawValue {return "隐私信息"} else {return ""}
    }
    
    // Add the profile picture thumbnail to the proper position in between nickname and gender cells
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        // Adjust the positioning based on the width of the device
        var deviceWidth = UIScreen.mainScreen().bounds.size.width
        var profilePicView: UIView = UIView(frame: CGRectMake(deviceWidth-90, -245, 85, 100))
        profilePicView.addSubview(self.profilePicture)
        
        let header: UITableViewHeaderFooterView =  UITableViewHeaderFooterView(frame: CGRectMake(100, 0, 100, 100))
        header.addSubview(profilePicView)
        return header
    }
    
    // Format the header title
    public func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel.textColor = UIColor.grayColor()
        header.textLabel.font = UIFont.boldSystemFontOfSize(18)
        header.textLabel.frame = header.frame
        header.textLabel.textAlignment = NSTextAlignment.Left
    }
}

// MARK: Image Picker

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

// MARK: Cell Delegates

extension ProfileEditViewController : BirthdayCellTableViewCellDelegate {
    public func setUpBirthdayPopover (textField : UITextField) {
        birthdayTextField = textField
        if (popDatePicker == nil) {
            popDatePicker = PopoverDatePicker(forTextField: textField)
        }
    }
    
    public func presentBirthdayPopover() {
        prepareToPresentDatePopover()
    }
}

extension ProfileEditViewController : GenderCellTableViewCellDelegate {
    public func setUpGenderPopover (textField : UITextField) {
        genderTextField = textField
        if (popGenderPicker == nil) {
            popGenderPicker = GenderPicker(forTextField: textField)
        }
    }
    
    public func editPictureButtonAction () {
        chooseProfilePictureSource()
    }
    
    public func presentGenderPopover() {
        prepareToPresentGenderPopover()
    }
}

extension ProfileEditViewController : NicknameCellTableViewCellDelegate {
    public func editPictureTextButtonAction () {
        chooseProfilePictureSource()
    }
}

extension ProfileEditViewController : PhoneEmailCellTableViewCellDelegate {
    public func notifyTextFieldBeginEditing() {
        shouldAdjustForKeyboard = true
    }
}
