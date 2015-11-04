//
//  IParticipationListCellViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IParticipationListCellViewModel : class {
    
    // MARK: - Outputs
    var coverImage: AnyProperty<UIImage?> { get }
    var infoPanelViewModel: ProfileTabInfoPanelViewModel { get }
    var statusButtonViewModel: ProfileTabStatusButtonViewModel { get }
    func getCoverImage() -> SignalProducer<Void, NSError>
}