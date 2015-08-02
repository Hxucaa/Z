//
//  ReactiveCocoa+extension.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

/**
Converts to a SignalProducer with `Void` value and `NoError`
*/
public func toNihil<T, E>(producer: SignalProducer<T, E>) -> SignalProducer<Void, NoError> {
    return producer
        |> map { _ in }
        |> catch { error in SignalProducer<Void, NoError>.empty }
}

/**
Forwards events until the cell is being prepared for reuse.

:param: view A UITableViewCell.
*/
public func takeUntilPrepareForReuse<T, E>(view: UITableViewCell) -> SignalProducer<T, E> -> SignalProducer<T, E> {
    return { producer in
        return producer
            |> takeUntil(view.rac_prepareForReuseSignal.toSignalProducer() |> toNihil)
    }
}

/**
Forwards events until the cell is being prepared for reuse.

:param: view A UICollectionViewCell.
*/
public func takeUntilPrepareForReuse<T, E>(view: UICollectionReusableView) -> SignalProducer<T, E> -> SignalProducer<T, E> {
    return { producer in
        return producer
            |> takeUntil(view.rac_prepareForReuseSignal.toSignalProducer() |> toNihil)
    }
}

/**
Forwards events until the view is being prepared for reuse.

:param: view A UICollectionViewCell.
*/
public func takeUntilPrepareForReuse<T, E>(view: MKAnnotationView) -> SignalProducer<T, E> -> SignalProducer<T, E> {
    return { producer in
        return producer
            |> takeUntil(view.rac_prepareForReuseSignal.toSignalProducer() |> toNihil)
    }
}

public let viewWillDisappearSelector = Selector("viewWillDisappear:")
public typealias SimpleProxy = SignalProducer<Void, NoError>

extension SignalProducer {
    /**
    Create a buffer of size 0. Use this with `SimpleProxy`.
    
    :returns: A buffer of size 0.
    */
    internal static func proxy() -> (SignalProducer, Signal<T, E>.Observer) {
        return self.buffer(0)
    }
}