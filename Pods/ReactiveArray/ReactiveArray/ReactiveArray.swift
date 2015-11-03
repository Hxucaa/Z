//
//  ReactiveArray.swift
//  ReactiveArray
//
//  Created by Guido Marucci Blas on 6/29/15.
//  Copyright (c) 2015 Wolox. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class ReactiveArray<T>: MutableCollectionType {
    
    public typealias OperationProducer = SignalProducer<Operation<T>, NoError>
    public typealias OperationSignal = Signal<Operation<T>, NoError>
    
    private var _elements: Array<T> = []
    
    private let (_signal, _observer) = OperationSignal.pipe()
    
    private let _mutableCount: MutableProperty<Int>
    
    // MARK: - Initializers
    public init(elements:[T]) {
        _elements = elements
        _mutableCount = MutableProperty<Int>(elements.count)
        
        _signal.observeNext { [unowned self] operation in
            self.updateArray(operation)
        }
        
    }
    
    public convenience init(producer: OperationProducer) {
        self.init()
        
        producer
            .start(_observer)
    }
    
    public convenience init(producer: OperationProducer, startWithElements: Array<T>) {
        self.init()
        
        _elements = startWithElements
        producer
            .start(_observer)
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
        let appendCurrentElements = OperationProducer(value: Operation.Initiate(values: _elements))
        
        let forwardOperations = OperationProducer { (observer, dispoable) in self._signal.observe(observer) }
        
        return  appendCurrentElements
            .concat(forwardOperations)
    }
    
    private lazy var _observableCount: AnyProperty<Int> = AnyProperty(self._mutableCount)
    public var observableCount: AnyProperty<Int> {
        return _observableCount
    }
    
    // MARK: Operations
    /**
    Append newElement to the `ReactiveArray`.
    
    - parameter element: newElement
    */
    public func append(element: T) {
        let operation: Operation<T> = .Append(value: element)
        _observer.sendNext(operation)
    }
    
    /**
     Append the elements of newElements to self.
     
     - parameter elements: Array of new elements.
     */
    public func appendContentsOf(elements: [T]) {
        let operation: Operation<T> = .AppendContentsOf(values: elements)
        _observer.sendNext(operation)
    }
    
    /**
     Insert newElement at index i.
     
     Requires: i <= count
     
     Complexity: O(count).
     
     - parameter element: newElement
     - parameter index:   The index i.
     */
    public func insert(element: T, atIndex index: Int) {
        let operation: Operation<T> = .Insert(value: element, atIndex: index)
        _observer.sendNext(operation)
    }
    
    /**
     Replace and return the element at index i with another element.
     
     - parameter newElement: The new element.
     - parameter index:      The index i.
     
     - returns: The original element at index i
     */
    public func replace(newElement: T, atIndex index : Int) -> T {
        let operation: Operation<T> = .Replace(value: newElement, atIndex: index)
        // temporarily save the element before replace happens
        let toBeReplacedElement = _elements[index]
        _observer.sendNext(operation)
        return toBeReplacedElement
    }
    
    /**
     Remove and return the element at index i.
     
     - parameter index: The index of the element that is to be removed.
     
     - returns: Element at index i.
     */
    public func removeAtIndex(index: Int) -> T {
        let operation: Operation<T> = .RemoveElement(atIndex: index)
        // temporarily save the element before removal happens
        let toBeRemovedElement = _elements[index]
        _observer.sendNext(operation)
        return toBeRemovedElement
    }
    
    /**
     Replace the underlying array of elements with a new one.
     
     - parameter elements: The new array of elements.
     */
    public func replaceAll(elements: [T]) {
        let operation: Operation<T> = .ReplaceAll(values: elements)
        _observer.sendNext(operation)
    }
    
    /**
     Remove all elements.
     
     - parameter keepCapacity: A boolean value.
     */
    public func removeAll(keepCapacity: Bool) {
        let operation: Operation<T> = .RemoveAll(keepCapacity: keepCapacity)
        _observer.sendNext(operation)
    }
    
    // MARK: Array Functions
    
    public func mirror<U>(transformer: T -> U) -> ReactiveArray<U> {
        return ReactiveArray<U>(producer: producer.map { $0.map(transformer) }, startWithElements: _elements.map(transformer))
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
        case .Initiate(_):
            // do nothing as the data is present when `Initiate` opearation occurs
            break
        case .Append(let value):
            _elements.append(value)
        case .AppendContentsOf(let values):
            _elements.appendContentsOf(values)
        case .Insert(let value, let index):
            _elements.insert(value, atIndex: index)
        case .Replace(let value, let index):
            _elements[index] = value
        case .RemoveElement(let index):
            _elements.removeAtIndex(index)
        case .ReplaceAll(let values):
            _elements = values
        case .RemoveAll(let keepCapacity):
            _elements.removeAll(keepCapacity: keepCapacity)
        }
        
        _mutableCount.value = _elements.count
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
}

extension ReactiveArray : CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return _elements.debugDescription
    }
}