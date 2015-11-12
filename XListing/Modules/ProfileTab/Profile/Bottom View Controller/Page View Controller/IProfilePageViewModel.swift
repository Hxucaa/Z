//
//  IProfilePageViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IProfilePageViewModel : class {
    
    
    // MARK: - Properties
    var navigator: ProfileNavigator? { get set }
    
    // MARK: ViewModels
    var photoManagerViewModel: IPhotoManagerViewModel { get }
    var participationListViewModel: IParticipationListViewModel { get }
}