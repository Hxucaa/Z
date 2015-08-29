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
    /**
    Append newElement to the `ReactiveArray`.
    
    :param: element newElement
    */
    public func append(element: T) {
        let operation: Operation<T> = .Append(value: Box(element))
        sendNext(_sink, operation)
    }
    
    /**
    Append the elements of newElements to self.
    
    :param: elements Array of new elements.
    */
    public func extend(elements: [T]) {
        let operation: Operation<T> = .Extend(values: Box(elements))
        sendNext(_sink, operation)
    }
    
    /**
    Insert newElement at index i.
    
    Requires: i <= count
    
    Complexity: O(count).
    
    :param: element newElement
    :param: index   The index i.
    */
    public func insert(element: T, atIndex index: Int) {
        let operation: Operation<T> = .Insert(value: Box(element), atIndex: index)
        sendNext(_sink, operation)
    }
    
    /**
    Replace and return the element at index i with another element.
    
    :param: newElement The new element.
    :param: index      The index i.
    
    :returns: The original element at index i
    */
    public func replace(newElement: T, atIndex index : Int) -> T {
        let operation: Operation<T> = .Replace(value: Box(newElement), atIndex: index)
        // temporarily save the element before replace happens
        let toBeReplacedElement = _elements[index]
        sendNext(_sink, operation)
        return toBeReplacedElement
    }
    
    /**
    Remove and return the element at index i.
    
    :param: index The index of the element that is to be removed.
    
    :returns: Element at index i.
    */
    public func removeAtIndex(index: Int) -> T {
        let operation: Operation<T> = .RemoveElement(atIndex: index)
        // temporarily save the element before removal happens
        let toBeRemovedElement = _elements[index]
        sendNext(_sink, operation)
        return toBeRemovedElement
    }
    
    /**
    Replace the underlying array of elements with a new one.
    
    :param: elements The new array of elements.
    */
    public func replaceAll(elements: [T]) {
        let operation: Operation<T> = .ReplaceAll(values: Box(elements))
        sendNext(_sink, operation)
    }
    
    /**
    Remove all elements.
    
    :param: keepCapacity A boolean value.
    */
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
            replace(newValue, atIndex: index)
        }
    }
    
    /// Exposing the underlying array of elements that is being encapsulated.
    public var array: Array<T> {
        return _elements
    }
    
    // MARK: - Others
    private func updateArray(operation: Operation<T>) {
        switch operation {
        case .Append(let boxedValue):
            _elements.append(boxedValue.value)
        case .Extend(let boxedValues):
            _elements.extend(boxedValues.value)
        case .Insert(let boxedValue, let index):
            _elements.insert(boxedValue.value, atIndex: index)
        case .Replace(let boxedValue, let index):
            _elements[index] = boxedValue.value
        case .RemoveElement(let index):
            _elements.removeAtIndex(index)
        case .ReplaceAll(let boxedValues):
            _elements = boxedValues.value
        case .RemoveAll(let keepCapacity):
            _elements.removeAll(keepCapacity: keepCapacity)
        }
        
        _mutableCount.put(_elements.count)
    }
    
}

extension ReactiveArray : CollectionType {
    
    /// true if and only if the Array is empty
    public var isEmpty: Bool {
        return _elements.isEmpty
    }
    
    /// How many elements the Array stores
    public var count: Int {
        return _elements.count
    }
    
    /// Always zero, which is the index of the first element when non-empty.
    public var startIndex: Int {
        return _elements.startIndex
    }
    
    /// A "past-the-end" element index; the successor of the last valid subscript argument.
    public var endIndex: Int {
        return _elements.endIndex
    }
    
    /// The first element, or nil if the array is empty
    public var first: T? {
        return _elements.first
    }
    
    /// The last element, or nil if the array is empty
    public var last: T? {
        return _elements.last
    }
    
    // TODO: Remove this in Swift 2.0
    /**
    Return a generator over the elements.
    */
    public func generate() -> IndexingGenerator<Array<T>> {
        return _elements.generate()
    }
}

extension ReactiveArray : DebugPrintable {
    
    public var debugDescription: String {
        return _elements.debugDescription
    }
}