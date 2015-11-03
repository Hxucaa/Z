//
//  Operation.swift
//  ReactiveArray
//
//  Created by Guido Marucci Blas on 7/1/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

import Foundation

public enum Operation<T>: CustomDebugStringConvertible {
    
    case Initiate(values: [T])
    case Append(value: T)
    case AppendContentsOf(values: [T])
    case Insert(value: T, atIndex: Int)
    case Replace(value: T, atIndex: Int)
    case RemoveElement(atIndex: Int)
    case ReplaceAll(values: [T])
    case RemoveAll(keepCapacity: Bool)
    
    public func map<U>(mapper: T -> U) -> Operation<U> {
        switch self {
        case .Initiate(let values):
            return Operation<U>.Initiate(values: values.map(mapper))
        case .Append(let value):
            return Operation<U>.Append(value: mapper(value))
        case .AppendContentsOf(let values):
            return Operation<U>.AppendContentsOf(values: values.map(mapper))
        case let .Insert(value, index):
            return Operation<U>.Insert(value: mapper(value), atIndex: index)
        case .Replace(let value, let index):
            return Operation<U>.Replace(value: mapper(value), atIndex: index)
        case .RemoveElement(let index):
            return Operation<U>.RemoveElement(atIndex: index)
        case .ReplaceAll(let values):
            return Operation<U>.ReplaceAll(values: values.map(mapper))
        case let .RemoveAll(keepCapacity):
            return Operation<U>.RemoveAll(keepCapacity: keepCapacity)
        }
    }
    
    public var debugDescription: String {
        let description: String
        switch self {
        case .Initiate(let values):
            description = ".Initiate(values:\(values))"
        case .Append(let value):
            description = ".Append(value:\(value))"
        case .AppendContentsOf(let values):
            description = ".Extend(values:\(values))"
        case let .Insert(value, index):
            description = ".Insert(value:\(value), atIndex:\(index))"
        case .Replace(let value, let index):
            description = ".Replace(value: \(value), atIndex:\(index))"
        case .RemoveElement(let index):
            description = ".RemoveElement(atIndex:\(index))"
        case .ReplaceAll(let values):
            description = ".ReplaceAll(values:\(values))"
        case .RemoveAll(let keepCapacity):
            description = ".RemoveAll(keepCapacity:\(keepCapacity)"
        }
        return description
    }
    
    public var value: T? {
        switch self {
        case let .Append(value):
            return value
        case let .Replace(value, _):
            return value
        case let .Insert(value, _):
            return value
        default:
            return Optional.None
        }
    }
    
    public var arrayValue: [T]? {
        switch self {
        case .Initiate(let values):
            return values
        case .AppendContentsOf(let values):
            return values
        case .ReplaceAll(let values):
            return values
        default:
            return Optional.None
        }
    }
}

// TODO: Uses constrained protocol extension when moving to Swift 2.0
// extension Operation: Equatable where T: Equatable {}

public func ==<T: Equatable>(lhs: Operation<T>, rhs: Operation<T>) -> Bool {
    switch (lhs, rhs) {
    case (.Initiate(let leftValues), .Initiate(let rightValues)):
        return leftValues == rightValues
    case (.Append(let leftValue), .Append(let rightValue)):
        return leftValue == rightValue
    case (.AppendContentsOf(let leftValues), .AppendContentsOf(let rightValues)):
        return leftValues == rightValues
    case (.Insert(let leftValue, let leftIndex), .Insert(let rightValue, let rightIndex)):
        return leftIndex == rightIndex && leftValue == rightValue
    case (.Replace(let leftValue, let leftIndex), .Replace(let rightValue, let rightIndex)):
        return leftIndex == rightIndex && leftValue == rightValue
    case (.RemoveElement(let leftIndex), .RemoveElement(let rightIndex)):
        return leftIndex == rightIndex
    case (.ReplaceAll(let leftValues), .ReplaceAll(let rightValues)):
        return leftValues == rightValues
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