//
//  IFeaturedListBusinessCell_ParticipationViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IFeaturedListBusinessCell_ParticipationViewModel : class {
    var participantViewModelArr: PropertyOf<[ParticipantViewModel]> { get }
    var isButtonEnabled: PropertyOf<Bool> { get }
    func getParticipantPreview() -> SignalProducer<Void, NSError>
    func getUserParticipation() -> SignalProducer<Void, NSError>
}