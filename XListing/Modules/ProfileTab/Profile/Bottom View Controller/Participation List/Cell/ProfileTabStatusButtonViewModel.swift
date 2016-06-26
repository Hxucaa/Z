////
////  ProfileTabStatusButtonViewModel.swift
////  XListing
////
////  Created by Anson on 2015-10-25.
////  Copyright (c) 2016 Lance Zhu. All rights reserved.
////
//
//import ReactiveCocoa
//
//public class ProfileTabStatusButtonViewModel: IProfileTabStatusButtonViewModel {
//    
//    // MARK: - Inputs
//    
//    // MARK: - Outputs
//    
//    private let _type: MutableProperty<String>
//    public var type: AnyProperty<String> {
//        return AnyProperty(_type)
//    }
//    
//    // MARK: - Properties
//    
//    // MARK: - Initializers
//    public required init(type: EventType?) {
//        if let type = type {
//            _type = MutableProperty(type.description)
//        }
//        else {
//            _type = MutableProperty("")
//        }
//    }
//    
//    // MARK: - API
//}
