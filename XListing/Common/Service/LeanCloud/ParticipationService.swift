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
        return SignalProducer<[Participation], NSError> {observer, disposable in
            query.findObjectsInBackgroundWithBlock { object, error -> Void in
                if error == nil {
                    observer.sendNext(object as! [Participation])
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
        }
    }
    
    public func get(query: AVQuery) -> SignalProducer<Participation, NSError> {
        return SignalProducer { observer, disposable in
            query.getFirstObjectInBackgroundWithBlock { object, error -> Void in
                if error == nil {
                    observer.sendNext(object as! Participation)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
        }
    }
    
    public func create(participation: Participation) -> SignalProducer<Bool, NSError> {
        return SignalProducer { observer, disposable in
            participation.saveInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    observer.sendNext(success)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
        }
    }
    
    public func delete(participation: Participation) -> SignalProducer<Bool, NSError>{
        return SignalProducer{ observer, disposable in
            participation.deleteInBackgroundWithBlock { (success, error) -> Void in
                if error == nil{
                    observer.sendNext(success)
                    observer.sendCompleted()
                }
                else{
                    LSLogError("participation delete failed")
                    observer.sendFailed(error)
                }
            }
        }
    }
}
