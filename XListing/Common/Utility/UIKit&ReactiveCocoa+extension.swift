//
//  UIKit+extension.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-28.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

// swiftlint:disable variable_name

import UIKit
import ReactiveCocoa

private struct AssociationKey {
    static var hidden: UInt8 = 1
    static var alpha: UInt8 = 2
    static var text: UInt8 = 3
    static var date: UInt8 = 4
    static var enabled: UInt8 = 5
    static var title: UInt8 = 6
    static var minimumDate: UInt = 7
    static var maximumDate: UInt = 8
    static var image: UInt8 = 9
    static var optionalText: UInt8 = 10
    static var backgroundColor: UInt8 = 11
    static var recognizerEnabled: UInt8 = 12
}

// lazily creates a gettable associated property via the given factory
private func lazyAssociatedProperty<T: AnyObject>(host: AnyObject, key: UnsafePointer<Void>, factory: () -> T) -> T {
    return objc_getAssociatedObject(host, key) as? T ?? {
        let associatedProperty = factory()
        objc_setAssociatedObject(host, key, associatedProperty, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        return associatedProperty
    }()
}

private func lazyMutableProperty<T>(host: AnyObject, key: UnsafePointer<Void>, setter: T -> (), getter: () -> T) -> MutableProperty<T> {
    return lazyAssociatedProperty(host, key: key) {
        let property = MutableProperty<T>(getter())
        property.producer
            .startWithNext {
                newValue in
                setter(newValue)
            }
        return property
    }
}

extension UIControl {
    public var rac_enabled: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.enabled, setter: { self.enabled = $0 }, getter: { self.enabled })
    }
}

extension UIGestureRecognizer {
    public var rac_enabled: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.recognizerEnabled, setter: { self.enabled = $0 }, getter: { self.enabled})
    }
}

extension UIView {
    public var rac_alpha: MutableProperty<CGFloat> {
        return lazyMutableProperty(self, key: &AssociationKey.alpha, setter: { self.alpha = $0 }, getter: { self.alpha  })
    }
    
    public var rac_hidden: MutableProperty<Bool> {
        return lazyMutableProperty(self, key: &AssociationKey.hidden, setter: { self.hidden = $0 }, getter: { self.hidden  })
    }
    
    public var rac_backgroundColor: MutableProperty<UIColor?> {
        return lazyMutableProperty(self, key: &AssociationKey.backgroundColor, setter: { self.backgroundColor = $0 }, getter: { self.backgroundColor })
    }
    
}

extension UILabel {
    
    public var rac_text: MutableProperty<String> {
        return lazyMutableProperty(self, key: &AssociationKey.text, setter: { self.text = $0 }, getter: { self.text ?? "" })
    }
}

extension UINavigationItem {
    public var rac_title: MutableProperty<String> {
        return lazyMutableProperty(self, key: &AssociationKey.title, setter: { self.title = $0 }, getter: { self.title ?? ""})
    }
}

extension UIDatePicker {
    public var rac_date: MutableProperty<NSDate> {
        return lazyAssociatedProperty(self, key: &AssociationKey.date) {
            
            self.addTarget(self, action: "changed", forControlEvents: UIControlEvents.ValueChanged)
            
            let property = MutableProperty<NSDate>(self.date)
            property.producer
                .startWithNext { self.date = $0 }
            
            return property
        }
    }
    
    internal func changed() {
        rac_date.value = self.date
    }
}

extension UITextField {
    
    public var rac_text: MutableProperty<String?> {
        return lazyAssociatedProperty(self, key: &AssociationKey.text) {
            
            self.addTarget(self, action: "changed", forControlEvents: UIControlEvents.EditingChanged)
            
            let property = MutableProperty<String?>(self.text)
            property.producer
                .startWithNext {
                    newValue in
                    self.text = newValue
                }
            return property
        }
    }
    
    internal func changed() {
        rac_text.value = self.text
    }
}

extension UIImageView {
    public var rac_image: MutableProperty<UIImage?> {
        return lazyMutableProperty(self, key: &AssociationKey.image, setter: { self.image = $0 }, getter: { self.image })
    }
}


extension UIViewController {
    public var rac_viewWillDisappear: RACSignal {
        return rac_signalForSelector(Selector("viewWillDisappear:"))
    }
    
    public var rac_viewWillDisappearProducer: SignalProducer<Bool, NSError> {
        return rac_viewWillDisappear.toSignalProducer()
            .map { ($0 as! RACTuple).first as! Bool }
    }
    
    public var rac_viewDidDisappear: RACSignal {
        return rac_signalForSelector(Selector("viewDidDisappear:"))
    }
    
    public var rac_viewDidDisappearProducer: SignalProducer<Bool, NSError> {
        return rac_viewDidDisappear.toSignalProducer()
            .map { ($0 as! RACTuple).first as! Bool }
    }
    
    public var rac_viewWillAppear: RACSignal {
        return rac_signalForSelector(Selector("viewWillAppear:"))
    }
    
    public var rac_viewWillAppearProducer: SignalProducer<Bool, NSError> {
        return rac_viewWillAppear.toSignalProducer()
            .map { ($0 as! RACTuple).first as! Bool }
    }
    
    public var rac_viewDidAppear: RACSignal {
        return rac_signalForSelector(Selector("viewDidAppear:"))
    }
    
    public var rac_viewDidAppearProducer: SignalProducer<Bool, NSError> {
        return rac_viewDidAppear.toSignalProducer()
            .map { ($0 as! RACTuple).first as! Bool }
    }
    
}

extension UIView {
    public var rac_removeFromSuperview: RACSignal {
        return rac_signalForSelector(Selector("removeFromSuperview"))
    }
    
    public var rac_removeFromSuperviewProducer: SignalProducer<Void, NSError> {
        return rac_removeFromSuperview.toSignalProducer()
            .map { _ in }
    }
}