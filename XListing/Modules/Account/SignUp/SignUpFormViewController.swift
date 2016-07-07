//
//  SignUpFormViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2016-07-06.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Eureka

final class SignUpFormViewController : FormViewController {
    
    // MARK: - UI Controls
    
    // MARK: - Outputs
    let outputs = (
        username: PublishSubject<String?>(),
        password: PublishSubject<String?>(),
        nickname: PublishSubject<String?>(),
        birthday: PublishSubject<NSDate?>(),
        gender: PublishSubject<Gender?>(),
        profileImage: PublishSubject<UIImage?>()
    )
    
    // MARK: - Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 32.5
            cell.accessoryView?.frame = CGRectMake(0, 0, 65, 65)
        }
    }
    
    func bindToData(minimumDate: NSDate, maximumDate: NSDate) {
        form
            +++ Section()
            <<< AccountRow("用户名") {
                $0.title = "用户名"
                }
                .onChange { [weak self] row in
                    self?.outputs.username.onNext(row.value)
            }
            <<< PasswordRow("密码") {
                $0.title = "密码"
                }
                .onChange { [weak self] row in
                    self?.outputs.password.onNext(row.value)
            }
            <<< ImageRow("头像") {
                $0.title = "头像"
                $0.value = UIImage(asset: UIImage.Asset.Profilepicture)
                }
                .cellSetup { (cell, row) in
                    cell.height = { 80 }
                }
                .onChange { [weak self] row in
                    self?.outputs.profileImage.onNext(row.value)
            }
            <<< NameRow("昵称") {
                $0.title = "昵称"
                }
                .onChange { [weak self] row in
                    self?.outputs.nickname.onNext(row.value)
            }
            <<< DateInlineRow() {
                $0.title = "生日"
                $0.value = minimumDate
                $0.minimumDate = minimumDate
                $0.maximumDate = maximumDate
                }
                .onChange { [weak self] row in
                    self?.outputs.birthday.onNext(row.value)
            }
            <<< SegmentedRow<String>() {
                $0.title = "性别"
                $0.options = ["男", "女"]
                }
                .onChange { [weak self] row in
                    
                    if row.value == "男" {
                        self?.outputs.gender.onNext(Gender.Male)
                    }
                    else {
                        self?.outputs.gender.onNext(Gender.Female)
                    }
        }
    }
}
