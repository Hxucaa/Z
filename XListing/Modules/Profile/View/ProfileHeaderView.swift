//
//  ProfileHeaderView.swift
//  XListing
//
//  Created by Anson on 2015-07-21.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ProfileHeaderView: UIView {
    @IBOutlet private weak var topRightButton: UIButton!
    @IBOutlet private weak var topLeftButton: UIButton!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var constellationLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    
    private var viewModel: ProfileHeaderViewModel?
    
    private var horoscopeString = ""
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topLeftButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
  
    func bindViewModel(viewmodel: ProfileHeaderViewModel) {
            self.viewModel = viewmodel
            nameLabel.rac_text <~ viewmodel.name
            constellationLabel.rac_text <~ convertHoroscope(viewmodel.horoscope.value)
            ageLabel.rac_text <~ viewmodel.ageGroup
            locationLabel.rac_text <~ viewmodel.district
            
            self.viewModel!.coverImage.producer
                |> ignoreNil
                |> start (next: { [weak self] in
                    self?.profileImageView.setImageWithAnimation($0)
                    })
    }
    
    private func convertHoroscope(horoscope: String?) -> MutableProperty<String> {
        var resultMutable = MutableProperty("");
        if horoscope != nil{
            switch(horoscope!){
            case "白羊座": horoscopeString = horoscope! + "♈️"
            case "金牛座": horoscopeString = horoscope! + "♉️"
            case "双子座": horoscopeString = horoscope! + "♊️"
            case "巨蟹座": horoscopeString = horoscope! + "♋️"
            case "狮子座": horoscopeString = horoscope! + "♌️"
            case "处女座": horoscopeString = horoscope! + "♍️"
            case "天秤座": horoscopeString = horoscope! + "♎️"
            case "天蝎座": horoscopeString = horoscope! + "♏️"
            case "射手座": horoscopeString = horoscope! + "♐️"
            case "摩羯座": horoscopeString = horoscope! + "♑️"
            case "水瓶座": horoscopeString = horoscope! + "♒️"
            case "双鱼座": horoscopeString = horoscope! + "♓️"
            default: horoscopeString = horoscope!
            }
        }
        resultMutable.put(horoscopeString)
        return resultMutable
    }


}
