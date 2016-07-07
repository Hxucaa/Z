//
//  ProfileEditFormViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2016-02-05.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import UIKit
import Foundation
import Eureka
import RxSwift

final class ProfileEditFormViewController : FormViewController {
    
    // MARK: - Properties
    private var nickname: String?
    private var profileImage: UIImage?
    private var whatsUp: String?
    
    // MARK: - Outputs
    let nicknameInput = PublishSubject<String>()
    let whatsUpInput = PublishSubject<String>()
    let profileImageInput = PublishSubject<UIImage>()
    
    
    // MARK: - Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 32.5
            cell.accessoryView?.frame = CGRectMake(0, 0, 65, 65)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    func bindToData(nickname: String?, profileImage: UIImage?, whatsUp: String?) {
        self.nickname = nickname
        self.profileImage = profileImage
        self.whatsUp = whatsUp
        
        
        
        form
            +++ Section()
            <<< ImageRow("头像") {
                $0.title = "头像"
                $0.value = self.profileImage
                }
                .cellSetup { (cell, row) in
                    cell.height = { 80 }
                }
                .onChange { [weak self] row in
                    self?.profileImageInput.onNext(row.value ?? UIImage())
            }
            +++ Section()
            <<< TextFloatLabelRow("昵称") {
                $0.title = "昵称"
                $0.value = self.nickname
                }
                .cellSetup { (cell, row) -> () in
                    cell.textField.autocorrectionType = .No
                    cell.textField.autocapitalizationType = .None
                }
                .onChange { [weak self] row in
                    self?.nicknameInput.onNext(row.value ?? "")
            }
            <<< TextFloatLabelRow("What's Up") {
                $0.title = "What's Up"
                $0.value = self.whatsUp
                }
                .onChange { [weak self] row in
                    self?.whatsUpInput.onNext(row.value ?? "")
        }
    }
}