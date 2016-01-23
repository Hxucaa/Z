//
//  FullScreenImageViewController.swift
//  
//
//  Created by Bruce Li on 2015-10-14.
//
//

import UIKit
import Cartography
import ReactiveCocoa

public final class FullScreenImageViewController: UIViewController {

    
    private var viewmodel : IFullScreenImageViewModel!
    
    private lazy var photo : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profilepicture"))
        return imageView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "FontAwesome", size: 17)!]
        
        var attributedString = NSAttributedString(string: Icons.Chevron + " 返回", attributes: attributes)
        button.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        let goBack = Action<UIButton, Void, NoError> { button in
            return SignalProducer { observer, disposable in
                self.dismissViewControllerAnimated(true, completion: nil)
                observer.sendCompleted()
            }
        }
        
        button.addTarget(goBack.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        return button
        }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        view.addSubview(photo)
        view.addSubview(backButton)

        
        constrain(photo) { view in
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            
            view.centerY == view.superview!.centerY
        }
        
        constrain(backButton) { view in
            view.leading == view.superview!.leadingMargin
            view.top == view.superview!.topMargin + 5
            view.height == 64
            
        }
        // Do any additional setup after loading the view.
    }

    public func bindToViewModel(viewmodel: IFullScreenImageViewModel) {
        self.viewmodel = viewmodel
    }

}
