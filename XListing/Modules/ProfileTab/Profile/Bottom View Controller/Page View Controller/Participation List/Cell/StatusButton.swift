////
////  StatusButton.swift
////  XListing
////
////  Created by Anson on 2015-10-25.
////  Copyright (c) 2015 ZenChat. All rights reserved.
////
//
//import UIKit
//import ReactiveCocoa
//
//public class StatusButton: UIButton {
//    
//    // MARK: - UI Controls
//    
//    // MARK: - Properties
//    private var viewmodel: ProfileTabStatusButtonViewModel?
//    
//    // MARK: - Initializers
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        setup()
//    }
//    
//    public required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        setup()
//    }
//    
//    // MARK: - Setups
//    private func setup() {
//        self.backgroundColor = .x_ProfileTableBG()
//        
//    }
//    
//    // MARK: - Bindings
//    public func bindToViewModel(viewmodel: ProfileTabStatusButtonViewModel) {
//        self.viewmodel = viewmodel
//        
//        viewmodel.type.producer
//            .startWithNext { [weak self] type in
//                self?.setTitle(type, forState: .Normal)
//            }
//        
//    }
//    
//    // MARK: - Others
//    
//}
