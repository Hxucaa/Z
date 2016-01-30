//
//  DescriptionCellViewModel.swift
//  XListing
//
//  Created by Bruce Li on 2015-09-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class DescriptionCellViewModel {

    // MARK: - Outputs
    public let description: ConstantProperty<String>
    
    // MARK: - Initializers
    public init(description: String?) {
        
        self.description = ConstantProperty("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
//        if let description = description {
//            self.description = MutableProperty(description)
//        } else {
//            self.description = MutableProperty("")
//        }
        
    }
}
