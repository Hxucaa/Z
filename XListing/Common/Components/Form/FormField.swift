//
//  FormField.swift
//  XListing
//
//  Created by Hong Zhu on 2016-02-10.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public class FormField<T> {
    
    public typealias ValidationRule = T -> ValidationNEL<T, ValidationError>
    
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
    
    private let _errors = MutableProperty<[ValidationError]>([ValidationError]())
    public var errors: AnyProperty<[ValidationError]> {
        return AnyProperty(_errors)
    }
    
    private let _valid = MutableProperty<Bool>(true)
    public var valid: AnyProperty<Bool> {
        return AnyProperty(_valid)
    }
    
    public var invalid: SignalProducer<Bool, NoError> {
        return _valid.producer.map { !$0 }
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
    
    private let validation: ValidationRule?
    
    public convenience init() {
        self.init(name: nil, initialValue: nil, validation: nil)
    }
    
    public convenience init(name: String) {
        self.init(name: name, initialValue: nil, validation: nil)
    }
    
    public convenience init(name: String, initialValue: T) {
        self.init(name: name, initialValue: initialValue, validation: nil)
    }
    
    public init(name: String?, initialValue: T?, validation: ValidationRule?) {
        self.name = name
        self.initialValue = initialValue
        self.validation = validation
        
        _valid <~ _errors.producer
            .map { $0.count == 0 ? true : false }
        
        _errors <~ _value.producer
            .map {
                if let value = $0, validation = validation, errors = validation(value).failure {
                    return errors
                }
                else {
                    return [ValidationError]()
                }
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
    }
}


public extension FormField {
    public func formattedErrors(separator: String? = "\n") -> SignalProducer<String?, NoError> {
        return _errors.producer
            .map { $0.isEmpty ? nil : $0.map { $0.description }.reduce("") { "\($0)\(separator)\($1)" } }
    }
}