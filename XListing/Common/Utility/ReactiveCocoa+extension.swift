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
Forwards events until the view controller is going to disappear.

:param: cell A UIViewController.
*/
public func takeUntilViewWillDisappear<T, E>(viewController: UIViewController) -> SignalProducer<T, E> -> SignalProducer<T, E> {
    return { producer in
        return producer
            |> takeUntil(viewController.rac_signalForSelector(viewWillDisappearSelector).toSignalProducer() |> toNihil)
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

/**
Forwards events until the view controller will disappear.

:param: view A UIViewController.
*/
public func takeUntilViewWillDisappear<T, U: UIViewController, E>(view: U) -> SignalProducer<T, E> -> SignalProducer<T, E> {
    return { producer in
        return producer
            |> takeUntil(view.rac_viewWillDisappear.toSignalProducer() |> toNihil)
    }
}

/**
Forwards events until the view is removed from the superview.

:param: view The superview.
*/
public func takeUntilRemoveFromSuperview<T, U: UIView, E>(view: U) -> SignalProducer<T, E> -> SignalProducer<T, E> {
    return { producer in
        return producer
            |> takeUntil(view.rac_removeFromSuperview.toSignalProducer() |> toNihil)
    }
}


/**
Log the life cycle of a signal, including `started`, `completed`, `interrupted`, `terminated`, and `disposed`.

:param: module     The module which the signal is located at.
:param: signalName Provide the name of the signal.

:returns: Continue the signal.
*/
public func logLifeCycle<T, E>(context: LogContext, signalName: String, file: StaticString = __FILE__, function: StaticString = __FUNCTION__, line: UWord = __LINE__) -> SignalProducer<T, E> -> SignalProducer<T, E> {
    
    // use the appropriate method to log
    let log = { (context: LogContext, message: String) -> Void in
        switch context {
        case .LeanCloud: LSLogVerbose(message, file: file, function: function, line: line)
        case .Root: RootLogVerbose(message, file: file, function: function, line: line)
        case .BackgroundOp: BOLogVerbose(message, file: file, function: function, line: line)
        case .Account: AccountLogVerbose(message, file: file, function: function, line: line)
        case .Detail: DetailLogVerbose(message, file: file, function: function, line: line)
        case .Nearby: NearbyLogVerbose(message, file: file, function: function, line: line)
        case .Featured: FeaturedLogVerbose(message, file: file, function: function, line: line)
        case .Profile: ProfileLogVerbose(message, file: file, function: function, line: line)
        case .WantToGo: WTGLogVerbose(message, file: file, function: function, line: line)
        case .Other: DDLogVerbose(message, file: file, function: function, line: line)
        }
    }
    
    return { producer in
        return producer
            |> on(
                started: {
                    log(context, "`\(signalName)` signal started.")
                },
                completed: {
                    log(context, "`\(signalName)` signal completed.")
                },
                interrupted: {
                    log(context, "`\(signalName)` signal interrupted.")
                },
                terminated: {
                    log(context, "`\(signalName)` signal terminated.")
                },
                disposed: {
                    log(context, "`\(signalName)` signal disposed.")
                }
            )
    }
}

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