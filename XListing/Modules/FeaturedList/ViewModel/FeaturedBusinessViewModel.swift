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
    public let participation: MutableProperty<String> = MutableProperty("")
    
    public init(geoLocationService: IGeoLocationService, imageService: IImageService, businessName: String?, city: String?, district: String?, cover: AVFile?, geopoint: AVGeoPoint?, participationCount: Int, business: Business?) {
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        
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
        
//       getAttendees()
    }
    // "http://lasttear.com/wp-content/uploads/2015/03/interior-design-ideas-furniture-architecture-mesmerizing-chinese-restaurant-interior-with-red-nuance-inspiring.jpg"
    
    // MARK: - Private
    
    // MARK: Services
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
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
//    private func getParticipations(user : User) -> SignalProducer<[ProfileBusinessViewModel], NSError> {
//        let query = Participation.query()!
//        typealias Property = Participation.Property
//        query.whereKey(Property.User.rawValue, equalTo: user)
//        query.includeKey(Property.Business.rawValue)
//        
//        return participationService.findBy(query)
//            |> on(next: { participations in
//                self.fetchingData.put(true)
//                self.participationArr.put(participations)
//                self.businessArr.put(participations.map { $0.business })
//            })
//            |> map { participations -> [ProfileBusinessViewModel] in
//                
//                // map participation to its view model
//                return participations.map {
//                    let business = $0.business
//                    let viewmodel = ProfileBusinessViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, businessName: business.nameSChinese, city: business.city, district: business.district, cover: business.cover, geopoint: business.geopoint, participationCount: business.wantToGoCounter)
//                    return viewmodel
//                }
//            }
//            |> on(
//                next: { response in
//                    self.profileBusinessViewModelArr.put(response)
//                    self.fetchingData.put(false)
//                },
//                error: { ProfileLogError($0.customErrorDescription) }
//        )
//    }
    
}