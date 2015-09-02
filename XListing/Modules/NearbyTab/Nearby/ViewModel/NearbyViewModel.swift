//
//  NearbyViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit
import AVOSCloud

public final class NearbyViewModel : INearbyViewModel {
    
    // MARK: - Public
    // MARK: Input
    
    // MARK: Output
    public let businessViewModelArr: MutableProperty<[NearbyTableCellViewModel]> = MutableProperty([NearbyTableCellViewModel]())
    public let fetchingData: MutableProperty<Bool> = MutableProperty(false)
    
    // MARK: API
    
    /**
    Get current geo location. If location service fails for any reason, use hardcoded geo location instead.
    
    :returns: A Task that contains a geo location.
    */
    public var currentLocation: SignalProducer<CLLocation, NSError> {
        return geoLocationService.getCurrentLocation()
            |> catch { error -> SignalProducer<CLLocation, NSError> in
                
                return SignalProducer { sink, disposable in
                    // with hardcoded location
                    //TODO: better support for hardcoded location
                    NearbyLogWarning("Location service failed! Using default Vancouver location.")
                    sendNext(sink, CLLocation(latitude: 49.27623, longitude: -123.12941))
                    sendCompleted(sink)
                }
        }
    }
    
    /**
    Navigate to SocialBusiness Module.
    
    :param: businessViewModel The business information to pass along.
    */
    public func pushSocialBusinessModule(section: Int) {
        navigationDelegate.pushSocialBusiness(businessArr.value[section])
    }
    
    // MARK: Initializers
    public init(businessService: IBusinessService, geoLocationService: IGeoLocationService, imageService: IImageService) {
        self.businessService = businessService
        self.geoLocationService = geoLocationService
        self.imageService = imageService

        getBusinessesWithQuery(Business.query())
            |> start()
    }
    
    private func getNearestBusinesses(centreGeoPoint: AVGeoPoint, radius: Double) -> SignalProducer<Void, NSError>{
        let query = Business.query()
        query.whereKey(Business.Property.Geopoint.rawValue, nearGeoPoint: centreGeoPoint)
        query.limit = 20
        return getBusinessesWithQuery(query)
            |> map { [weak self] _ in
                return
            }
    }
    
    // fetch the businesses that are within radius km of the centre coordinates of the map
    public func getBusinessesWithMap(centreLat: CLLocationDegrees, centreLong: CLLocationDegrees, radius: Double) -> SignalProducer<Void, NSError> {
        let query = Business.query()!
        let centreGeoPoint = AVGeoPoint(latitude: centreLat, longitude: centreLong)
        query.whereKey(Business.Property.Geopoint.rawValue, nearGeoPoint: centreGeoPoint, withinKilometers: radius)
        query.limit = 20
        
        return getBusinessesWithQuery(query)
            |> flatMap(.Merge) { data in
                if data.count < 1 {
                    return self.getNearestBusinesses(centreGeoPoint, radius: 50)
                }
                else {
                    return SignalProducer<Void, NSError>.empty
                }
            }
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let businessService: IBusinessService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    public weak var navigationDelegate: NearbyNavigationDelegate!
    private var businessArr: MutableProperty<[Business]> = MutableProperty([Business]())

    private func getBusinessesWithQuery(query: AVQuery) -> SignalProducer<[NearbyTableCellViewModel], NSError> {
        // TODO: implement default location.
        return businessService.findBy(query)
            |> on(next: { businesses in
                self.fetchingData.put(true)
                self.businessArr.put(businesses)
            })
            |> map { businesses -> [NearbyTableCellViewModel] in
                businesses.map {
                    NearbyTableCellViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, businessName: $0.nameSChinese, city: $0.city, district: $0.district, cover: $0.cover, geopoint: $0.geopoint, participationCount: $0.wantToGoCounter)
                }
            }
            |> on(
                next: { response in
                    self.fetchingData.put(false)
                    if response.count > 0 {
                        self.businessViewModelArr.put(response)
                    }
                },
                error: { NearbyLogError($0.description) }
            )
    }

}