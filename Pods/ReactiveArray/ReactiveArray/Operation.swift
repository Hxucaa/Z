//
//  Operation.swift
//  ReactiveArray
//
//  Created by Guido Marucci Blas on 7/1/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

import Foundation
import Box

public enum Operation<T>: DebugPrintable {
    
    case Append(value: Box<T>)
    case Extend(values: Box<[T]>)
    case Insert(value: Box<T>, atIndex: Int)
    case RemoveElement(atIndex: Int)
    case ReplaceAll(values: Box<[T]>)
    case RemoveAll(keepCapacity: Bool)
    
    public func map<U>(mapper: T -> U) -> Operation<U> {
        switch self {
        case .Append(let boxedValue):
            return Operation<U>.Append(value: Box(mapper(boxedValue.value)))
        case .Extend(let boxedValues):
            return Operation<U>.Extend(values: Box(boxedValues.value.map { mapper($0) }))
        case .Insert(let boxedValue, let index):
            return Operation<U>.Insert(value: Box(mapper(boxedValue.value)), atIndex: index)
        case .RemoveElement(let index):
            return Operation<U>.RemoveElement(atIndex: index)
        case .ReplaceAll(let boxedValues):
            return Operation<U>.ReplaceAll(values: Box(boxedValues.value.map { mapper($0) }))
        default:
            fatalError("Use the other version of the map function!")
        }
    }
    
    public var debugDescription: String {
        let description: String
        switch self {
        case .Append(let boxedValue):
            description = ".Append(value:\(boxedValue.value))"
        case .Extend(let boxedValues):
            description = ".Extend(values:\(boxedValues.value))"
        case .Insert(let boxedValue, let index):
            description = ".Insert(value: \(boxedValue.value), atIndex:\(index))"
        case .RemoveElement(let index):
            description = ".RemoveElement(atIndex:\(index))"
        case .ReplaceAll(let boxedValues):
            description = ".ReplaceAll(values:\(boxedValues.value))"
        case .RemoveAll(let keepCapacity):
            description = ".RemoveAll(keepCapacity:\(keepCapacity)"
        }
        return description
    }
    
    public var value: T? {
        switch self {
        case .Append(let boxedValue):
            return boxedValue.value
        case .Insert(let boxedValue, let index):
            return boxedValue.value
        default:
            return Optional.None
        }
    }
    
    public var arrayValue: [T]? {
        switch self {
        case .Extend(let boxedValues):
            return boxedValues.value
        case .ReplaceAll(let boxedValues):
            return boxedValues.value
        default:
            return Optional.None
        }
    }
}

// TODO: Uses constrained protocol extension when moving to Swift 2.0
// extension Operation: Equatable where T: Equatable {}

public func ==<T: Equatable>(lhs: Operation<T>, rhs: Operation<T>) -> Bool {
    switch (lhs, rhs) {
    case (.Append(let leftBoxedValue), .Append(let rightBoxedValue)):
        return leftBoxedValue.value == rightBoxedValue.value
    case (.Extend(let leftBoxedValues), .Extend(let rightBoxedValues)):
        return leftBoxedValues.value == rightBoxedValues.value
    case (.Insert(let leftBoxedValue, let leftIndex), .Insert(let rightBoxedValue, let rightIndex)):
        return leftIndex == rightIndex && leftBoxedValue.value == rightBoxedValue.value
    case (.RemoveElement(let leftIndex), .RemoveElement(let rightIndex)):
        return leftIndex == rightIndex
    case (.ReplaceAll(let leftBoxedValues), .ReplaceAll(let rightBoxedValues)):
        return leftBoxedValues.value == rightBoxedValues.value
    default:
        return false
    }
}

// WTF!!! Again this is needed because the compiler is super stupid!
public func !=<T: Equatable>(lhs: Operation<T>, rhs: Operation<T>) -> Bool {
    return !(lhs == rhs)
}

// This is needed because somehow the compiler does not realize
// that when T is equatable it can compare an array of operations.
public func ==<T: Equatable>(lhs: [Operation<T>], rhs: [Operation<T>]) -> Bool {
    let areEqual: () -> Bool = {
        for var i = 0; i < lhs.count; i++ {
            if lhs[i] != rhs[i] {
                return false
            }
        }
        return true
    }
    return lhs.count == rhs.count && areEqual()
}