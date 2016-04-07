//
// Created by Lance Zhu on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Cartography

private let HeaderViewHeightRatio = CGFloat(0.30)

final class ProfileViewController : XUIViewController {
    
    typealias InputViewModel = (navigateToProfileEdit: ControlEvent<Void>, dummy: Void) -> IProfileViewModel

    // MARK: - UI Controls
    private let headerView = ProfileHeaderView()
    var bottomViewController: ProfileBottomViewController!
    
    private lazy var editButton: UIButton = {
        let button = UIButton(frame: CGRectMake(345, 27, 26, 30))
        button.userInteractionEnabled = true
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 2, bottom: 3, right: 2)
        button.setImage(UIImage(asset: .Edit_Button), forState: .Normal)
        
        return button
    }()
    
    
    // MARK: - Properties
    private var inputViewModel: InputViewModel!
    private var viewmodel: IProfileViewModel!

    // MARK: - Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        viewmodel = inputViewModel(navigateToProfileEdit: editButton.rx_tap, dummy: ())
        
        if let nickname = viewmodel.nickname,
            horoscope = viewmodel.horoscope,
            ageGroup = viewmodel.ageGroup,
            gender = viewmodel.gender {
            headerView.bindToData(nickname, horoscope: horoscope, ageGroup: ageGroup, gender: gender, whatsUp: viewmodel.whatsUp, profileImageURL: viewmodel.coverPhotoURL)
        }
        
    }
    
    private func setupViews() {
        view.userInteractionEnabled = true
        view.opaque = true
        view.backgroundColor = UIColor.whiteColor()
        
        addChildViewController(bottomViewController)

        view.addSubview(bottomViewController.view)
        view.addSubview(headerView)
        view.addSubview(editButton)
        
        bottomViewController.didMoveToParentViewController(self)
        
        constrain(headerView) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.trailing == $0.superview!.trailing
            $0.height == $0.superview!.height * 0.30
        }
        
        constrain(headerView, bottomViewController.view) {
            $1.leading == $1.superview!.leading
            $1.top == $0.bottom
            $1.trailing == $1.superview!.trailing
            $1.bottom == $1.superview!.bottom
        }
        
        constrain(editButton) {
            $0.width == 26
            $0.height == 30
            $0.trailing == $0.superview!.trailingMargin
            $0.top == $0.superview!.top + 25
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
        navigationController?.hidesBarsOnSwipe = false
        
//        upperViewController.editProxy
//            // forwards events from producer until the view controller is going to disappear
//            .takeUntilViewWillDisappear(self)
//            .logLifeCycle(LogContext.Profile, signalName: "headerView.editProxy")
//            .startWithNext { [weak self] in
//                self?.viewmodel.presentProfileEditModule(true, completion: nil)
//            }
        
//        bottomViewController.fullImageProxy
//            .takeUntilViewWillDisappear(self)
//            .logLifeCycle(LogContext.Profile, signalName: "photoManager.fullImageProxy")
//            .startWithNext { [weak self] in
//                self?.viewmodel.presentFullScreenImageModule(true, completion: nil)
//            }

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Bindings
    
    func bindToViewModel(inputViewModel: InputViewModel) {
        self.inputViewModel = inputViewModel
    }
    
    // MARK: - Others
}