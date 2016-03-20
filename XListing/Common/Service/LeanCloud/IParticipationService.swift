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

public protocol IParticipationService : class {
    func findBy(query: AVQuery) -> SignalProducer<[Event], NSError>
    func get(query: AVQuery) -> SignalProducer<Event, NSError>
    func create(participation: Event) -> SignalProducer<Bool, NSError>
    func delete(participation: Event) -> SignalProducer<Bool, NSError>
}