//
//  LandingPageView.swift
//  XListing
//
//  Created by Lance Zhu on 2016-07-05.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

/**
There are two version of LandingPageView depending on where the account module is initiazted from.
Each of which has a slightly different interface. When it is the first time the account module is 
loaded, the `StartUpButtonsView` is loaded. However, when other modules present the account module, 
the `RePromptButtonsView` is loaded.
*/

import Foundation
import UIKit
import RxSwift
import RxCocoa

private let StartUpButtonsViewNibName = "StartUpButtonsView"
private let RePromptButtonsViewNibName = "RePromptButtonsView"
private let BackButtonNibName = "BackButton"

final class LandingPageView : UIView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var skipButton: UIButton?
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var dividerLabel: UILabel?
    @IBOutlet private weak var backButton: UIButton?
    
    var skipEvent: ControlEvent<Void>? {
        return skipButton?.rx_tap
    }
    
    var loginEvent: ControlEvent<Void> {
        return loginButton.rx_tap
    }
    
    var signUpEvent: ControlEvent<Void> {
        return signUpButton.rx_tap
    }
    
    // MARK: - Setups
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    private func setupButtonsView(nibName: String) {
        
        // load view
        let view = UINib(nibName: nibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
        // add to subview
        addSubview(view)
        
        // turn off autoresizing mask off to allow custom autolayout constraints
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // add constraints
        addConstraints(
            [
                // set height to 109
                NSLayoutConstraint(
                    item: view,
                    attribute: NSLayoutAttribute.Height,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.NotAnAttribute,
                    multiplier: 1.0,
                    constant: 109.0
                ),
                // set width to 247
                NSLayoutConstraint(
                    item: view,
                    attribute: NSLayoutAttribute.Width,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.NotAnAttribute,
                    multiplier: 1.0,
                    constant: 247.0
                ),
                // center at X = 0
                NSLayoutConstraint(
                    item: view,
                    attribute: NSLayoutAttribute.CenterX,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: self,
                    attribute: NSLayoutAttribute.CenterX,
                    multiplier: 1.0,
                    constant: 0.0
                ),
                // botom space to view is 67
                NSLayoutConstraint(
                    item: self,
                    attribute: NSLayoutAttribute.Bottom,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: view,
                    attribute: NSLayoutAttribute.Bottom,
                    multiplier: 1.0,
                    constant: 67.0
                )
            ]
        )
    }
    
    private func setupBackButton() {
        
        // load back button
        let backButtonView = UINib(nibName: BackButtonNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
        // add back button to subview
        addSubview(backButtonView)
        
        // turn off autoresizing mask off to allow custom autolayout constraints
        backButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        // leading margin 8.0
        let backButtonLeading = NSLayoutConstraint(
            item: backButtonView,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.LeadingMargin,
            multiplier: 1.0,
            constant: 0
        )
        backButtonLeading.identifier = "backButton leading constraint"
        
        // top margin 8.0
        let backButtonTop = NSLayoutConstraint(
            item: backButtonView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.TopMargin,
            multiplier: 1.0,
            constant: 9.0
        )
        backButtonTop.identifier = "backButton top constraint"
        
        // add constraints
        addConstraints(
            [
                backButtonLeading,
                backButtonTop
            ]
        )
    }
    
    // MARK: - Bindings
    func bindToData(isRePrompt: Bool) {
        
        // conditionally load subviews
        if isRePrompt {
            setupButtonsView(RePromptButtonsViewNibName)
            setupBackButton()
        }
        else {
            setupButtonsView(StartUpButtonsViewNibName)
        }
        
        signUpButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = 8
        
        skipButton?.layer.masksToBounds = true
        skipButton?.layer.cornerRadius = 8
        
        dividerLabel?.layer.masksToBounds = false
        dividerLabel?.layer.shadowRadius = 3.0
        dividerLabel?.layer.shadowOpacity = 0.5
        dividerLabel?.layer.shadowOffset = CGSize.zero
    }
    
    // MARK: - Others
}