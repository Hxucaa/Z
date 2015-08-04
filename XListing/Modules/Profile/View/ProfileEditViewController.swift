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
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: UI Elements
    private var genderTitle: String!
    private var editButton: UIButton!
    private let imagePicker = UIImagePickerController()
    private var profilePicture: UIImageView!
    
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
        setupKeyboardDismissal()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewWillAppear(animated: Bool) {
        setupKeyboard()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        // dispose signals before view is disappeared
        view.endEditing(true)
    }
    
    public func bindToViewModel(viewmodel: ProfileEditViewModel) {
        self.viewmodel = viewmodel
    }
    
    // ends text editing and dismisses the keyboard
    public func endEditing(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Setups
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.reloadData()
    }
    
    private func setupSaveButton() {
        let saveAction = Action<UIBarButtonItem, Void, NoError> { [weak self]
            button in
            return SignalProducer { sink, disposable in
                // Check if all required fields are complete
                if (self!.viewmodel.allInputsValid.value) {
                    // Create the button action to update the fields in the DB with new data
                    // Button action
                    let submitAction = Action<UIBarButtonItem, Void, NSError> { [weak self] button in
                        return SignalProducer { sink, disposable in
                            if let this = self {
                                
                                // Update profile and show the HUD
                                disposable += SignalProducer<Void, NoError>.empty
                                    // delay the signal due to the animation of retracting keyboard
                                    // this cannot be executed on main thread, otherwise UI will be blocked
                                    |> delay(Constants.HUD_DELAY, onScheduler: QueueScheduler())
                                    // return the signal to main/ui thread in order to run UI related code
                                    |> observeOn(UIScheduler())
                                    |> then(HUD.show())
                                    // map error to the same type as other signal
                                    |> promoteErrors(NSError)
                                    // update profile
                                    |> then(this.viewmodel.updateProfile)
                                    // dismiss HUD based on the result of update profile signal
                                    |> HUD.dismissWithStatusMessage(errorHandler: { error -> String in
                                        ProfileLogError(error.description)
                                        return error.customErrorDescription
                                    })
                                    // does not `sendCompleted` because completion is handled when HUD is disappeared
                                    |> start(
                                        error: { error in
                                            sendError(sink, error)
                                        },
                                        interrupted: { _ in
                                            sendInterrupted(sink)
                                        }
                                )
                                
                                // Subscribe to touch down inside event
                                disposable += HUD.didTouchDownInsideNotification()
                                    |> on(next: { _ in ProfileLogVerbose("HUD touch down inside.") })
                                    |> start(
                                        next: { _ in
                                            // dismiss HUD
                                            HUD.dismiss()
                                        }
                                )
                                
                                // Subscribe to disappear notification
                                disposable += HUD.didDissappearNotification()
                                    |> on(next: { _ in ProfileLogVerbose("HUD disappeared.") })
                                    |> start(next: { status in
                                        
                                        // completes the action
                                        sendNext(sink, ())
                                        sendCompleted(sink)
                                        self?.dismissViewControllerAnimated(true, completion: nil)
                                    })
                                
                                // Add the signals to CompositeDisposable for automatic memory management
                                disposable.addDisposable {
                                    ProfileLogVerbose("Update profile action is disposed.")
                                }
                                
                                
                            }
                        }
                    }
                    submitAction.unsafeCocoaAction.execute(self!.navigationItem.rightBarButtonItem!)
                } else {
                    // popup alert to the user to fill out all the required fields
                    var alert = UIAlertController(title: "提交失败啦", message: "请填写昵称,性别,生日和上传一张照片😊", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
                    self!.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Done, target: saveAction.unsafeCocoaAction, action: CocoaAction.selector)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    private func setupDismissButton() {
        let dismissAction = Action<UIBarButtonItem, Void, NoError> { [weak self]
            button in
            return SignalProducer { sink, disposable in
                self?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        var dismissButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: dismissAction.unsafeCocoaAction, action: CocoaAction.selector)
        dismissButton.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = dismissButton
    }
    
    private func setupKeyboardDismissal() {
        // allow keyboard dismissal by tapping anywhere else on the screen
        let endEditingAction = Action<UITapGestureRecognizer, Void, NoError> { [weak self] gesture in
            return SignalProducer { sink, disposable in
                view.endEditing(true)
            }
        }
        let tapRecognizer = UITapGestureRecognizer(target: endEditingAction.unsafeCocoaAction, action: CocoaAction.selector)
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    private func setUpProfilePicture () {
        profilePicture = UIImageView(frame: CGRectMake(0, 0, 80, 80)) as UIImageView
        var myImage: UIImage = UIImage(data: viewmodel.currentUser.value!.profileImg!.getData())!
        viewmodel.profileImage.put(myImage)
        profilePicture.image = myImage
        profilePicture.layer.cornerRadius = CGFloat(self.profilePicture.frame.width) / 2
        profilePicture.layer.masksToBounds = true
        profilePicture.userInteractionEnabled = true
    }
    
    // setup keyboard to react to notifications
    private func setupKeyboard() {
        compositeDisposable += Keyboard.willShowNotification
            // forwards events until the view is going to disappear
            |> start(
                next: { [weak self] _ in
                    var contentInsets:UIEdgeInsets
                    var deviceWidth = UIScreen.mainScreen().bounds.size.width
                    contentInsets = UIEdgeInsetsMake(0.0, 0.0, 224, 0.0)
                    
                    if let shouldAdjustForKeyboard = self?.shouldAdjustForKeyboard where shouldAdjustForKeyboard {
                        self?.tableView.contentInset = contentInsets
                        self?.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1), atScrollPosition: .Top, animated: true)
                        self?.tableView.scrollIndicatorInsets = contentInsets
                    }
                }
            )
        
        compositeDisposable += Keyboard.willHideNotification
            // forwards events until the view is going to disappear
            |> start(
                next: { [weak self] _ in
                    
                    self?.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0)
                    self?.tableView.contentInset = UIEdgeInsetsMake(64,0,0,0)
                    self?.shouldAdjustForKeyboard = false
                }
            )
    }
    
    deinit {
        compositeDisposable.dispose()
        ProfileLogVerbose("ProfileEditViewController deinitializes")
    }
    
    // MARK: Actions
    
    // Present an action sheet to choose between a profile picture 
    public func chooseProfilePictureSource() {
        var alert = UIAlertController(title: "选择上传方式", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        var galleryAction = UIAlertAction(title: "在相册中选取", style: UIAlertActionStyle.Default) { UIAlertAction -> Void in
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        var cameraAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { UIAlertAction -> Void in
            if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
                var noCameraAlert = UIAlertController(title: "This device does not have a camera", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                noCameraAlert.addAction(cancelAction)
                self.presentViewController(noCameraAlert, animated: true, completion: nil)
            } else {
                self.imagePicker.sourceType = .Camera
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
        }

        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    public func prepareToPresentDatePopover () {
        // dismiss keyboard
        view.endEditing(true)
        
        let birthdayCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow:Primary.Birthday.rawValue, inSection: Section.Primary.rawValue)) as! BirthdayTableViewCell
        
        // set up date formatting style in the popover
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .NoStyle
        
        // start the date picker with the most recently chosen value if it exists
        let initDate : NSDate? = formatter.dateFromString(birthdayCell.getTextfieldText())
        
        let dataChangedCallback : PopoverDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
            // set the date format in the text field
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            birthdayCell.setTextfieldText(dateFormatter.stringFromDate(newDate))
        }
        // present the popover
        birthdayCell.popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
        // Limit the choices on date picker based on age
        let ageLimit = viewmodel.ageLimit
        var datePicker : UIDatePicker = birthdayCell.popDatePicker!.datePickerVC.datePicker
        datePicker.minimumDate = ageLimit.floor
        datePicker.maximumDate = ageLimit.ceil
        viewmodel.birthday <~ datePicker.rac_date
    }
    
    public func prepareToPresentGenderPopover () {
        view.endEditing(true)
        let genderCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow:Primary.Gender.rawValue, inSection: Section.Primary.rawValue)) as! GenderTableViewCell
        
        let dataChangedCallback : GenderPicker.GenderCallback = { (gender : String, forTextField : UITextField) -> () in
            genderCell.setTextfieldText(gender)
            if (gender == "男") {
                self.viewmodel.gender.put(Gender.Male)
            } else if (gender == "女"){
                self.viewmodel.gender.put(Gender.Female)
            }
        }

        // present the popover
        genderCell.popGenderPicker!.pick(self, initGender: genderCell.getTextfieldText(), dataChanged: dataChangedCallback)
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
                let nicknameCell = tableView.dequeueReusableCellWithIdentifier("NicknameCell") as! NicknameTableViewCell
                nicknameCell.delegate = self
                nicknameCell.setTextfieldText(viewmodel.currentUser.value!.nickname!)
                nicknameCell.setUpEditProfileButton()
                viewmodel.nickname <~ nicknameCell.getTextfield_rac_text()
                return nicknameCell
            case .Gender:
                let genderCell = tableView.dequeueReusableCellWithIdentifier("GenderCell") as! GenderTableViewCell
                genderCell.delegate = self
                var existingGender = viewmodel.currentUser.value?.gender
                if (existingGender != nil) {
                genderCell.setTextfieldText(viewmodel.currentUser.value!.gender!)
                    existingGender == "男" ? viewmodel.gender.put(Gender.Male) : viewmodel.gender.put(Gender.Female)
                }
                genderCell.setUpEditProfileButton()
                return genderCell
            case .Birthday:
                let birthdayCell = tableView.dequeueReusableCellWithIdentifier("BirthdayCell") as! BirthdayTableViewCell
                birthdayCell.delegate = self
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                var existingBirthday : NSDate = viewmodel.currentUser.value!.birthday!
                birthdayCell.setTextfieldText(dateFormatter.stringFromDate(existingBirthday))
                viewmodel.birthday.put(existingBirthday)
                return birthdayCell
            case .Whatsup:
                let whatsupCell = tableView.dequeueReusableCellWithIdentifier("WhatsupCell") as! WhatsupTableViewCell
                return whatsupCell
            }
        case .隐私信息:
            switch 隐私信息(rawValue: indexPath.row)! {
            case .Email:
                let emailCell = tableView.dequeueReusableCellWithIdentifier("PhoneEmailCell") as! PhoneEmailTableViewCell
                emailCell.delegate = self
                emailCell.initialize("Email")
                return emailCell
            case .Phone:
                let phoneCell = tableView.dequeueReusableCellWithIdentifier("PhoneEmailCell") as! PhoneEmailTableViewCell
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
        var profilePicView = UIView(frame: CGRectMake(deviceWidth-90, -245, 85, 100))
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
            viewmodel.profileImage <~ MutableProperty<UIImage?>(pickedImage)
            profilePicture.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
    }
    
    /**
    Tells the delegate that the user cancelled the pick operation.
    
    :param: picker The controller object managing the image picker interface.
    */
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
    }
}

// MARK: Cell Delegates

extension ProfileEditViewController : BirthdayCellTableViewCellDelegate {

    public func presentBirthdayPopover() {
        prepareToPresentDatePopover()
    }
}

extension ProfileEditViewController : GenderCellTableViewCellDelegate {
    
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
