//
//  TabItem.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class TabItem<T: ITabContent> {
    private let tabContent: T
    public var rootNavigationController: UINavigationController {
        return tabContent.navigationController
    }
    
    public init(tabContent: T) {
        self.tabContent = tabContent
    }
}