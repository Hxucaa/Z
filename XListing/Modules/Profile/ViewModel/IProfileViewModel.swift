//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import ReactiveCocoa

public protocol IProfileViewModel {
    init(router: IRouter, userService: IUserService)
    var nickname: MutableProperty<String> { get }
    func presentProfileEditModule()
}
