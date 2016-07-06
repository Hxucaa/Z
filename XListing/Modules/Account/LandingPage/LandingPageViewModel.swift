//
//  LandingPageViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-07-05.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class LandingPageViewModel : _BaseViewModel, ILandingPageViewModel, ViewModelInjectable {
    
    // MARK: - Outputs
    
    // MARK: - Properties
    // MARK: Services
    private let meRepository: IMeRepository
    
    // MARK: - Initializers
    typealias Dependency = (router: IRouter, meRepository: IMeRepository)
    
    typealias Token = Void
    
    typealias Input = (signUpTrigger: ControlEvent<Void>, logInTrigger: ControlEvent<Void>, skipAccountTrigger: ControlEvent<Void>?)
    
    init(dep: Dependency, token: Token, input: Input) {
        meRepository = dep.meRepository
        
        super.init(router: dep.router)
        
        input.signUpTrigger.asObservable()
            .subscribeNext { dep.router.toSignUp() }
            .addDisposableTo(disposeBag)
        
        input.logInTrigger.asObservable()
            .subscribeNext { dep.router.toLogIn() }
            .addDisposableTo(disposeBag)
        
        if let skipAccountTrigger = input.skipAccountTrigger {
            skipAccountTrigger.asObservable()
                .subscribeNext { dep.router.skipAccount() }
                .addDisposableTo(disposeBag)
        }
    }
}