//
//  ProfileEditViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ActionSheetPicker_3_0

public final class ProfileEditViewController: XUIViewController, UINavigationBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var viewmodel: ProfileEditViewModel!
    private var shouldAdjustForKeyboard : Bool = false
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: UI Elements
    private var genderTitle: String!
    private var editButton: UIButton!
    private let imagePicker = UIImagePickerController()
    private var profilePicture: UIImageView!
    private var saveButton: UIBarButtonItem!
    
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
        setupNavBar()
        setupTableView()
        setupImagePicker()
        setUpProfilePicture()
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
        super.viewWillAppear(animated)
        setupKeyboard()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // dispose signals before view is disappeared
        view.endEditing(true)
    }
    
    public override func viewDidLayoutSubviews() {
        var viewBounds = self.view.bounds;
        let topBarOffset = CGFloat(64.0)
        viewBounds.origin.y = topBarOffset * -1;
        self.tableView.bounds = viewBounds;
    }
    
    public func bindToViewModel(viewmodel: ProfileEditViewModel) {
        self.viewmodel = viewmodel
    }
    
    // ends text editing and dismisses the keyboard
    public func endEditing(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Setups
    
    private func setupNavBar() {
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 64)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.clearColor()
        navigationBar.barTintColor = UIColor.x_PrimaryColor()
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.delegate = self;
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "编辑"
        
        // Create left and right button for navigation item
        let leftButton =  setupDismissButton()
        let rightButton = setupSaveButton()
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)

    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.reloadData()
    }
    
    private func setupSaveButton() -> UIBarButtonItem {

        let submitAction = Action<UIBarButtonItem, Void, NSError> { [weak self] button in
            return SignalProducer { observer, disposable in
                if let this = self {
                    
                    // display HUD to indicate work in progress
                    // check for the validity of inputs first
                    disposable += this.viewmodel.allInputsValid.producer
                        // on error displays error prompt
                        .on(next: { validity in
                            if !validity {
                                let alert = UIAlertController(title: "提交失败啦", message: "请填写昵称,性别,生日和上传一张照片😊", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
                                self?.presentViewController(alert, animated: true, completion: nil)
                                observer.sendNext(())
                                observer.sendCompleted()
                            }
                        })
                        // only valid inputs can continue through
                        .filter { $0 }
                        // delay the signal due to the animation of retracting keyboard
                        // this cannot be executed on main thread, otherwise UI will be blocked
                        .delay(Constants.HUD_DELAY, onScheduler: QueueScheduler())
                        // return the signal to main/ui thread in order to run UI related code
                        .observeOn(UIScheduler())
                        // show the HUD
                        .flatMap(FlattenStrategy.Latest) { _ in
                            return HUD.show()
                        }
                        // map error to the same type as other signal
                        .promoteErrors(NSError)
                        // update the DB with profile data
                        .flatMap(FlattenStrategy.Latest) { _ in
                            return this.viewmodel.updateProfile
                        }
                        // dismiss HUD based on the result of update profile signal
                        .on(failed: { error in
                            HUD.dismissWithFailedMessage()
                        })
                        // does not `sendCompleted` because completion is handled when HUD is disappeared
                        .start { event in
                            switch event {
                            case .Failed(let error):
                                ProfileLogError(error.description)
                                observer.sendFailed(error)
                            case .Interrupted:
                                observer.sendInterrupted()
                            default: break
                            }
                        }
                    
                    
                    // Subscribe to touch down inside event
                    disposable += HUD.didTouchDownInsideNotification()
                        .on(next: { _ in ProfileLogVerbose("HUD touch down inside.") })
                        .startWithNext { _ in
                            // dismiss HUD
                            HUD.dismiss()
                        }
                    
                    // Subscribe to disappear notification
                    disposable += HUD.didDissappearNotification()
                        .on(next: { _ in ProfileLogVerbose("HUD disappeared.") })
                        .startWithNext { status in
                            
                            // completes the action
                            observer.sendNext(())
                            observer.sendCompleted()
                            self?.dismissViewControllerAnimated(true, completion: nil)
                        }
                    
                    // Add the signals to CompositeDisposable for automatic memory management
                    disposable.addDisposable {
                        ProfileLogVerbose("Update profile action is disposed.")
                    }
                }
            }
        }

        
        saveButton = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Done, target: submitAction.unsafeCocoaAction, action: CocoaAction.selector)
        saveButton.tintColor = UIColor.whiteColor()
        return saveButton
    }
    
    private func setupDismissButton() -> UIBarButtonItem {
        let dismissAction = Action<UIBarButtonItem, Void, NoError> { [weak self]
            button in
            return SignalProducer { observer, disposable in
                self?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        let dismissButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: dismissAction.unsafeCocoaAction, action: CocoaAction.selector)
        dismissButton.tintColor = UIColor.whiteColor()
        return dismissButton
    }
    
    private func setupKeyboardDismissal() {
        // allow keyboard dismissal by tapping anywhere else on the screen
        let endEditingAction = Action<UITapGestureRecognizer, Void, NoError> { [weak self] gesture in
            return SignalProducer { observer, disposable in
                self?.view.endEditing(true)
                observer.sendCompleted()
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
    
    private func setupNicknameCell() {
        let nicknameCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow:Primary.Nickname.rawValue, inSection: Section.Primary.rawValue)) as! NicknameTableViewCell
        viewmodel.nickname <~ nicknameCell.getTextfield_rac_text()
    }
    
    private func setUpProfilePicture () {
        profilePicture = UIImageView(frame: CGRectMake(0, 0, 80, 80)) as UIImageView
        profilePicture.rac_image <~ viewmodel.profileImage
        profilePicture.layer.cornerRadius = CGFloat(self.profilePicture.frame.width) / 2
        profilePicture.layer.masksToBounds = true
        profilePicture.userInteractionEnabled = true
    }
    
    // setup keyboard to react to notifications
    private func setupKeyboard() {
        compositeDisposable += Keyboard.willShowNotification
            // forwards events until the view is going to disappear
            .startWithNext { [weak self] _ in
                let contentInsets = UIEdgeInsetsMake(0.0, 0.0, 224, 0.0)
                
                if let shouldAdjustForKeyboard = self?.shouldAdjustForKeyboard where shouldAdjustForKeyboard {
                    self?.tableView.contentInset = contentInsets
                    self?.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1), atScrollPosition: .Top, animated: true)
                    self?.tableView.scrollIndicatorInsets = contentInsets
                }
            }
        
        compositeDisposable += Keyboard.willHideNotification
            // forwards events until the view is going to disappear
            .startWithNext { [weak self] _ in
                    
                self?.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0)
                self?.tableView.contentInset = UIEdgeInsetsMake(64,0,0,0)
                self?.shouldAdjustForKeyboard = false
            }
    }
    
    deinit {
        compositeDisposable.dispose()
        ProfileLogVerbose("ProfileEditViewController deinitializes")
    }
    
    // MARK: Actions
    
    // Present an action sheet to choose between a profile picture 
    public func chooseProfilePictureSource() {
        let alert = UIAlertController(title: "选择上传方式", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let galleryAction = UIAlertAction(title: "在相册中选取", style: UIAlertActionStyle.Default) { UIAlertAction -> Void in
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let cameraAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { UIAlertAction -> Void in
            if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
                let noCameraAlert = UIAlertController(title: "This device does not have a camera", message: "", preferredStyle: UIAlertControllerStyle.Alert)
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
        
        // create the birthday action sheet
        let actionDatePicker = ActionSheetDatePicker(title: "生日", datePickerMode: UIDatePickerMode.Date, selectedDate: NSDate(timeInterval: 0, sinceDate: viewmodel.birthday.value), doneBlock: {
            picker, value, index in
            
            let birthdayData = value as! NSDate
            self.viewmodel.birthday.value = birthdayData
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            //update the cell with the chosen birthday
            birthdayCell.setTextfieldText(dateFormatter.stringFromDate(birthdayData))
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: self.view.superview)
        
        let ageLimit = viewmodel.ageLimit
        actionDatePicker.minimumDate = ageLimit.floor
        actionDatePicker.maximumDate = ageLimit.ceil
        
        //create custom buttons in order to change title to chinese
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        actionDatePicker.setCancelButton(cancelButton)
        actionDatePicker.setDoneButton(doneButton)
        
        actionDatePicker.showActionSheetPicker()
    }
    
    public func prepareToPresentGenderPopover () {
        view.endEditing(true)
        let genderCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow:Primary.Gender.rawValue, inSection: Section.Primary.rawValue)) as! GenderTableViewCell

        // create the gender action sheet
        let actionGenderPicker = ActionSheetStringPicker(title: "性别", rows: [Gender.Male.description, Gender.Female.description], initialSelection: 0, doneBlock: {
            picker, index, value in
            
            let genderData = value as! String
            genderCell.setTextfieldText(genderData)
            if index == 0 {
                self.viewmodel.gender.value = Gender.Male
            }
            else {
                self.viewmodel.gender.value = Gender.Female
            }
        
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: self.view.superview)
        
        //create custom buttons in order to change title to chinese
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "确定", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        actionGenderPicker.setCancelButton(cancelButton)
        actionGenderPicker.setDoneButton(doneButton)
        
        actionGenderPicker.showActionSheetPicker()
    }
}

// MARK: Table View

extension ProfileEditViewController: UITableViewDataSource, UITableViewDelegate {
    
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    - parameter tableView: The table-view object requesting this information.
    - parameter section:   An index number identifying a section in tableView.
    
    - returns: The number of rows in section.
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
    
    - parameter tableView: A table-view object requesting the cell.
    - parameter indexPath: An index path locating a row in tableView.
    
    - returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .Primary:
            switch Primary(rawValue: indexPath.row)! {
            case .Nickname:
                let nicknameCell = tableView.dequeueReusableCellWithIdentifier("NicknameCell") as! NicknameTableViewCell
                nicknameCell.delegate = self
                nicknameCell.setTextfieldText(viewmodel.nickname)
                nicknameCell.setUpEditProfileButton()
                viewmodel.nickname <~ nicknameCell.getTextfield_rac_text()
                return nicknameCell
            case .Gender:
                let genderCell = tableView.dequeueReusableCellWithIdentifier("GenderCell") as! GenderTableViewCell
                genderCell.delegate = self
                genderCell.setTextfieldText(viewmodel.gender.value!.description)
                genderCell.setUpEditProfileButton()
                return genderCell
            case .Birthday:
                let birthdayCell = tableView.dequeueReusableCellWithIdentifier("BirthdayCell") as! BirthdayTableViewCell
                birthdayCell.delegate = self
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                birthdayCell.setTextfieldText(dateFormatter.stringFromDate(viewmodel.birthday.value))
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
        let deviceWidth = UIScreen.mainScreen().bounds.size.width
        let profilePicView = UIView(frame: CGRectMake(deviceWidth-90, -245, 85, 100))
        if (profilePicture == nil) {
            profilePicture.image = UIImage(named: ImageAssets.profilepicture)
        }
        profilePicView.addSubview(self.profilePicture)
        
        let header: UITableViewHeaderFooterView =  UITableViewHeaderFooterView(frame: CGRectMake(100, 0, 100, 100))
        header.addSubview(profilePicView)
        return header
    }
    
    // Format the header title
    public func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.grayColor()
        header.textLabel?.font = UIFont.boldSystemFontOfSize(18)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = NSTextAlignment.Left
    }
}

// MARK: Image Picker

extension ProfileEditViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
    Tells the delegate that the user picked a still image or movie.
    
    - parameter picker: The controller object managing the image picker interface.
    - parameter info:   A dictionary containing the original image and the edited image, if an image was picked; or a filesystem URL for the movie, if a movie was picked. The dictionary also contains any relevant editing information. The keys for this dictionary are listed in Editing Information Keys.
    */
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            viewmodel.profileImage <~ MutableProperty<UIImage?>(pickedImage)
            profilePicture.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
        tableView.reloadData()
    }
    
    /**
    Tells the delegate that the user cancelled the pick operation.
    
    - parameter picker: The controller object managing the image picker interface.
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
