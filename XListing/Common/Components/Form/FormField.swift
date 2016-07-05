//
//  FormField.swift
//  XListing
//
//  Created by Lance Zhu on 2016-02-10.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxOptional
import RxCocoa

public protocol FormFieldFactoryType {
    var name: String { get }
    var contraOutput: Observable<FormFieldType> { get }
}

public struct FormFieldFactory<T: Equatable> : FormFieldFactoryType {
    
    public typealias ValidationRule = T? -> ValidationNEL<T, ValidationError>
    
    public let name: String
    public let output: Observable<FormField<T>>
    public var contraOutput: Observable<FormFieldType> {
        return output.map { $0 as FormFieldType }
    }
    
    public init<S: RawRepresentable where S.RawValue == String>(name: S, initialValue: T? = nil, input: Observable<T?>, validation: ValidationRule? = nil) {
        self.init(name: name.rawValue, initial: Observable.just(initialValue), input: input, validation: validation)
    }
    
    public init(name: String, initialValue: T? = nil, input: Observable<T?>, validation: ValidationRule? = nil) {
        self.init(name: name, initial: Observable.just(initialValue), input: input, validation: validation)
    }
    
    public init<S: RawRepresentable where S.RawValue == String>(name: S, initial: Observable<T?> = Observable.just(nil), input: Observable<T?>, validation: ValidationRule? = nil) {
        self.init(name: name.rawValue, initial: initial, input: input, validation: validation)
    }
    
    public init(name: String, initial: Observable<T?> = Observable.just(nil), input: Observable<T?>, validation: ValidationRule? = nil) {
        
        self.name = name
        
        output = initial
            .concat(input)
            .scan(nil) { acc, current -> FormField<T>? in
                guard let acc = acc else {
                    return FormField(name: name, initialValue: current, validation: validation)
                }
                
                return acc.onChange(current)
            }
            .filterNil()
            .shareReplay(1)
    }
    
}

enum FormStatus {
    case Loading
    case Awaiting
    case Error
    case Submitting
    case Submitted
    case Fatal
}

public struct Form {
    
//    let fields = [FormFieldName : AnyObject]()
    let fields: [String : Observable<FormFieldType>]
//    private let fieldsObservable: Observable<Observable<FormFieldType>>
    
//    private let submissionEnabledTrigger: Observable<Bool>
    let status: Driver<FormStatus>
    let submissionEnabled: Driver<Bool>
    
    init(initialLoadTrigger: Observable<Void>, submitTrigger: Observable<Void>, submitHandler: [String : FormFieldType] -> Observable<FormStatus>, formField: FormFieldFactoryType...) {
        self.init(initialLoadTrigger: initialLoadTrigger, submitTrigger: submitTrigger, submitHandler: submitHandler, formField: formField)
    }

    init(initialLoadTrigger: Observable<Void>, submitTrigger: Observable<Void>, submitHandler: [String : FormFieldType] -> Observable<FormStatus>, formField: [FormFieldFactoryType]) {
        
        var dict = [String : Observable<FormFieldType>]()
        formField.forEach {
            guard dict[$0.name] == nil else {
                fatalError("Cannot have fields with the same name")
            }
            dict[$0.name] = $0.contraOutput
                .shareReplay(1)
        }
        fields = dict
        
        
        status = initialLoadTrigger
            .map { _ in .Awaiting }
            .concat(submitTrigger
                .flatMap {
                    formField
                        .map { $0.contraOutput }
                        .combineLatest {
                            $0.filter { $0.isUserInput }
                        }
                        .flatMap { fields -> Observable<FormStatus> in
                            guard (fields.map { $0.valid }.and) else {
                                return Observable.just(.Error)
                            }
                            guard (fields.map { $0.dirty }.or) else {
                                return Observable.just(.Awaiting)
                            }
                            
                            var dictionary = [String : FormFieldType]()
                            fields.forEach { dictionary[$0.name] = $0 }
                            
                            return submitHandler(dictionary)
                                .startWith(.Submitting)
                        }
                }
            )
            .startWith(.Loading)
            .asDriver(onErrorJustReturn: .Fatal)
        
        submissionEnabled = [
            status
                .map {
                    switch $0 {
                    case .Awaiting: return true
                    case .Submitted: return true
                    default: return false
                    }
                }
                .debug(),
            dict.values
                .combineLatest {
                    $0.map { $0.valid }.and && $0.map { $0.dirty }.or
                }
                .asDriver(onErrorJustReturn: false)
            ]
            .combineLatest {
                $0.and
            }
            // submission is disabled initially
            .startWith(false)
    }
    
    public func formField<T: Equatable>(name: String, type: T.Type) -> Observable<FormFieldType>? {
        return fields[name]
    }
    
    public var dirty: Observable<Bool> {
        return fields.values
            .combineLatest {
                $0.reduce(false) { $0 || $1.dirty }
            }
    }
    
    public var pristine: Observable<Bool> {
        return dirty
            .map(!)
    }
    
    public var valid: Observable<Bool> {
        return fields.values
            .combineLatest {
                $0.reduce(true) { $0 && $1.valid }
            }
    }
    
    public var invalid: Observable<Bool> {
        return valid
            .map(!)
    }
}

public protocol FieldValueConcreteType : Equatable {}

public protocol FormFieldType {
    var name: String { get }
    
    var errors: [ValidationError]? { get }
    var visited: Bool { get }
    var touched: Bool { get }
    var valid: Bool { get }
    var invalid: Bool { get }
    var dirty: Bool { get }
    var pristine: Bool { get }
    var isInitialValue: Bool { get }
    var isUserInput: Bool { get }
}

public struct FormField<T: Equatable> : FormFieldType {
    
    public typealias ValidationRule = T? -> ValidationNEL<T, ValidationError>
    
    public let name: String
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
            return false
        case .Input(_):
            return true
        }
    }
    
    public var pristine: Bool {
        return !dirty
    }
    
    public var validDirtyValue: T? {
        if valid && dirty {
            return value.currentValue
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
    
    public var initialValue: T? {
        switch value {
        case let .Initial(i):
            return i
        default:
            return nil
        }
    }
    
    public var inputValue: T? {
        switch value {
        case let .Input(_, v):
            return v
        default:
            return nil
        }
    }
    
    public init(name: String, initialValue: T?) {
        self.init(name: name, initialValue: initialValue, validation: nil)
    }
    
    public init(name: String, initialValue: T?, validation: ValidationRule?) {
        self.name = name
        value = .Initial(initial: initialValue)
        self.validation = validation
        if let value = value.currentValue, validation = validation {
            self.errors = validation(value).failure
        }
        else {
            self.errors = nil
        }
        
        visited = false
        touched = false
    }
    
    private init(name: String, value: FieldValue<T>, validation: ValidationRule?, visited: Bool, touched: Bool) {
        self.name = name
        self.value = value
        self.validation = validation
        if let value = value.currentValue, validation = validation {
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
        
        return "\(name): \(message)"
    }
}

public enum FieldValue<T: Equatable> {
    case Initial(initial: T?)
    case Input(initial: T?, current: T?)
    
    public func onChange(newValue: T?) -> FieldValue<T> {
        switch self {
        case let .Initial(initial) where initial == newValue:
            return self
        case let .Initial(initial):
            return .Input(initial: initial, current: newValue)
        case let .Input(initial, _) where initial == newValue:
            return .Initial(initial: initial)
        case let .Input(initial, _):
            return .Input(initial: initial, current: newValue)
        }
    }
    
    public var initialValue: T? {
        switch self {
        case let .Initial(i):
            return i
        case let .Input(i, _):
            return i
        }
    }
    
    public var currentValue: T? {
        switch self {
        case .Initial(_):
            return nil
        case let .Input(_, v):
            return v
        }
    }
}
