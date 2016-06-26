////
////  NearbyViewModel.swift
////  XListing
////
////  Created by Lance Zhu on 2015-04-12.
////  Copyright (c) 2016 Lance Zhu. All rights reserved.
////
//
//import Foundation
//import ReactiveCocoa
//import ReactiveArray
//import MapKit
//import AVOSCloud
//
//public final class NearbyViewModel : INearbyViewModel, ICollectionDataSource {
//    
//    // MARK: - Inputs
//    
//    // MARK: - Outputs
//    public let collectionDataSource = ReactiveArray<NearbyTableCellViewModel>()
//    
//    // MARK: - Properties
//    
//    // MARK: Services
//    private let businessService: IBusinessService
//    private let geoLocationService: IGeoLocationService
//    private let imageService: IImageService
//    
//    // MARK: Variables
//    public weak var navigationDelegate: NearbyNavigationDelegate!
//    
//    // MARK: - API
//    
//    /**
//    Get current geo location. If location service fails for any reason, use hardcoded geo location instead.
//    
//    :returns: A Task that contains a geo location.
//    */
//    public var currentLocation: SignalProducer<CLLocation, NSError> {
//        return geoLocationService.getCurrentLocation()
//            .flatMapError { error -> SignalProducer<CLLocation, NSError> in
//                
//                return SignalProducer { observer, disposable in
//                    //TODO: better support for hardcoded location
//                    NearbyLogWarning("Location service failed! Using default Vancouver location.")
//                    observer.sendNext(CLLocation(latitude: 49.27623, longitude: -123.12941))
//                    observer.sendCompleted()
//                }
//        }
//    }
//    
//    // fetch additional businesses from the search origin while skipping the number of businesses already on the map-- query used for pagination
//    public func getAdditionalBusinesses(searchOrigin: CLLocation) -> SignalProducer<Void, NSError> {
//        let addressQuery = Address.query()
//        let centreGeoPoint = AVGeoPoint(latitude: searchOrigin.coordinate.latitude, longitude: searchOrigin.coordinate.longitude)
//        addressQuery.whereKey(Address.Property.geoLocation, nearGeoPoint: centreGeoPoint)
//        
//        let businessQuery = Business.query()
//        businessQuery.whereKey(Business.Property.address, matchesQuery: addressQuery)
//        businessQuery.includeKey(Business.Property.address)
//        businessQuery.skip = collectionDataSource.array.count
//        
//        return getBusinessesWithQuery(businessQuery, isPagination: true)
//            .map { _ in }
//    }
//    
//    // fetch the businesses that are within radius km of the search origin
//    public func getBusinessesWithMap(searchOrigin: CLLocation, radius: Double) -> SignalProducer<Void, NSError> {
//        let addressQuery = Address.query()
//        let centreGeoPoint = AVGeoPoint(latitude: searchOrigin.coordinate.latitude, longitude: searchOrigin.coordinate.longitude)
//        addressQuery.whereKey(Address.Property.geoLocation, nearGeoPoint: centreGeoPoint)
//        
//        let businessQuery = Business.query()
//        businessQuery.whereKey(Business.Property.address, matchesQuery: addressQuery)
//        businessQuery.includeKey(Business.Property.address)
//        
//        
//        return getBusinessesWithQuery(businessQuery, isPagination: false)
//            .flatMap(.Merge) { data -> SignalProducer<Void, NSError> in
//                if data.count < 1 {
//                    return self.getNearestBusinesses(centreGeoPoint)
//                }
//                else {
//                    return SignalProducer<Void, NSError>.empty
//                }
//        }
//    }
//    
//     /**
//     Navigate to SocialBusiness Module.
//     
//     - parameter section: The business information to pass along.
//     */
//    public func pushSocialBusinessModule(section: Int) {
//        navigationDelegate.pushSocialBusiness(collectionDataSource.array[section].business)
//    }
//    
//    // MARK: Initializers
//    public init(businessService: IBusinessService, geoLocationService: IGeoLocationService, imageService: IImageService) {
//        self.businessService = businessService
//        self.geoLocationService = geoLocationService
//        self.imageService = imageService
//    }
//    
//    // MARK - Others
//    
//    // get the closest businesses from a certain geopoint
//    private func getNearestBusinesses(centreGeoPoint: AVGeoPoint) -> SignalProducer<Void, NSError> {
//        let addressQuery = Address.query()
//        addressQuery.whereKey(Address.Property.geoLocation, nearGeoPoint: centreGeoPoint)
//        
//        let businessQuery = Business.query()
//        businessQuery.whereKey(Business.Property.address, matchesQuery: addressQuery)
//        businessQuery.includeKey(Business.Property.address)
//        return getBusinessesWithQuery(businessQuery, isPagination: false)
//            .map { _ in }
//    }
//
//    private func getBusinessesWithQuery(query: AVQuery, isPagination: Bool) -> SignalProducer<[NearbyTableCellViewModel], NSError> {
//        // TODO: implement default location.
//        query.limit = Constants.PAGINATION_LIMIT
//        return businessService.findBy(query)
//            .map { businesses -> [NearbyTableCellViewModel] in
//                businesses.map {
//                    NearbyTableCellViewModel(geoLocationService: self.geoLocationService, imageService: self.imageService, business: $0)
//                }
//            }
//            .on(
//                next: { viewmodels -> () in
//                    if viewmodels.count > 0 {
//                        // if we are doing pagination, append the new businesses to the existing array, otherwise replace it
//                        if isPagination {
//                            self.collectionDataSource.appendContentsOf(viewmodels)
//                        }
//                        else {
//                            self.collectionDataSource.replaceAll(viewmodels)
//                        }
//                    }
//                },
//                failed: {
//                    NearbyLogError($0.description)
//                }
//            )
//    }
//}