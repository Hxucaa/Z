////
////  IParticipationListViewModel.swift
////  XListing
////
////  Created by Lance Zhu on 2015-10-07.
////  Copyright (c) 2015 ZenChat. All rights reserved.
////
//
//import Foundation
//import ReactiveCocoa
//import ReactiveArray
//
//public protocol IParticipationListViewModel : class, IInfinityScrollDataSource, IPullToRefreshDataSource, IPredictiveScrollDataSource {
//    
//    // MARK: - Properties
//    var navigator: ProfileNavigator? { get set }
//    
//    // MARK: - Outputs
//    var collectionDataSource: ReactiveArray<IParticipationListCellViewModel> { get }
//    
//    // MARK: - API
//    func removeDataAtIndex(index: Int) -> SignalProducer<Bool, NSError>
//    func pushSocialBusinessModule(section: Int, animated: Bool)
//    func getBusinessAtIndex(index: Int) -> Business
//}