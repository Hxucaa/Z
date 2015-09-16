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
    public var participantViewModelArr: PropertyOf<[ParticipantViewModel]> {
        return PropertyOf(_participantViewModelArr)
    }
    
    private let _isButtonEnabled: MutableProperty<Bool> = MutableProperty(true)
    public var isButtonEnabled: PropertyOf<Bool> {
        return PropertyOf(_isButtonEnabled)
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
        query.limit = 8
        
        return participationService.findBy(query)
            |> on(next: { participations in
                self._participationArr.put(self._participationArr.value + participations)
            })
            |> map { participations -> [ParticipantViewModel] in
                return participations.map {
                    ParticipantViewModel(imageService: self.imageService, user: $0.user)
                }
            }
            |> on(
                next: { response in
                    self._participantViewModelArr.put(response)
                },
                error: { FeaturedLogError($0.customErrorDescription) }
            )
            |> map { _ -> Void in return }
    }
    
    
    public func getUserParticipation() -> SignalProducer<Void, NSError> {
        /**
        *  Query database to check if user has already participated in this business.
        */
        return self.userService.currentLoggedInUser()
            |> flatMap(FlattenStrategy.Merge) { user -> SignalProducer<Participation, NSError> in
                typealias Property = Participation.Property
                let query = Participation.query()
                
                query.whereKey(Property.User.rawValue, equalTo: user)
                query.whereKey(Property.Business.rawValue, equalTo: self.business)
                query.includeKey(Property.ParticipationType.rawValue)
                
                return self.participationService.get(query)
            }
            |> on(next: { [weak self] participation in
                self?._isButtonEnabled.put(false)
            })
            |> map { _ in return }
    }
    
//    /**
//    Participate Button Action
//    
//    :param: choice ParticipationChoice
//    
//    */
//    public func participate(choice: ParticipationType) -> SignalProducer<Bool, NSError> {
//        return self.userService.currentLoggedInUser()
//            |> flatMap(FlattenStrategy.Merge) { user -> SignalProducer<Bool, NSError> in
//                let p = Participation()
//                p.user = user
//                p.business = self.business
//                
//                return self.participationService.create(p)
//            }
//            |> on(next: { [weak self] success in
//                // if operation is successful, change the participation button.
//                if success {
//                    self?._isButtonEnabled.put(false)
//                }
//            })
//    }
    
    // MARK: - Others
}