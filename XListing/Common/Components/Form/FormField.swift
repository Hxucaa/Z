//
//  FormField.swift
//  XListing
//
//  Created by Hong Zhu on 2016-02-10.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public struct FormField<T: Equatable> {
    
    public typealias ValidationRule = T? -> ValidationNEL<T, ValidationError>
    
    public let name: String?
    public let value: FieldValue<T>
    public let validation: ValidationRule?
    public let errors: [ValidationError]?
    public let visited: Bool
    public let touched: Bool
    
    public var valid: Bool {
        return errors == nil ? true : false
    }
    
    public var invalid: Bool {
        return !valid
    }
    
    public var dirty: Bool {
        switch value {
        case .Initial(_):
            return true
        case .Input(_):
            return false
        }
    }
    
    public var pristine: Bool {
        return !dirty
    }
    
    public var validDirtyValue: T? {
        if valid && dirty {
            return value.value
        }
        else {
            return nil
        }
    }
    
    public var isInitialValue: Bool {
        if case .Initial(_) = value {
            return true
        }
        else {
            return false
        }
    }
    
    public var isUserInput: Bool {
        return !isInitialValue
    }
    
    public init(name: String?, initialValue: T?) {
        self.init(name: name, initialValue: initialValue, validation: nil)
    }
    
    public init(name: String?, initialValue: T?, validation: ValidationRule?) {
        self.name = name
        value = .Initial(initialValue)
        self.validation = validation
        if let value = value.value, validation = validation {
            self.errors = validation(value).failure
        }
        else {
            self.errors = nil
        }
        
        visited = false
        touched = false
    }
    
    private init(name: String?, value: FieldValue<T>, validation: ValidationRule?, visited: Bool, touched: Bool) {
        self.name = name
        self.value = value
        self.validation = validation
        if let value = value.value, validation = validation {
            self.errors = validation(value).failure
        }
        else {
            self.errors = nil
        }
        
        self.visited = visited
        self.touched = touched
    }
    
    public func onChange(value: T?) -> FormField<T> {
        return FormField<T>(
            name: name,
            value: self.value.onChange(value),
            validation: self.validation,
            visited: self.visited,
            touched: self.touched
        )
    }
    
    public func onFocus() -> FormField<T> {
        if visited {
            return self
        }
        else {
            return FormField<T>(
                name: name,
                value: value,
                validation: self.validation,
                visited: true,
                touched: self.touched
            )
        }
    }
    
    public func onBlur() -> FormField<T> {
        if touched {
            return self
        }
        else {
            return FormField<T>(
                name: name,
                value: value,
                validation: self.validation,
                visited: self.visited,
                touched: true
            )
        }
    }
}

public extension FormField {
    public func formattedErrors(separator: String = "\n") -> String? {
        guard let e = errors where !e.isEmpty else {
            return nil
        }
        
        let message = e.map { $0.description }.joinWithSeparator(separator)
        
        guard let name = name else {
            return message
        }
        
        return "\(name): \(message)"
    }
}

public enum FieldValue<T: Equatable> {
    case Initial(T?)
    case Input(T?)
    
    public func onChange(value: T?) -> FieldValue<T> {
        switch self {
        case let .Initial(v) where v == value:
            return self
        case let .Input(v) where v == value:
            return .Initial(v)
        default:
            return .Input(value)
        }
    }
    
    public var value: T? {
        switch self {
        case let .Initial(v):
            return v
        case let .Input(v):
            return v
        }
    }
}
