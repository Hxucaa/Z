//
//  UIDatePicker+stream.swift
//  XListing
//
//  Created by Lance on 2015-05-25.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit

public extension UIDatePicker {
    public func dateChangedStream() -> Stream<NSDate?> {
        return self.stream(controlEvents: UIControlEvents.ValueChanged) { sender -> NSDate? in
            if let sender = sender as? UIDatePicker {
                return sender.date
            }
            return nil
        } |> takeUntil(self.deinitStream)
    }
}
