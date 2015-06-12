//
//  AccountRoute.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol AccountRoute : WithoutDataRoute {
    func present(completion: CompletionHandler?, dismissCallback: CompletionHandler?)
}