//
//  ILogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-07-05.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ILogInViewModel {
    var formStatus: Observable<FormStatus> { get }
    var submissionEnabled: Observable<Bool> { get }
    func finishModule(callback: (CompletionHandler? -> ())?)
}