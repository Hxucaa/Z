//
//  ProfileEditFormViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2016-02-05.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import UIKit
import Foundation
import Eureka

public final class ProfileEditFormViewController : FormViewController, Component {
    
    // MARK: - Properties
    private let nickname: (old: String?, new: String? -> Void)
    private let profileImage: (old: UIImage?, new: UIImage? -> Void)
    private let whatsUp: (old: String?, new: String? -> Void)
//    private let nickname: FormField<String>
//    private let whatsUp: FormField<String>
//    private let profileImage: FormField<UIImage>
    
    // MARK: - Initializers
//    public init(nickname: FormField<String>, whatsUp: FormField<String>, profileImage: FormField<UIImage>) {
//        self.nickname = nickname
//        self.whatsUp = whatsUp
//        
//    }
    public init(nickname: (old: String?, new: String? -> Void), profileImage: (old: UIImage?, new: UIImage? -> Void), whatsUp: (old: String?, new: String? -> Void)) {
        self.nickname = nickname
        self.profileImage = profileImage
        self.whatsUp = whatsUp
        
        super.init(nibName: nil, bundle: nil)
    }
    

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 32.5
            cell.accessoryView?.frame = CGRectMake(0, 0, 65, 65)
        }
        
        form
            +++ Section()
                <<< ImageRow("头像") {
                    $0.title = "头像"
                    $0.value = self.profileImage.old
                }
                .cellSetup { (cell, row) in
                    cell.height = { 80 }
                }
                .onChange { [weak self] row in
                    self?.profileImage.new(row.value)
                }
            +++ Section()
                <<< TextFloatLabelRow("昵称") {
                        $0.title = "昵称"
                        $0.value = self.nickname.old
                    }
                    .cellSetup { (cell, row) -> () in
                        cell.textField.autocorrectionType = .No
                        cell.textField.autocapitalizationType = .None
                    }
                .onChange { [weak self] row in
                    self?.nickname.new(row.value)
                }
                <<< TextFloatLabelRow("What's Up") {
                    $0.title = "What's Up"
                    $0.value = self.whatsUp.old
                }
                .onChange { [weak self] row in
                    self?.whatsUp.new(row.value)
                }
    }

}