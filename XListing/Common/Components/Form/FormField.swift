//
//  FormField.swift
//  XListing
//
//  Created by Hong Zhu on 2016-02-10.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public class RequiredFormField<T> : _BaseFormField<T> {
    
    public typealias ValidationRule = T -> ValidationNEL<T, ValidationError>
    
    public let validation: ValidationRule?
    
    public convenience init(name: String?) {
        self.init(name: name, initialValue: nil)
    }
    
    public convenience override init(name: String?, initialValue: T?) {
        self.init(name: name, initialValue: initialValue, validation: nil)
    }
    
    public init(name: String?, initialValue: T?, validation: ValidationRule?) {
        self.validation = validation
        super.init(name: name, initialValue: initialValue)
        
        _errors <~ _value.producer
            .skip(1)
            .map {
                guard let v = $0 else {
                    return [ValidationError.Required]
                }
                return validation?(v).failure
            }
    }
}

public class OptionalFormField<T> : _BaseFormField<T> {
    
    public typealias ValidationRule = T -> ValidationNEL<T, ValidationError>
    
    public let validation: ValidationRule?
    
    public convenience init(name: String?) {
        self.init(name: name, initialValue: nil)
    }
    
    public convenience override init(name: String?, initialValue: T?) {
        self.init(name: name, initialValue: initialValue, validation: nil)
    }
    
    public init(name: String?, initialValue: T?, validation: ValidationRule?) {
        self.validation = validation
        super.init(name: name, initialValue: initialValue)
        
        _errors <~ _value.producer
            .skip(1)
            .ignoreNil()
            .map { validation?($0).failure }
    }
}

public class _BaseFormField<T> {
    
    private let _active = MutableProperty<Bool>(false)
    public var active: AnyProperty<Bool> {
        return AnyProperty(_active)
    }
    
    private let _dirty = MutableProperty<Bool>(false)
    public var dirty: AnyProperty<Bool> {
        return AnyProperty(_dirty)
    }
    
    public var pristine: SignalProducer<Bool, NoError> {
        return _dirty.producer.map { !$0 }
    }
    
    public let initialValue: T?
    
    public let _errors = MutableProperty<[ValidationError]?>(nil)
    public var errors: AnyProperty<[ValidationError]?> {
        return AnyProperty(_errors)
    }
    
    private let _valid = MutableProperty<Bool>(true)
    public var valid: AnyProperty<Bool> {
        return AnyProperty(_valid)
    }
    
    public var invalid: SignalProducer<Bool, NoError> {
        return valid.producer.map { !$0 }
    }
    
    public let name: String?
    
    private let _touched = MutableProperty<Bool>(false)
    public var touched: AnyProperty<Bool> {
        return AnyProperty(_touched)
    }
    
    private let _value = MutableProperty<T?>(nil)
    public var value: AnyProperty<T?> {
        return AnyProperty(_value)
    }
    
    private let _visited = MutableProperty<Bool>(false)
    public var visited: AnyProperty<Bool> {
        return AnyProperty(_visited)
    }
    
    public convenience init(name: String?) {
        self.init(name: name, initialValue: nil)
    }
    
    public init(name: String?, initialValue: T?) {
        self.name = name
        self.initialValue = initialValue
        
        _valid <~ _errors.producer
            .map {
                $0 == nil ? true : false
            }
    }
    
    /**
     A function to call when the form field is changed.
     
     - parameter newValue: A new value
     */
    public func onChange(newValue: T?) {
        _value.modify { _ in newValue }
        _dirty.modify { _ in true }
    }
    
    /**
     A function to call when the form field receives focus.
     */
    public func onFocus() {
        _visited.modify { _ in true }
        _active.modify { _ in true }
    }
    
    /**
     A function to call when the form field loses focus.
     */
    public func onBlur() {
        _touched.modify { _ in true }
        _active.modify { _ in false }
    }
}


public extension _BaseFormField {
    public func formattedErrors(separator: String = "\n") -> String? {
        guard let e = _errors.value where !e.isEmpty else {
            return nil
        }
        
        let message = e.map { $0.description }.joinWithSeparator(separator)
        
        guard let name = name else {
            return message
        }
        
        return "\(name): \(message)"
    }
}