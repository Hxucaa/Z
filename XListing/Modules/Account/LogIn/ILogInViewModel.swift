//
//  ILogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-28.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

protocol ILogInViewModel {
    var usernameAndPasswordViewModel: UsernameAndPasswordViewModel { get }
    var logIn: SignalProducer<Bool, NetworkError> { get }
    func finishModule(callback: (CompletionHandler? -> ())?)
}