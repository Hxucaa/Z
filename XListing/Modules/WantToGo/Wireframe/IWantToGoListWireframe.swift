//
//  IWantToGoListWireframe.swift
//  XListing
//
//  Created by William Qi on 2015-06-27.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IWantToGoListWireframe {
    init(rootWireframe: IRootWireframe, router: IRouter, userService: IUserService, participationService: IParticipationService)
}