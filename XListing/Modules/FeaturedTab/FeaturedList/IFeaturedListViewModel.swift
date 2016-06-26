//
//  IFeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol IFeaturedListViewModel {
    
    // MARK: - Inputs
    var fetchMoreTrigger: PublishSubject<Void> { get }
    
    // MARK: - Outputs
    var collectionDataSource: Driver<[SectionModel<String, FeaturedListCellData>]> { get }
}