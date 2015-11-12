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
    var participantViewModelArr: AnyProperty<[ParticipantViewModel]> { get }
    var isButtonEnabled: AnyProperty<Bool> { get }
    var isWTGEnabled: AnyProperty<Bool> { get }
    var isTreatEnabled: AnyProperty<Bool> { get }
    var wtgCount: AnyProperty<String> { get }
    var treatCount: AnyProperty<String> { get }
    func getParticipantPreview() -> SignalProducer<Void, NSError>
    func getUserParticipation() -> SignalProducer<Void, NSError>
    func getWTGCount() -> SignalProducer<Void, NSError>
    func getTreatCount() -> SignalProducer<Void, NSError>
    func participate(choice: ParticipationType) -> SignalProducer<Bool, NSError>
}