//
//  Participation.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-29.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public final class ParticipationService : IParticipationService {
    
    public func findBy(query: AVQuery) -> SignalProducer<[Participation], NSError> {
        return SignalProducer<[Participation], NSError> {sink, disposable in
            query.findObjectsInBackgroundWithBlock { object, error -> Void in
                if error == nil {
                    sendNext(sink, object as! [Participation])
                    sendCompleted(sink)
                }
                else {
                    sendError(sink, error)
                }
            }
        }
    }
    
    public func get(query: AVQuery) -> SignalProducer<Participation, NSError> {
        return SignalProducer { sink, disposable in
            query.getFirstObjectInBackgroundWithBlock { object, error -> Void in
                if error == nil {
                    sendNext(sink, object as! Participation)
                    sendCompleted(sink)
                }
                else {
                    sendError(sink, error)
                }
            }
        }
    }
    
    public func create(participation: Participation) -> SignalProducer<Bool, NSError> {
        return SignalProducer { sink, disposable in
            participation.saveInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    sendNext(sink, success)
                    sendCompleted(sink)
                }
                else {
                    sendError(sink, error)
                }
            }
        }
    }
    
    public func delete(participation: Participation) -> SignalProducer<Bool, NSError>{
        return SignalProducer{ sink, disposable in
            participation.deleteInBackgroundWithBlock { (success, error) -> Void in
                if error == nil{
                    sendNext(sink, success)
                    sendCompleted(sink)
                }
                else{
                    LSLogError("participation delete failed")
                    sendError(sink, error)
                }
            }
        }
    }
}
