//
//  IFeaturedBusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IFeaturedBusinessViewModel : class {
    var coverImage: PropertyOf<UIImage?> { get }
    var infoPanelViewModel: IFeaturedListBusinessCell_InfoPanelViewModel { get }
    var pariticipationViewModel: IFeaturedListBusinessCell_ParticipationViewModel { get }
    var statsViewModel: IFeaturedListBusinessCell_StatsViewModel { get }
    func getCoverImage() -> SignalProducer<Void, NSError>
}