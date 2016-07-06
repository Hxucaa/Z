//
//  UsernameAndPasswordViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-05.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import Swiftz
import RxSwift
import RxCocoa

struct UsernameAndPasswordValidator {
    
    // MARK: - Input
    
    // MARK: - Output
    func validateUsername(value: String?) -> ValidationNEL<String, ValidationError> {
        guard let value = value else {
            return ValidationNEL<String, ValidationError>.Failure([ValidationError.Required])
        }
        let base = ValidationNEL<String -> String -> String, ValidationError>.Success({ a in { b in  value } })
        let rule1: ValidationNEL<String, ValidationError> = value.length >= 6 && value.length <= 30 ?
            .Success(value) :
            .Failure([ValidationError.Custom(message: "用户名长度为6-30字符")])
        let rule2: ValidationNEL<String, ValidationError> = testRegex(value, pattern: "[\\d[a-zA-Z]]+") ?
            .Success(value) :
            .Failure([ValidationError.Custom(message: "用户名尽可含数字和大小写字母")])
        
        return base <*> rule1 <*> rule2
    }
    
    func validatePassword(value: String?) -> ValidationNEL<String, ValidationError> {
        guard let value = value else {
            return ValidationNEL<String, ValidationError>.Failure([ValidationError.Required])
        }
        let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
        let rule1: ValidationNEL<String, ValidationError> = value.length >= 8 ?
            .Success(value) :
            .Failure([ValidationError.Custom(message: "密码长度必须大于8个字符")])
        
        return base <*> rule1
    }
    
    // MARK: - Properties
    
    // MARK: - Initializers
    init() {
    }
    
    private func testRegex(input: String, pattern: String) -> Bool {
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            
            let match = regex.numberOfMatchesInString(input, options: [], range:NSMakeRange(0, input.characters.count))
            return match == 1
        }
        else {
            return false
        }
    }
}