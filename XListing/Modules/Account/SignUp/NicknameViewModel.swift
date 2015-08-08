//
//  NicknameViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class NicknameViewModel {
    
    // MARK: - Input
    public let nickname = MutableProperty<String?>(nil)
    
    // MARK: - Output
    public let isNicknameValid = MutableProperty<Bool>(false)
    
    // MARK: - Variables
    /// Signal containing a valid username
    public private(set) var validNicknameSignal: SignalProducer<String, NoError>!
    
    
    // MARK: - Initializers
    public init() {
        setupNickname()
    }
    
    // MARK: - Setups
    private func setupNickname() {
        // only allow usernames with:
        // - between 3 and 30 characters
        // - letters, numbers, dashes, periods, and underscores only
        validNicknameSignal = nickname.producer
            |> ignoreNil
            |> filter { count($0) > 1 && count($0) <= 30 }
        
        isNicknameValid <~ validNicknameSignal
            |> map { _ in true }
    }
    
    // MARK: - Others
}