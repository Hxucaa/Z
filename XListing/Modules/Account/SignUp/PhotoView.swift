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

public final class PhotoView : UIView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var photoImageView: UIImageView!
    private let imagePicker = UIImagePickerController()
    private let _doneButton = RoundedButton()
    public var doneButton: RoundedButton {
        return _doneButton
    }
    
    // MARK: - Properties
    public let viewmodel = MutableProperty<PhotoViewModel?>(nil)
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Proxies
    
    /// Present UIImage Picker Controller
    public var presentUIImagePickerProxy: SignalProducer<UIImagePickerController, NoError> {
        return _presentUIImagePickerProxy
    }
    private let (_presentUIImagePickerProxy, _presentUIImagePickerSink) = SignalProducer<UIImagePickerController, NoError>.proxy()
    
    /// Dismiss UIImage Picker Controller
    public var dismissUIImagePickerProxy: SignalProducer<CompletionHandler?, NoError> {
        return _dismissUIImagePickerProxy
    }
    private let (_dismissUIImagePickerProxy, _dismissUIImagePickerSink) = SignalProducer<CompletionHandler?, NoError>.proxy()
    
    private let (_doneProxy, _doneSink) = SimpleProxy.proxy()
    public var doneProxy: SimpleProxy {
        return _doneProxy
    }
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        _doneButton.setTitle("完 成", forState: .Normal)
        
        // Button action
        let doneAction = Action<UIButton, Void, NSError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    proxyNext(this._doneSink, ())
                }
                sendCompleted(sink)
            }
        }
        
        doneButton.addTarget(doneAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)

        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        setupImageSelectedSignal()
        
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        photoImageView.addGestureRecognizer(tapGesture)
        compositeDisposable += tapGesture.rac_gestureSignal().toSignalProducer()
            |> takeUntilRemoveFromSuperview(self)
            |> start(
                next: { [weak self] _ in
                    if let this = self {
                        sendNext(this._presentUIImagePickerSink, this.imagePicker)
                    }
                }
            )
        
        /**
        Setup constraints
        */
        let group = layout(self) { view in
            view.width == self.frame.width
            view.height == self.frame.height
        }
        
        
        compositeDisposable += viewmodel.producer
            |> ignoreNil
            |> logLifeCycle(LogContext.Account, "viewmodel.producer")
            |> start(next: { [weak self] viewmodel in
                if let this = self {
                    this.photoImageView.rac_image <~ viewmodel.profileImage
                    this.doneButton.rac_enabled <~ viewmodel.isProfileImageValid
                }
            })
    }
    
    private func setupImageSelectedSignal() {
        
        // Subscribe to image picker, the signal sends the dictionary with info for the selected image
        compositeDisposable += imagePicker.rac_imageSelectedSignal().toSignalProducer()
            // map to the edited image
            |> map { ($0 as! [NSObject : AnyObject])[UIImagePickerControllerEditedImage] as? UIImage }
            |> start(
                // when an image is selected
                next: { [weak self] image in
                    self?.viewmodel.value?.profileImage.put(image)
                    
                    if let this = self {
                        sendNext(this._dismissUIImagePickerSink, nil)
                    }
                },
                // when cancel button is pressed
                completed: { [weak self] in
                    // after dismissing the controller, has to rebind the signal because cancellation caused the signal to stop
                    if let this = self {
                        sendNext(this._dismissUIImagePickerSink, { self?.setupImageSelectedSignal() })
                    }
                }
        )
    }
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("NicknameView deinitializes.")
    }
    
    // MARK: - Bindings
    
    // MARK: - Others
}