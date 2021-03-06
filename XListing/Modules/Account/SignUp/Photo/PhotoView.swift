//
//  PhotoView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography
import Spring

public final class PhotoView : SpringView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var photoImageView: UIImageView!
    private let imagePicker = UIImagePickerController()
    private let _doneButton = RoundedButton()
    public var doneButton: RoundedButton {
        return _doneButton
    }
    
    // MARK: - Properties
    private var viewmodel: PhotoViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Proxies
    
    /// Present UIImage Picker Controller
    public var presentUIImagePickerProxy: SignalProducer<UIImagePickerController, NoError> {
        return _presentUIImagePickerProxy
    }
    private let (_presentUIImagePickerProxy, _presentUIImagePickerObserver) = SignalProducer<UIImagePickerController, NoError>.proxy()
    
    /// Dismiss UIImage Picker Controller
    public var dismissUIImagePickerProxy: SignalProducer<CompletionHandler?, NoError> {
        return _dismissUIImagePickerProxy
    }
    private let (_dismissUIImagePickerProxy, _dismissUIImagePickerObserver) = SignalProducer<CompletionHandler?, NoError>.proxy()
    
    private let (_doneProxy, _doneObserver) = SimpleProxy.proxy()
    public var doneProxy: SimpleProxy {
        return _doneProxy
    }
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        /**
        *  Setup doneButton
        */
        _doneButton.setTitle("完 成", forState: .Normal)
        
        // Button action
        let doneAction = Action<UIButton, Void, NSError> { [weak self] button in
            return SignalProducer<Void, NSError> { observer, disposable in
                
                self?._doneObserver.proxyNext(())
                observer.sendNext(())
                observer.sendCompleted()            }
        }
        
        doneButton.addTarget(doneAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)

        
        /**
        *  Setup image picker
        */
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        setupImageSelectedSignal()
        
        /**
        *  Setup photo image view
        */
        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
        photoImageView.layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        photoImageView.addGestureRecognizer(tapGesture)
        compositeDisposable += tapGesture.rac_gestureSignal().toSignalProducer()
            .takeUntilRemoveFromSuperview(self)
            .startWithNext { [weak self] _ in
                if let this = self {
                    this._presentUIImagePickerObserver.proxyNext(this.imagePicker)
                }
            }
        
        
        /**
        Setup constraints
        */
        constrain(self) { view in
            view.width == self.frame.width
            view.height == self.frame.height
        }
    }
    
    private func setupImageSelectedSignal() {
        
        // Subscribe to image picker, the signal sends the dictionary with info for the selected image
        compositeDisposable += imagePicker.rac_imageSelectedSignal().toSignalProducer()
            // map to the edited image
            .map { ($0 as! [NSObject : AnyObject])[UIImagePickerControllerEditedImage] as? UIImage }
            .start { [weak self] event in
                switch event {
                case let .Next(image):
                    self?.viewmodel.profileImage.value = image
                    
                    self?._dismissUIImagePickerObserver.sendNext(nil)
                case .Completed:
                    // after dismissing the controller, has to rebind the signal because cancellation caused the signal to stop
                    self?._dismissUIImagePickerObserver.sendNext({ self?.setupImageSelectedSignal() })
                default: break
                }
            }
    }
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("PhotoView deinitializes.")
    }
    
    // MARK: - Bindings
    public func bindToViewModel(viewmodel: PhotoViewModel) {
        self.viewmodel = viewmodel
        
        photoImageView.rac_image <~ viewmodel.profileImage
        doneButton.rac_enabled <~ viewmodel.isProfileImageValid
    }
    
    // MARK: - Others
}
