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
        
        /**
        *  Setup doneButton
        */
        _doneButton.setTitle("完 成", forState: .Normal)
        
        // Button action
        let doneAction = Action<UIButton, Void, NSError> { [weak self] button in
            return SignalProducer<Void, NSError> { sink, disposable in
                
                if let this = self, viewmodel = self?.viewmodel.value {
                    
                    // Update profile and show the HUD
                    disposable += viewmodel.areAllProfileInputsPresent.producer
                        // only valid input goes through
                        |> filter { $0 }
                        // delay the signal due to the animation of retracting keyboard
                        // this cannot be executed on main thread, otherwise UI will be blocked
                        |> delay(Constants.HUD_DELAY, onScheduler: QueueScheduler())
                        // return the signal to main/ui thread in order to run UI related code
                        |> observeOn(UIScheduler())
                        |> flatMap(.Concat) { _ in
                            return HUD.show()
                        }
                        // map error to the same type as other signal
                        |> promoteErrors(NSError)
                        // update profile
                        |> flatMap(.Concat) { _ in
                            return viewmodel.updateProfile
                        }
                        // dismiss HUD based on the result of update profile signal
                        |> HUD.dismissWithStatusMessage(errorHandler: { error -> String in
                            AccountLogError(error.description)
                            return error.customErrorDescription
                        })
                        // does not `sendCompleted` because completion is handled when HUD is disappeared
                        |> start(
                            error: { error in
                                sendError(sink, error)
                            },
                            interrupted: { _ in
                                sendInterrupted(sink)
                            }
                    )
                    
                    // Subscribe to touch down inside event
                    disposable += HUD.didTouchDownInsideNotification()
                        |> on(next: { _ in AccountLogVerbose("HUD touch down inside.") })
                        |> start(
                            next: { _ in
                                // dismiss HUD
                                HUD.dismiss()
                            }
                    )
                    
                    // Subscribe to disappear notification
                    disposable += HUD.didDissappearNotification()
                        |> on(next: { _ in AccountLogVerbose("HUD disappeared.") })
                        |> start(next: { status in
                            if status == HUD.DisappearStatus.Normal {
                                proxyNext(this._doneSink, ())
                            }
                            
                            // completes the action
                            sendNext(sink, ())
                            sendCompleted(sink)
                        })
                    
                    // Add the signals to CompositeDisposable for automatic memory management
                    disposable.addDisposable {
                        AccountLogVerbose("Update profile action is disposed.")
                    }
                    
                    // retract keyboard
                    self?.endEditing(true)
                }
            }
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
        
        
        /**
        *  Setup view model
        */
        compositeDisposable += viewmodel.producer
            |> ignoreNil
            |> logLifeCycle(LogContext.Account, "viewmodel.producer")
            |> start(next: { [weak self] viewmodel in
                if let this = self {
                    this.photoImageView.rac_image <~ viewmodel.profileImage
                    this.doneButton.rac_enabled <~ viewmodel.isProfileImageValid
                }
            })
        
        animate()
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
        AccountLogVerbose("PhotoView deinitializes.")
    }
    
    // MARK: - Bindings
    
    // MARK: - Others
}