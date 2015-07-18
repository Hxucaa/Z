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
    private var birthdayTitle: String!
    private var editButton: UIButton!
    private let imagePicker = UIImagePickerController()
    private var profilePicture: UIImageView!
    private var didExpandDatePicker: Bool = false
    private var dateFormatter: NSDateFormatter!

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePicker()
        setUpProfilePicture()
        setupDismissButton()
        setupSaveButton()

        // Do any additional setup after loading the view.
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewDidAppear(animated: Bool) {
        setupTableView()
    }
    
    public func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.tableView.reloadData()
    }
    
    public func setUpDateFormatter() {
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    }
    
    public func chooseGender() {
        var alert = UIAlertController(title: "Choose a gender", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        var maleAction = UIAlertAction(title: "男", style: UIAlertActionStyle.Default) { UIAlertAction -> Void in
            self.viewmodel.gender.put(Gender.Male)
            self.genderTitle = "男"
            self.tableView.reloadData()
        }
        var femaleAction = UIAlertAction(title: "女", style: UIAlertActionStyle.Default) { UIAlertAction -> Void in
            self.viewmodel.gender.put(Gender.Female)
            self.genderTitle = "女"
            self.tableView.reloadData()
            }
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(maleAction)
        alert.addAction(femaleAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    public func dismissView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setupSaveButton() {
        // Button action
        let submitAction = Action<UIBarButtonItem, Bool, NSError> { [unowned self] button in
            let updateProfileAndHUD = HUD.show()
                |> mapError { _ in NSError() }
                |> then(self.viewmodel.updateProfile)
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
                    self.dismissViewControllerAnimated(true, completion: nil)
                    return success
            }
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: UIBarButtonItemStyle.Done, target: submitAction.unsafeCocoaAction, action: CocoaAction.selector)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
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
        imagePicker.sourceType = .PhotoLibrary
    }
    
    public func presentUIImagePicker () {
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    private func setUpProfilePicture () {
        self.profilePicture = UIImageView(frame: CGRectMake(0, 0, 75, 75)) as UIImageView
        var myImage: UIImage = UIImage(named: "curry")!
        self.profilePicture.image = myImage
        self.profilePicture.layer.cornerRadius = CGFloat(self.profilePicture.frame.width) / 2
        self.profilePicture.layer.masksToBounds = true
    }
    
    public func chooseBirthday () {
        didExpandDatePicker = !didExpandDatePicker
        self.tableView.reloadData()
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
            case 0:
                if (didExpandDatePicker) {return 5 } else { return 4}
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
        var labelCell = tableView.dequeueReusableCellWithIdentifier("TextCell") as! TextFieldTableViewCell
        var genderCell = tableView.dequeueReusableCellWithIdentifier("GenderCell") as! GenderTableViewCell
        var birthdayCell = tableView.dequeueReusableCellWithIdentifier("BirthdayCell") as! BirthdayTableViewCell
        var datePickerCell = tableView.dequeueReusableCellWithIdentifier("DatePicker") as! DatePickerTableViewCell
        
        switch (indexPath.section) {
            case 0:
                switch(indexPath.row) {
                case 0:
                    labelCell.icon.text = UserIcon
                    labelCell.textField.placeholder = "昵称"
                    viewmodel.nickname <~ labelCell.textField.rac_text
                    
                case 1:
                    genderCell.genderIcon.text = GenderIcon
                    if (genderTitle == nil) {
                        genderTitle = "性别"
                    } else {
                        genderCell.genderButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                    }
                    genderCell.genderButton.setTitle(genderTitle, forState: UIControlState.Normal)
                    genderCell.genderButton.addTarget(self, action: "chooseGender", forControlEvents: UIControlEvents.TouchUpInside)
                    genderCell.editProfilePicButton.addTarget(self, action: "presentUIImagePicker", forControlEvents: UIControlEvents.TouchUpInside)
                    return genderCell
                case 2:
                    labelCell.icon.text = StatusIcon
                    labelCell.textField.placeholder = "心情"
                    
                case 3:
                    birthdayCell.icon.text = BirthdayIcon
                    //TODO: allow label to change based on selected bday
                    //birthdayTitle = dateFormatter.stringFromDate(viewmodel.birthday.value)
                    if (birthdayTitle == nil) {
                        birthdayTitle = "生日"
                    } else {
                        birthdayCell.birthdayButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                    }
                    birthdayCell.birthdayButton.setTitle(birthdayTitle, forState: UIControlState.Normal)
                    birthdayCell.birthdayButton.addTarget(self, action: "chooseBirthday", forControlEvents: UIControlEvents.TouchUpInside)
                    return birthdayCell
                case 4:
                    // React to date change
                    viewmodel.birthday <~ datePickerCell.datePicker.rac_date
                    
                    // Limit the choices on date picker
                    let ageLimit = viewmodel.ageLimit
                    datePickerCell.datePicker.minimumDate = ageLimit.floor
                    datePickerCell.datePicker.maximumDate = ageLimit.ceil
                    return datePickerCell
                default : print("error rendering cell")
                }
            case 1:
                switch(indexPath.row) {
                case 0:
                    labelCell.icon.text = EmailIcon
                    labelCell.textField.placeholder = "邮件"
                case 1:
                    labelCell.icon.text = PhoneIcon
                    labelCell.textField.placeholder = "电话"
                default: print("error rendering cell")
            }
            default: print("error rendering cell")
        }
        
        return labelCell
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {return "隐私信息"} else {return ""}
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var deviceWidth = UIScreen.mainScreen().bounds.size.width
        var picYCoord: CGFloat
        if (didExpandDatePicker) {picYCoord = -397} else {picYCoord = -235}
        var profilePicView: UIView = UIView(frame: CGRectMake(deviceWidth-100, picYCoord, 75, 100))
        profilePicView.addSubview(self.profilePicture)
        
        let header: UITableViewHeaderFooterView =  UITableViewHeaderFooterView(frame: CGRectMake(100, 0, 100, 100))
        header.addSubview(profilePicView)
        return header
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
            self.tableView.reloadData()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    /**
    Tells the delegate that the user cancelled the pick operation.
    
    :param: picker The controller object managing the image picker interface.
    */
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

