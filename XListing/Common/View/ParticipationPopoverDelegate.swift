//
//  ParticipationPopoverDelegate.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol ParticipationPopoverDelegate: class {
    func alertAction(choiceTag: Int)
}