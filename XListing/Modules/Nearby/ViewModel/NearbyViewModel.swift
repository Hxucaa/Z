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
    
    // MARK: - Inputs
    
    // MARK: - Outputd
    private let _businessViewModelArr: MutableProperty<[NearbyTableCellViewModel]> = MutableProperty([NearbyTableCellViewModel]())
    public var businessViewModelArr: PropertyOf<[NearbyTableCellViewModel]> {
        return PropertyOf(_businessViewModelArr)
    }
    private let _fetchingData: MutableProperty<Bool> = MutableProperty(false)
    public var fetchingData: PropertyOf<Bool> {
        return PropertyOf(_fetchingData)
    }
    
    // MARK: - Properties
    // MARK: Services
    private let router: IRouter
    private let businessService: IBusinessService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    private var businessArr: MutableProperty<[Business]> = MutableProperty([Business]())
    
    // MARK: - API
    
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
    
    // fetch additional businesses from the search origin while skipping the number of businesses already on the map-- query used for pagination
    public func getAdditionalBusinesses(searchOrigin: CLLocation, skip: Int) -> SignalProducer<Void, NSError> {
        let query = Business.query()
        let centreGeoPoint = AVGeoPoint(latitude: searchOrigin.coordinate.latitude, longitude: searchOrigin.coordinate.longitude)
        query.whereKey(Business.Property.Geopoint.rawValue, nearGeoPoint: centreGeoPoint)
        query.skip = skip
        return getBusinessesWithQuery(query, isPagination: true)
            |> map { [weak self] _ in
                return
            }
    }
    
    // fetch the businesses that are within radius km of the search origin
    public func getBusinessesWithMap(searchOrigin: CLLocation, radius: Double) -> SignalProducer<Void, NSError> {
        let query = Business.query()!
        let centreGeoPoint = AVGeoPoint(latitude: searchOrigin.coordinate.latitude, longitude: searchOrigin.coordinate.longitude)
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
    
    // MARK: - Initializers
    public init(router: IRouter, businessService: IBusinessService, geoLocationService: IGeoLocationService, imageService: IImageService) {
        self.router = router
        self.businessService = businessService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        getBusinessesWithQuery(Business.query(), isPagination: false)
            |> start()
    }
    
    // MARK - Others
    
    // get the closest businesses from a certain geopoint
    private func getNearestBusinesses(centreGeoPoint: AVGeoPoint) -> SignalProducer<Void, NSError>{
        let query = Business.query()
        query.whereKey(Business.Property.Geopoint.rawValue, nearGeoPoint: centreGeoPoint)
        return getBusinessesWithQuery(query, isPagination: false)
            |> map { [weak self] _ in
                return
            }
    }

    private func getBusinessesWithQuery(query: AVQuery, isPagination: Bool) -> SignalProducer<[NearbyTableCellViewModel], NSError> {
        // TODO: implement default location.
        query.limit = 3
        return businessService.findBy(query)
            |> on(next: { businesses in
                self._fetchingData.put(true)
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
                    self._fetchingData.put(false)
                    if response.count > 0 {
                        
                        // if we are doing pagination, append the new businesses to the existing array, otherwise replace it
                        if isPagination {
                            self._businessViewModelArr.value.extend(response)
                        } else {
                            self._businessViewModelArr.put(response)
                        }
                    }
                },
                error: { NearbyLogError($0.description) }
            )
    }

}