//
//  FeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-07.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct FeaturedListCellData {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    let businessInfo: BusinessInfo
    let participantsPreview: [UserInfo]
    let eta: Driver<String>
    
//    let pStatus = PublishSubject<Bool>()
    
    init(businessInfo: BusinessInfo, participantsPreview: [UserInfo], eta: Driver<String>) {
        self.businessInfo = businessInfo
        self.participantsPreview = participantsPreview
        self.eta = eta
        
    }
}

final class FeaturedListViewModel : _BaseViewModel, IFeaturedListViewModel, ViewModelInjectable {
    
    // MARK: - Inputs
    let fetchMoreTrigger = PublishSubject<Void>()
    
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
    private let meRepository: IMeRepository
    private let userRepository: IUserRepository
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    
    
    // MARK: - Initializers
    typealias Dependency = (router: IRouter, businessRepository: IBusinessRepository, meRepository: IMeRepository, userRepository: IUserRepository, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService)
    
    typealias Token = Void
    
    typealias Input = (modelSelected: Driver<FeaturedListCellData>, refreshTrigger: Observable<Void>)
    
    init(dep: Dependency, token: Token, input: Input) {
        
        businessRepository = dep.businessRepository
        meRepository = dep.meRepository
        userRepository = dep.userRepository
        geoLocationService = dep.geoLocationService
        userDefaultsService = dep.userDefaultsService
        
        super.init(router: dep.router)
        
        _collectionDataSource = input.refreshTrigger
            .flatMapLatest { [unowned self] _ -> Observable<[Business]> in
                dep.businessRepository.findByCurrentLocation(self.fetchMoreTrigger.asObserver())
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
                                interval / 60
                                    |> ceil
                                    |> Int.init
                                    |> { "\($0)分钟" }
                            }
                            .asDriver(onErrorJustReturn: "")
//                        myParticipationStatus: dep.meRepository.isParticipatingBusiness(business)
//                            .map { $0 ? FeaturedListCellData.BusinessParticipation.Participating : .NotParticipating }
//                            .asDriver(onErrorJustReturn: .NotParticipating),
//                        participate: dep.businessRepository.openEvent(business, eventType: EventType.ToGo)
//                            .map { _ in true }
//                            .asDriver(onErrorJustReturn: false)
                    )
                }
                
                let sections = [SectionModel(model: "Featured Business", items: tdata)]
                
                return sections
            }
            // FIXME: This is possibly a crash. maybe implement like ActivityIndicator???
            //                dep.router.presentError($0 as! NetworkError)
            .asDriver(onErrorJustReturn: Array<SectionModel<String, FeaturedListCellData>>.empty)
        
        input.modelSelected
            .driveNext {
                dep.router.toSoclaBusiness($0.businessInfo)
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