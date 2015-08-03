//
//  IParticipationService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-29.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public protocol IParticipationService {
    func findBy(query: AVQuery) -> SignalProducer<[Participation], NSError>
    func get(query: AVQuery) -> SignalProducer<Participation, NSError>
    func create(participation: Participation) -> SignalProducer<Bool, NSError>
    func delete(participation: Participation) -> SignalProducer<Bool, NSError>
}