//
//  ReactiveArray.swift
//  ReactiveArray
//
//  Created by Guido Marucci Blas on 6/29/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Box

public final class ReactiveArray<T>: MutableCollectionType {
    
    typealias OperationProducer = SignalProducer<Operation<T>, NoError>
    typealias OperationSignal = Signal<Operation<T>, NoError>
    
    private var _elements: Array<T> = []
    
    private let (_signal, _sink) = OperationSignal.pipe()
    
    private let _mutableCount: MutableProperty<Int>
    
    // MARK: - Initializers
    public init(elements:[T]) {
        _elements = elements
        _mutableCount = MutableProperty<Int>(elements.count)
        
        _signal.observe { [unowned self](operation) in
            self.updateArray(operation)
        }
        
    }
    
    public convenience init(producer: OperationProducer) {
        self.init()
        
        producer |> start(_sink)
    }
    
    public convenience init() {
        self.init(elements: [])
    }
    
    // MARK: - API
    
    // MARK: Observable Signals
    public var signal: OperationSignal {
        return _signal
    }
    
    public var producer: OperationProducer {
        let appendCurrentElements = OperationProducer(values:_elements.map { Operation.Append(value: Box($0)) })
        
        let forwardOperations = OperationProducer { (observer, dispoable) in self._signal.observe(observer) }
        
        return  appendCurrentElements |> concat(forwardOperations)
    }
    
    private lazy var _observableCount: PropertyOf<Int> = PropertyOf(self._mutableCount)
    public var observableCount: PropertyOf<Int> {
        return _observableCount
    }
    
    // MARK: Operations
    public func append(element: T) {
        let operation: Operation<T> = .Append(value: Box(element))
        sendNext(_sink, operation)
    }
    
    public func extend(elements: [T]) {
        let operation: Operation<T> = .Extend(values: Box(elements))
        sendNext(_sink, operation)
    }
    
    public func insert(newElement: T, atIndex index : Int) {
        let operation: Operation<T> = .Insert(value: Box(newElement), atIndex: index)
        sendNext(_sink, operation)
    }
    
    public func removeAtIndex(index:Int) {
        let operation: Operation<T> = .RemoveElement(atIndex: index)
        sendNext(_sink, operation)
    }
    
    public func replaceAll(elements: [T]) {
        let operation: Operation<T> = .ReplaceAll(values: Box(elements))
        sendNext(_sink, operation)
    }
    
    public func removeAll(keepCapacity: Bool) {
        let operation: Operation<T> = .RemoveAll(keepCapacity: keepCapacity)
        sendNext(_sink, operation)
    }
    
    // MARK: Array Functions
    
    public func mirror<U>(transformer: T -> U) -> ReactiveArray<U> {
        return ReactiveArray<U>(producer: producer |> ReactiveCocoa.map { $0.map(transformer) })
    }
    
    public subscript(index: Int) -> T {
        get {
            return _elements[index]
        }
        set(newValue) {
            insert(newValue, atIndex: index)
        }
    }
    
    public func toArray() -> Array<T> {
        return _elements
    }
    
    // MARK: - Others
    private func updateArray(operation: Operation<T>) {
        switch operation {
        case .Append(let boxedValue):
            _elements.append(boxedValue.value)
            _mutableCount.put(_elements.count)
        case .Extend(let boxedValues):
            _elements.extend(boxedValues.value)
            _mutableCount.put(_elements.count)
        case .Insert(let boxedValue, let index):
            _elements[index] = boxedValue.value
            _mutableCount.put(_elements.count)
        case .RemoveElement(let index):
            _elements.removeAtIndex(index)
            _mutableCount.put(_elements.count)
        case .ReplaceAll(let boxedValues):
            _elements = boxedValues.value
            _mutableCount.put(_elements.count)
        case .RemoveAll(let keepCapacity):
            _elements.removeAll(keepCapacity: keepCapacity)
            _mutableCount.put(_elements.count)
        }
    }
    
}

extension ReactiveArray : CollectionType {
    
    public var isEmpty: Bool {
        return _elements.isEmpty
    }
    
    public var count: Int {
        return _elements.count
    }
    
    public var startIndex: Int {
        return _elements.startIndex
    }
    
    public var endIndex: Int {
        return _elements.endIndex
    }
    
    public var first: T? {
        return _elements.first
    }
    
    public var last: T? {
        return _elements.last
    }
    
    // TODO: Remove this in Swift 2.0
    public func generate() -> IndexingGenerator<Array<T>> {
        return _elements.generate()
    }
}

extension ReactiveArray : DebugPrintable {
    
    public var debugDescription: String {
        return _elements.debugDescription
    }
}