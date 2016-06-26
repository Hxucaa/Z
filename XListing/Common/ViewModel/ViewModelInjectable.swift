//
//  ViewModelInjectable.swift
//  XListing
//
//  Created by Lance Zhu on 2016-04-10.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation


protocol ViewModelInjectable {
    associatedtype Dependency
    associatedtype Token
    associatedtype Input
    
    static func inject(dep: Dependency) -> (Token) -> (Input) -> Self
    
    init(dep: Dependency, token: Token, input: Input)
}

extension ViewModelInjectable {
    static func inject(dep: Dependency) -> (Token) -> (Input) -> Self {
        return { token in
            return { input in
                return Self(dep: dep, token: token, input: input)
            }
        }
    }
}