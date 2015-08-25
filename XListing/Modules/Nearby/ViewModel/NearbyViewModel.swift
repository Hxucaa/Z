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
    Navigate to Detail Module.
    
    :param: businessViewModel The business information to pass along.
    */
    public func pushDetailModule(section: Int) {
        router.pushDetail(businessArr.value[section])
    }
    
    public func pushProfileModule() {
        router.pushProfile()
    }
    
    // MARK: Initializers
    public init(router: IRouter, businessService: IBusinessService, geoLocationService: IGeoLocationService, imageService: IImageService) {
        self.router = router
        self.businessService = businessService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        getBusinessesWithQuery(Business.query(), isPagination: false)
            |> start()
    }
    
    private func getNearestBusinesses(centreGeoPoint: AVGeoPoint) -> SignalProducer<Void, NSError>{
        let query = Business.query()
        query.whereKey(Business.Property.Geopoint.rawValue, nearGeoPoint: centreGeoPoint)
        return getBusinessesWithQuery(query, isPagination: false)
            |> map { [weak self] _ in
                return
            }
    }
    
    public func getAdditionalBusinesses(centreLat: CLLocationDegrees, centreLong: CLLocationDegrees, skip: Int) -> SignalProducer<Void, NSError> {
        let query = Business.query()
        let centreGeoPoint = AVGeoPoint(latitude: centreLat, longitude: centreLong)
        query.whereKey(Business.Property.Geopoint.rawValue, nearGeoPoint: centreGeoPoint)
        query.skip = skip
        return getBusinessesWithQuery(query, isPagination: true)
            |> map { [weak self] _ in
                return
        }
    }
    
    // fetch the businesses that are within radius km of the centre coordinates of the map
    public func getBusinessesWithMap(centreLat: CLLocationDegrees, centreLong: CLLocationDegrees, radius: Double) -> SignalProducer<Void, NSError> {
        let query = Business.query()!
        let centreGeoPoint = AVGeoPoint(latitude: centreLat, longitude: centreLong)
        query.whereKey(Business.Property.Geopoint.rawValue, nearGeoPoint: centreGeoPoint, withinKilometers: radius)
        
        return getBusinessesWithQuery(query, isPagination: false)
            |> flatMap(.Merge) { data in
                if data.count < 1 {
                    return self.getNearestBusinesses(centreGeoPoint)
                }
                else {
                    return SignalProducer<Void, NSError>.empty
                }
            }
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let router: IRouter
    private let businessService: IBusinessService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    private var businessArr: MutableProperty<[Business]> = MutableProperty([Business]())

    private func getBusinessesWithQuery(query: AVQuery, isPagination: Bool) -> SignalProducer<[NearbyTableCellViewModel], NSError> {
        // TODO: implement default location.
        query.limit = 10
        return businessService.findBy(query)
            |> on(next: { businesses in
                self.fetchingData.put(true)
                if isPagination {
                    self.businessArr.value.extend(businesses)
                } else {
                    self.businessArr.put(businesses)
                }
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
                    if isPagination {
                        self.businessViewModelArr.value.extend(response)
                    } else {
                        self.businessViewModelArr.put(response)
                        }
                    }
                },
                error: { NearbyLogError($0.description) }
            )
    }

}