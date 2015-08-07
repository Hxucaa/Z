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
    // MARK: - UI Controls
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var constellationLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    
    // properties
    private var viewModel: ProfileHeaderViewModel?
    private var horoscopeString = ""
    
    
    // MARK: - proxy
    var backProxy: SimpleProxy {
        return _backProxy
    }
    private let (_backProxy, _backSink) = SimpleProxy.proxy()
    
    var editProxy: SimpleProxy {
        return _editProxy
    }
    private let (_editProxy, _editSink) = SimpleProxy.proxy()
    
    // MARK: initialize
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topLeftButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        convertImgToCircle(self.profileImageView)
        topLeftButton?.addTarget(backAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        topRightButton?.addTarget(editAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)

    }
    
    // MARK: Setup
    private lazy var backAction: Action<UIButton, Void, NoError> = Action<UIButton, Void, NoError> { [weak self] button in
        return SignalProducer { sink, disposable in
            if let this = self {
                sendNext(this._backSink, ())
            }
            
            sendCompleted(sink)
        }
    }
    
    
    private lazy var editAction: Action<UIButton, Void, NoError> = Action<UIButton, Void, NoError> { [weak self] button in
        return SignalProducer { sink, disposable in
            if let this = self {
                sendNext(this._editSink, ())
            }
            sendCompleted(sink)
        }
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
    
    private func convertImgToCircle(imageView: UIImageView){
        let imgWidth = CGFloat(imageView.frame.width)
        imageView.layer.cornerRadius = imgWidth / 2
        imageView.layer.masksToBounds = true;
        return
    }


}
