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
    
    public let businessName: ConstantProperty<String>
    public let city: ConstantProperty<String>
    public let eta: MutableProperty<String> = MutableProperty("")
    public let price: MutableProperty<String> = MutableProperty("")
    public let district: ConstantProperty<String>
    public let coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
    public let isCoverImageConsumed = MutableProperty<Bool>(false)
    public let participation: MutableProperty<String> = MutableProperty<String>("")
    public let userArr: MutableProperty<[User]> = MutableProperty([User]())
    public let participationArr: MutableProperty<[Participation]> = MutableProperty([Participation]())

    
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
        if let geopoint = geopoint {
            setupEta(CLLocation(latitude: geopoint.latitude, longitude: geopoint.longitude))
        }
        
        participation.put("\(participationCount)+ 人想去")
        
        if let url = cover?.url, nsurl = NSURL(string: url) {
            self.imageService.getImage(nsurl)
                |> start(next: {
                    self.coverImage.put($0)
                })
        }
        if let business = business {
            getAttendees(business)
                |> start()
            
        }
    }
    // "http://lasttear.com/wp-content/uploads/2015/03/interior-design-ideas-furniture-architecture-mesmerizing-chinese-restaurant-interior-with-red-nuance-inspiring.jpg"
    
    // MARK: - Private
    
    // MARK: Services
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    private let participationService: IParticipationService

    
    // MARK: Setup
    
    private func setupEta(destination: CLLocation) {
        self.geoLocationService.calculateETA(destination)
            |> start(next: { interval in
                let minute = Int(ceil(interval / 60))
                self.eta.put(" \(CITY_DISTANCE_SEPARATOR) 开车\(minute)分钟")
            }, error: { error in
                FeaturedLogError(error.description)
            })
    }
    
    
    // MARK: Network call
    private func getAttendees(business: Business) -> SignalProducer<[User], NSError> {
        
        let query = Participation.query()!
        typealias Property = Participation.Property
        query.whereKey(Property.Business.rawValue, equalTo: business)
        query.includeKey(Property.User.rawValue)
        //                query.whereKey(Property.User.rawValue, equalTo: currentUser)
        
        return participationService.findBy(query)
            |> on(next: { participations in
                self.participationArr.put(participations)
            })
            |> map { participations -> [User] in
                // map participation to its view model
                FeaturedLogDebug("participation returned \(participations.count)")
                return participations.map {
                    $0.user
                }
            }
            |> on(
                next: { response in
                    self.userArr.put(response)
                },
                error: { FeaturedLogError($0.customErrorDescription) }
            )
    }
}