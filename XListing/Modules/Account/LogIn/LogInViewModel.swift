//
//  LogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-07-05.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class LogInViewModel : _BaseViewModel, ILogInViewModel, ViewModelInjectable {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var formStatus: Observable<FormStatus> {
        return form.status
    }
    var submissionEnabled: Observable<Bool> {
        return form.submissionEnabled
    }
    
    // MARK: - Properties
    private enum FieldName : String {
        case Username = "Username"
        case Password = "Password"
    }
    private let form: Form
    private let usernameAndPasswordValidator: UsernameAndPasswordValidator
    
    // MARK: - Services
    private let meRepository: IMeRepository
    
    // MARK: - Initializers
    typealias Dependency = (router: IRouter, meRepository: IMeRepository)
    
    typealias Token = Void
    
    typealias Input = (username: ControlProperty<String>, password: ControlProperty<String>, submitTrigger: ControlEvent<Void>)
    
    init(dep: Dependency, token: Token, input: Input) {
        self.meRepository = dep.meRepository
        
        let upvm = UsernameAndPasswordValidator()
        usernameAndPasswordValidator = upvm
        
        
        
        let usernameField = FieldFactory(
            name: FieldName.Username,
            initialValue: nil,
            input: input.username.asObservable(),
            validation: upvm.validateUsername
        )
        
        let passwordField = FieldFactory(
            name: FieldName.Password,
            initialValue: nil,
            input: input.password.asObservable(),
            validation: upvm.validatePassword
        )
        
        form = Form(
            submitTrigger: input.submitTrigger.asObservable(),
            submitHandler: { fields -> Observable<FormStatus> in
                guard let
                    username = (fields[FieldName.Username.rawValue] as! FieldState<String>).inputValue,
                    password = (fields[FieldName.Password.rawValue] as! FieldState<String>).inputValue else {
                        return Observable.just(.Error)
                }
                
                return dep.meRepository.logIn(username, password: password)
                    .map { _ in .Submitted }
                    .catchErrorJustReturn(.Error)
            },
            formField: usernameField, passwordField
        )
        
        super.init(router: dep.router)
    }
    
    
    func finishModule(callback: (CompletionHandler? -> ())? = nil) {
        router.finishModule { handler in
            callback?(handler)
        }
    }
}
