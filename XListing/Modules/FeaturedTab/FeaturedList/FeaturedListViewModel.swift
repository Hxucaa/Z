//
//  FeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct FeaturedListCellData {
    let businessInfo: BusinessInfo
    let participantsPreview: [UserInfo]
    let eta: Driver<String>
}

final class FeaturedListViewModel : _BaseViewModel, IFeaturedListViewModel, ViewModelInjectable {
        
    // MARK: - Outputs
    var collectionDataSource: Driver<[SectionModel<String, FeaturedListCellData>]> {
        return _collectionDataSource
    }
    private var _collectionDataSource: Driver<[SectionModel<String, FeaturedListCellData>]>!
    typealias ParticipantsPreview = [User]
    typealias BusinessWithParticipantsPreview = (Business, ParticipantsPreview)
    
    // MARK: - Properties
    // MARK: Services
    private let businessRepository: IBusinessRepository
    private let userRepository: IUserRepository
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    
    
    // MARK: - Initializers
    typealias Dependency = (router: IRouter, businessRepository: IBusinessRepository, userRepository: IUserRepository, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService)
    
    typealias Token = Void
    
    typealias Input = (modelSelected: Driver<BusinessInfo>, refreshTrigger: Observable<Void>, fetchMoreTrigger: FetchMoreTrigger)
    
    init(dep: Dependency, token: Token, input: Input) {
        
        businessRepository = dep.businessRepository
        userRepository = dep.userRepository
        geoLocationService = dep.geoLocationService
        userDefaultsService = dep.userDefaultsService
        
        super.init(router: dep.router)
        
        _collectionDataSource = input.refreshTrigger
            .flatMapLatest { [unowned self] _ -> Observable<[Business]> in
                dep.businessRepository.findByCurrentLocation(input.fetchMoreTrigger.skipUntil(self.collectionDataSource.asObservable()))
            }
            .flatMap { result -> Observable<[BusinessWithParticipantsPreview]> in
                result.map { bus in
                    dep.userRepository.findAPreviewOfParticipants(bus)
                        .map { (bus, $0) }
                    }
                    .zip { $0 }
            }
            .map { data -> [SectionModel<String, FeaturedListCellData>] in
                
                let tdata = data.map { (business: Business, participantsPreview: [User]) -> FeaturedListCellData in
                    let participantsInfo = participantsPreview.map { UserInfo(user: $0 ) }
                    let businessInfo = BusinessInfo(business: business)
                    
                    
                    
                    return FeaturedListCellData(
                        businessInfo: businessInfo,
                        participantsPreview: participantsInfo,
                        eta: dep.geoLocationService.calculateETA(business.address.geoLocation.cllocation)
                            .map { interval -> String in
                                let minute = Int(ceil(interval / 60))
                                return "\(minute)分钟"
                            }
                            .asDriver(onErrorJustReturn: "")
                    )
                }
                
                let sections = [SectionModel(model: "BusinessInfo", items: tdata)]
                
                return sections
            }
            // FIXME: This is possibly a crash. maybe implement like ActivityIndicator???
            //                dep.router.presentError($0 as! NetworkError)
            .asDriver(onErrorJustReturn: Array<SectionModel<String, FeaturedListCellData>>.empty)
        
        input.modelSelected
            .driveNext {
                dep.router.toSoclaBusiness($0)
            }
            .addDisposableTo(disposeBag)
        
        
        [dep.businessRepository.activityIndicator, dep.userRepository.activityIndicator]
            .combineLatest { $0.reduce(true) { $0 || $1 } }
            .distinctUntilChanged()
            .drive(UIApplication.sharedApplication().rx_networkActivityIndicatorVisible)
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - Helper
    
    
}