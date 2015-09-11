//
//  FeaturedBusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public final class FeaturedBusinessViewModel {
    
    // MARK: - Outputs
    public let businessName: ConstantProperty<String>
    public let city: ConstantProperty<String>
    public let eta: MutableProperty<String> = MutableProperty("")
    public let price: MutableProperty<Int?>
    public let district: ConstantProperty<String>
    public let coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
    public let isCoverImageConsumed = MutableProperty<Bool>(false)
    public let participationString: MutableProperty<String> = MutableProperty("")
    public let participationArr: MutableProperty<[Participation]> = MutableProperty([Participation]())
    public let participantViewModelArr: MutableProperty<[ParticipantViewModel]> = MutableProperty([ParticipantViewModel]())
    public let buttonEnabled: MutableProperty<Bool?> = MutableProperty(nil)
    
    // MARK: - Properties
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    private let participationService: IParticipationService
    private let business: Business?
    
    // MARK: - Initializers
    public init(userService: IUserService, geoLocationService: IGeoLocationService, imageService: IImageService, participationService: IParticipationService, businessName: String?, city: String?, district: String?, cover: AVFile?, geopoint: AVGeoPoint?, participationCount: Int, business: Business?) {
        
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        self.participationService = participationService
        
        if let businessName = businessName {
            self.businessName = ConstantProperty(businessName)
        } else {
            self.businessName = ConstantProperty("")
        }
        if let city = city {
            self.city = ConstantProperty(city)
        } else {
            self.city = ConstantProperty("")
        }
        if let district = district {
            self.district = ConstantProperty(district)
        } else {
            self.district = ConstantProperty("")
        }
        self.business = business
        self.price = MutableProperty<Int?>(business?.price)
        
        
        participationString.put("来 \(participationCount) | 请 123 | AA 123" )
        
        if let url = cover?.url, nsurl = NSURL(string: url) {
            self.imageService.getImage(nsurl)
                |> start(next: {
                    self.coverImage.put($0)
                })
        }
        if let business = business {
            getPreviewAttendees(business)
                |> start()
            setupParticipation(business)
                |> start()
        }
        if let geopoint = geopoint {
            setupEta(CLLocation(latitude: geopoint.latitude, longitude: geopoint.longitude))
                |> start()
        }
    }

    
    // MARK: - Setups
    
    private func setupEta(destination: CLLocation) -> SignalProducer<NSTimeInterval, NSError> {
        return geoLocationService.calculateETA(destination)
            |> on(
                next: { interval in
                    let minute = Int(ceil(interval / 60))
                    self.eta.put("\(minute)分钟")
                },
                error: { error in
                    FeaturedLogError(error.description)
                }
            )
    }
    
    private func getPreviewAttendees(business: Business) -> SignalProducer<[ParticipantViewModel], NSError> {
        let query = Participation.query()!
        typealias Property = Participation.Property
        query.whereKey(Property.Business.rawValue, equalTo: business)
        // TODO: Only retrieve users that have uploaded photoes and have
        query.includeKey(Property.User.rawValue)
        query.limit = 8
        
        return participationService.findBy(query)
            |> on(next: { participations in
                self.participationArr.put(self.participationArr.value + participations)
            })
            |> map { participations -> [ParticipantViewModel] in
                return participations.map {
                    ParticipantViewModel(imageService: self.imageService, user: $0.user)
                }
            }
            |> on(
                next: { response in
                    self.participantViewModelArr.put(response)
                },
                error: { FeaturedLogError($0.customErrorDescription) }
            )
    }
    
    // MARK: Participate Button Action
    public func participate(choice: ParticipationChoice) -> SignalProducer<Bool, NSError> {
        return self.userService.currentLoggedInUser()
            |> flatMap(FlattenStrategy.Merge) { user -> SignalProducer<Bool, NSError> in
                let p = Participation()
                p.user = user
                if let business = self.business {
                    p.business = business
                }
                return self.participationService.create(p)
            }
            |> on(next: { success in
                // if operation is successful, change the participation button.
                if success {
                    self.buttonEnabled.put(false)
                }
            })
    }
    
    
    //MARK: setup participation view
    private func setupParticipation(business: Business) -> SignalProducer<Participation, NSError> {
        /**
        *  Query database to check if user has already participated in this business.
        */
        return self.userService.currentLoggedInUser()
            |> flatMap(FlattenStrategy.Merge) { user -> SignalProducer<Participation, NSError> in
                typealias Property = Participation.Property
                let query = Participation.query()
                
                query.whereKey(Property.User.rawValue, equalTo: user)
                query.whereKey(Property.Business.rawValue, equalTo: business)
                query.includeKey(Property.ParticipationType.rawValue)
                
                return self.participationService.get(query)
            }
            |> on(error: {[weak self] error in self?.buttonEnabled.put(true)}, next: { [weak self] participation in
                self?.buttonEnabled.put(false)
            })
    }
}