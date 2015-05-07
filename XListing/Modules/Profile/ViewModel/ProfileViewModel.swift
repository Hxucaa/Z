//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public class ProfileViewModel : IProfileViewModel {
    private let wantToGoService: IWantToGoService
    
    public init(wantToGoService: IWantToGoService) {
        self.wantToGoService = wantToGoService
    }
}
