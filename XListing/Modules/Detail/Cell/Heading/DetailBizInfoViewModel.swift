//
//  DetailBizInfoViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit
import AVOSCloud

private let CityDistanceSeparator = "•"
private let 我想去 = "\u{f08a} 我想去"
private let 已参与 = "\u{f004} 以参与"

public struct DetailBizInfoViewModel {
    
    // MARK: - Public
    
    // MARK: Inputs
    
    // MARK: Outputs
    public let businessName: ConstantProperty<String>
    public let locationText: MutableProperty<String> = MutableProperty("")
    public let participationButtonTitle: MutableProperty<String> = MutableProperty(我想去)
    public let participationButtonEnabled: MutableProperty<Bool> = MutableProperty(true)
    
    
    // MARK: API
    public enum ParticipationChoice : String {
        case 我想去 = "我想去"
        case 我想请客 = "我想请客"
        case 我想AA = "我想 AA"
    }
    
    // MARK: Actions
    /**
    Participate the business with one of the given choices.
    
    :param: choice The ParticipationChoice.
    
    :returns: A SignalProcuer indicating if the operation is successful.
    */
    public func participate(choice: ParticipationChoice) -> SignalProducer<Bool, NSError> {
        return self.userService.currentUserSignal()
            |> flatMap(FlattenStrategy.Merge) { user -> SignalProducer<Bool, NSError> in
                let p = Participation()
                p.user = user
                p.business = self.business
                // TODO: implement participation type.
//                let type = ParticipationType()
//                type.
//                p.participationType =
                return self.participationService.create(p)
            }
            |> on(next: { success in
                // if operation is successful, change the participation button.
                if success {
                    self.alreadyParticipating()
                }
            })
    }
    
    // MARK; Initializers
    public init(userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, business: Business) {
        // services
        self.userService = userService
        self.participationService = participationService
        self.geoLocationService = geoLocationService
        
        self.business = business
        
        self.businessName = ConstantProperty(business.nameSChinese!)
        
        let city = business.city!
        locationText.put(city)
        
        setupLocationText(business)
        setupParticipation(business)
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let userService: IUserService
    private let participationService: IParticipationService
    private let geoLocationService: IGeoLocationService
    private let business: Business
    
    // MARK: Setup
    /**
    Setup participation.
    
    :param: business The business.
    */
    private func setupParticipation(business: Business) {
        /**
        *  Query database to check if user has already participated in this business.
        */
        self.userService.currentUserSignal()
            |> flatMap(FlattenStrategy.Merge) { user -> SignalProducer<Participation, NSError> in
                typealias Property = Participation.Property
                let query = Participation.query()
                
                query.whereKey(Property.User.rawValue, equalTo: user)
                query.whereKey(Property.Business.rawValue, equalTo: business)
                query.includeKey(Property.ParticipationType.rawValue)
                
                return self.participationService.get(query)
            }
            |> start(next: { participation in
                self.alreadyParticipating()
            })
    }
    
    /**
    Setup location text.
    
    :param: business The business
    */
    private func setupLocationText(business: Business) {
        /**
        *  Calculate ETA to the business.
        */
        self.geoLocationService.calculateETA(business.cllocation)
            |> start(next: { interval in
                let minute = Int(ceil(interval / 60))
                self.locationText.put("\(business.city!) \(CityDistanceSeparator) 开车\(minute)分钟")
            })
    }
    
    private func alreadyParticipating() {
        participationButtonTitle.put(已参与)
        participationButtonEnabled.put(false)
    }
}
