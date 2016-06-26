//
//  Attribute.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-22.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import AVOSCloud

class Attribute<T> {
    
    typealias ValueGetter = (propertyName: String) -> T
    typealias ValueSetter = (newValue: T, name: String) -> Void
    
    let propertyName: String
    var value: T {
        get {
            return getter(propertyName: propertyName)
        }
        set {
            setter(newValue: newValue, name: propertyName)
        }
    }
    
    private let getter: ValueGetter
    private let setter: ValueSetter
    
    
    init(propertyName: String, setter: ValueSetter, getter: ValueGetter) {
        self.propertyName = propertyName
        self.getter = getter
        self.setter = setter
    }
}

final class OptionalBoolAttribute : Attribute<Bool?> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as? Bool })
    }
}

final class BoolAttribute : Attribute<Bool> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as! Bool })
    }
}

final class OptionalStringAttribute : Attribute<String?> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as? String })
    }
}

final class StringAttribute : Attribute<String> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as! String })
    }
}

final class IntAttribute : Attribute<Int> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as! Int })
    }
}

final class OptionalIntAttribute : Attribute<Int?> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as? Int })
    }
}

final class NSDateAttribute : Attribute<NSDate> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as! NSDate })
    }
}

final class OptionalNSDateAttribute : Attribute<NSDate?> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as? NSDate })
    }
}

final class AVFileAttribute : Attribute<AVFile> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as! AVFile })
    }
}

final class OptionalAVFileAttribute : Attribute<AVFile?> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as? AVFile })
    }
}

final class AVGeoPointAttribute : Attribute<AVGeoPoint> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as! AVGeoPoint })
    }
}

final class OptionalAVGeoPointAttribute : Attribute<AVGeoPoint?> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as? AVGeoPoint })
    }
}

final class AddressDAOAttribute : Attribute<AddressDAO> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as! AddressDAO })
    }
}

final class OptionalAddressDAOAttribute : Attribute<AddressDAO?> {
    init(propertyName: String, dao: AVObject) {
        super.init(propertyName: propertyName, setter: { dao.setObject($0, forKey: $1) }, getter: { dao.objectForKey($0) as? AddressDAO })
    }
}
