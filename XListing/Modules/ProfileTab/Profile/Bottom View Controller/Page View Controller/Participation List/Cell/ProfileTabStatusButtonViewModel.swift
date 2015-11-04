//
//  ProfileTabStatusButtonViewModel.swift
//  XListing
//
//  Created by Anson on 2015-10-25.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import ReactiveCocoa

public class ProfileTabStatusButtonViewModel: IProfileTabStatusButtonViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    private let _type: MutableProperty<String>
    public var type: PropertyOf<String> {
        return PropertyOf(_type)
    }
    
    // MARK: - Properties
    
    // MARK: - Initializers
    public required init(type: ParticipationType?) {
        if let type = type {
            _type = MutableProperty(type.description)
        }
        else {
            _type = MutableProperty("")
        }
    }
    
    // MARK: - API
}
