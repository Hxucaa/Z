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
    public let price: MutableProperty<Int> = MutableProperty(0)
    public let district: ConstantProperty<String>
    public let coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
    public let isCoverImageConsumed = MutableProperty<Bool>(false)
    public let participation: MutableProperty<String> = MutableProperty<String>("")
    public let userArr: MutableProperty<[User]> = MutableProperty([User]())
    public let participationArr: MutableProperty<[Participation]> = MutableProperty([Participation]())
    public let business: MutableProperty<Business> = MutableProperty(Business())
    public let buttonEnabled: MutableProperty<Bool> = MutableProperty(true)
    
    
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
        if let business = business{
            self.business.put(business)
        }
        
        
        participation.put("\(participationCount)+ 人想去")
        
        if let url = cover?.url, nsurl = NSURL(string: url) {
            self.imageService.getImage(nsurl)
                |> start(next: {
                    self.coverImage.put($0)
                })
        }
        if let business = business {
                self.price.put(business.price)
            getAttendees(business)
                |> start()
            setupParticipation(business)
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
                self.eta.put("\(minute)分钟")
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
        query.includeKey(Property.User.rawValue+"."+User.Property.ProfileImg.rawValue)
        query.limit = 8
        
        return participationService.findBy(query)
            |> on(next: { participations in
                self.participationArr.put(participations)
            })
            |> map { participations -> [User] in
                // map participation to its view model
 //               FeaturedLogDebug("participation returned \(participations.count)")
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
    
    
    public func participate(choice: ParticipationChoice) -> SignalProducer<Bool, NSError> {
        return self.userService.currentLoggedInUser()
            |> flatMap(FlattenStrategy.Merge) { user -> SignalProducer<Bool, NSError> in
                let p = Participation()
                p.user = user
                p.business = self.business.value
                return self.participationService.create(p)
            }
            |> on(next: { success in
                // if operation is successful, change the participation button.
                if success {
                    self.buttonEnabled.put(false)
                }
            })
    }
    
    private func setupParticipation(business: Business) -> Disposable {
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
            |> start(next: { participation in
//                self.buttonEnabled.put(false)
            })
    }

}