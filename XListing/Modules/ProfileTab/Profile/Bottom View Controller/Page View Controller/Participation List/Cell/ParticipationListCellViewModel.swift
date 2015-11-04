//
//  ParticipationListCellViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Dollar

public final class ParticipationListCellViewModel : IParticipationListCellViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    private let _coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
    public var coverImage: AnyProperty<UIImage?> {
        return AnyProperty(_coverImage)
    }
    
    private let _businessName: ConstantProperty<String>
    public var businessName: AnyProperty<String> {
        return AnyProperty(_businessName)
    }
    
    private let _city: ConstantProperty<String>
    public var city: AnyProperty<String> {
        return AnyProperty(_city)
    }
    
    private let _district: ConstantProperty<String>
    
    private let _participation: MutableProperty<String>
    public var participation: AnyProperty<String> {
        return AnyProperty(_participation)
    }
    
    private let _eta: MutableProperty<String?> = MutableProperty(nil)
    public var eta: AnyProperty<String?> {
        return AnyProperty(_eta)
    }
    
    // MARK: - Properties
    
    // MARK: Services
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    public init(geoLocationService: IGeoLocationService, imageService: IImageService, businessName: String?, city: String?, district: String?, cover: ImageFile?, geolocation: Geolocation?, aaCount: Int, treatCount: Int, toGoCount: Int) {
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        
        if let businessName = businessName {
            self._businessName = ConstantProperty(businessName)
        } else {
            self._businessName = ConstantProperty("")
        }
        if let city = city {
            self._city = ConstantProperty(city)
        } else {
            self._city = ConstantProperty("")
        }
        if let district = district {
            self._district = ConstantProperty(district)
        } else {
            self._district = ConstantProperty("")
        }
        
        _participation = MutableProperty("\(aaCount + treatCount + toGoCount)+ 人想去")
        
        if let geolocation = geolocation {
            setupEta(geolocation.cllocation)
        }
        
        if let url = cover?.url, nsurl = NSURL(string: url) {
            imageService.getImage(nsurl)
                .start(next: {
                    self._coverImage.put($0)
                })
        }
    }
    
    // MARK: - Setups
    
    // MARK: - Others
    private func setupEta(destination: CLLocation) {
        self.geoLocationService.calculateETA(destination)
            .start(next: { interval in
                let minute = Int(ceil(interval / 60))
                self._eta.put(" \(CITY_DISTANCE_SEPARATOR) 开车\(minute)分钟")
                }, error: { error in
                    ProfileLogError(error.description)
            })
    }
}