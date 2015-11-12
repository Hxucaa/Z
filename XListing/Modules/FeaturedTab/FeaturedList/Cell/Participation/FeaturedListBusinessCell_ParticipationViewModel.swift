//
//  FeaturedListBusinessCell_ParticipationViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class FeaturedListBusinessCell_ParticipationViewModel : IFeaturedListBusinessCell_ParticipationViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    private let _participationArr: MutableProperty<[Participation]> = MutableProperty([Participation]())
    
    private let _participantViewModelArr: MutableProperty<[ParticipantViewModel]> = MutableProperty([ParticipantViewModel]())
    public var participantViewModelArr: AnyProperty<[ParticipantViewModel]> {
        return AnyProperty(_participantViewModelArr)
    }
    
    private let _wtgCount: MutableProperty<String> = MutableProperty("0")
    public var wtgCount: AnyProperty<String> {
        return AnyProperty(_wtgCount)
    }
    
    private let _treatCount: MutableProperty<String> = MutableProperty("0")
    public var treatCount: AnyProperty<String> {
        return AnyProperty(_treatCount)
    }
    
    private let _isButtonEnabled: MutableProperty<Bool> = MutableProperty(true)
    public var isButtonEnabled: AnyProperty<Bool> {
        return AnyProperty(_isButtonEnabled)
    }
    
    private let _isWTGEnabled: MutableProperty<Bool> = MutableProperty(false)
    public var isWTGEnabled: AnyProperty<Bool> {
        return AnyProperty(_isWTGEnabled)
    }
    
    private let _isTreatEnabled: MutableProperty<Bool> = MutableProperty(false)
    public var isTreatEnabled: AnyProperty<Bool> {
        return AnyProperty(_isTreatEnabled)
    }
    
    // MARK: - Properties
    private let userService: IUserService
    private let participationService: IParticipationService
    private let imageService: IImageService
    private let business: Business
    
    // MARK: - Initializers
    
    public init(userService: IUserService, imageService: IImageService, participationService: IParticipationService, business: Business?) {
        
        self.userService = userService
        self.imageService = imageService
        self.participationService = participationService
        self.business = business!
    }
    
    // MARK: - Setups
    
    // MARK: - API
    
    public func getParticipantPreview() -> SignalProducer<Void, NSError> {
        let query = Participation.query()!
        typealias Property = Participation.Property
        query.whereKey(Property.Business.rawValue, equalTo: business)
        // TODO: Only retrieve users that have uploaded photoes and have
        query.includeKey(Property.User.rawValue)
        query.limit = 5
        
        return participationService.findBy(query)
            .on(next: { participations in
                self._participationArr.value = self._participationArr.value + participations
            })
            .map { participations -> [ParticipantViewModel] in
                return participations.map {
                    ParticipantViewModel(imageService: self.imageService, user: $0.user)
                }
            }
            .on(
                next: { response in
                    self._participantViewModelArr.value = response
                    
                },
                failed: { FeaturedLogError($0.customErrorDescription) }
            )
            .map { _ -> Void in return }
    }
    
    public func getWTGCount() -> SignalProducer<Void, NSError> {
        let query = Participation.query()!
        typealias Property = Participation.Property
        query.whereKey(Property.Business.rawValue, equalTo: business)
        //query.whereKey(Property.ParticipationType.rawValue, equalTo: ParticipationType.ToGo.description)
        return participationService.findBy(query)
            .on(next: { participations in
                self._wtgCount.value = String(participations.count)
            })
            .map { _ -> Void in return }
    }
    
    public func getTreatCount() -> SignalProducer<Void, NSError> {
        let query = Participation.query()!
        typealias Property = Participation.Property
        query.whereKey(Property.Business.rawValue, equalTo: business)
        //query.whereKey(Property.ParticipationType.rawValue, equalTo: ParticipationType.Treat.description)
        return participationService.findBy(query)
            .on(next: { participations in
                self._treatCount.value = String(participations.count)
            })
            .map { _ -> Void in return }
    }
    
    
    public func getUserParticipation() -> SignalProducer<Void, NSError> {
        /**
        *  Query database to check if user has already participated in this business.
        */
        return self.userService.currentLoggedInUser()
            .flatMap(FlattenStrategy.Merge) { user -> SignalProducer<Participation, NSError> in
                typealias Property = Participation.Property
                let query = Participation.query()
                
                query.whereKey(Property.User.rawValue, equalTo: user)
                query.whereKey(Property.Business.rawValue, equalTo: self.business)
                query.includeKey(Property.ParticipationType.rawValue)
                
                return self.participationService.get(query)
            }
            .on(next: { [weak self] participation in
                
                switch participation.type {
                case .ToGo:
                    self?._isWTGEnabled.value = true
                    self?._isTreatEnabled.value = false
                case .Treat:
                    self?._isTreatEnabled.value = true
                    self?._isWTGEnabled.value = false
                case .AA:
                    self?._isWTGEnabled.value = true
                    self?._isTreatEnabled.value = false
                }
                
                
            })
            .map { _ in return }
    }
    
    /**
    Participate Button Action
    
    :param: choice ParticipationChoice
    
    */
    public func participate(choice: ParticipationType) -> SignalProducer<Bool, NSError> {
        return self.userService.currentLoggedInUser()
            .flatMap(FlattenStrategy.Concat) { user -> SignalProducer<Bool, NSError> in
                let p = Participation()
                p.user = user
                p.business = self.business
                
                return self.participationService.create(p)
            }
            .on(next: { [weak self] success in
                // if operation is successful, change the participation button.
                if success {
                    if let this = self {
                        
                        
                        switch choice {
                        case .ToGo:
                            let newWTGCount = Int(this._wtgCount.value)!+1
                            this._wtgCount.value = String(newWTGCount)
                        case .Treat:
                            let newTreatCount = Int(this._treatCount.value)!+1
                            this._treatCount.value = String(newTreatCount)
                        case .AA:
                            let newWTGCount = Int(this._wtgCount.value)!+1
                            this._wtgCount.value = String(newWTGCount)
                            
                        }

                    }
                }
            })
    }
    
    // MARK: - Others
}