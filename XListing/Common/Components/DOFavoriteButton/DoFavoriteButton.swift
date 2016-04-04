//
//  DOFavoriteButton.swift
//  DOFavoriteButton
//
//  Created by Daiki Okumura on 2015/07/09.
//  Copyright (c) 2015 Daiki Okumura. All rights reserved.
//
//  This software is released under the MIT License.
//  http://opensource.org/licenses/mit-license.php
//




import UIKit
/**
 
 # how to set image
 * init
 * @IBInspectable
 * doFavButton.image = yourImage
 
 # how to toggle
 * setSelected(true, animated: true)
 * doFavButton.selected = false
 
 */
@IBDesignable
public class DOFavoriteButton: UIButton {
    
    /**
     the magnification of size of image to frame size.
     */
    @IBInspectable public var imageSizeRatio: CGFloat = 0.5
    @IBInspectable public var imageContentSizeRatio: CGFloat = 1.0
    
    @IBInspectable public var image: UIImage! {
        didSet {
            applyCurrentImage()
        }
    }
    @IBInspectable public var imageSelected: UIImage? {
        didSet {
            applyCurrentImage()
        }
    }
    
    @IBInspectable public var imageColorOn: UIColor! = UIColor(red: 255/255, green: 172/255, blue: 51/255, alpha: 1.0) {
        didSet {
            if (selected) {
                imageShape.fillColor = imageColorOn.CGColor
            }
        }
    }
    @IBInspectable public var imageColorOff: UIColor! = UIColor(red: 136/255, green: 153/255, blue: 166/255, alpha: 1.0) {
        didSet {
            if (!selected) {
                imageShape.fillColor = imageColorOff.CGColor
            }
        }
    }
    
    override public var selected : Bool {
        didSet {
            if (selected != oldValue) {
                setSelected(selected, animated: false)
            }
        }
    }
    
    @IBInspectable public var circleColor: UIColor! = UIColor(red: 255/255, green: 172/255, blue: 51/255, alpha: 1.0) {
        didSet {
            circleShape.fillColor = circleColor.CGColor
        }
    }
    
    let maskCircleStartRadius: CGFloat = 0.1
    
    //===================
    // layers
    //===================
    private var imageShape = CAShapeLayer()
    private var circleShape = CAShapeLayer()
    private var circleMask = CAShapeLayer()
    private var allAnimatedLayers: [CAShapeLayer] {
        let layers: [CAShapeLayer] = [
            circleShape,
            circleMask,
            imageShape,
            ]
        return layers
    }
    
    //===================
    // Animations
    //===================
    private var circleExpandAnim: CABasicAnimation!
    private var maskExpandAnim: CABasicAnimation!
    private let activationBounce = CAKeyframeAnimation(keyPath: "transform")
    private let inactivationBounce = CAKeyframeAnimation(keyPath: "transform")
    private let touchShrink = CAKeyframeAnimation(keyPath: "transform")
    private let cancelShrink = CAKeyframeAnimation(keyPath: "transform")
    
    
    var config: DOFavoriteButtonConfig = .defaultConfig
    
    
    public convenience init() {
        self.init(frame: CGRectZero)
    }
    
    public override convenience init(frame: CGRect) {
        self.init(frame: frame, image: UIImage())
    }
    
    public init(frame: CGRect, image: UIImage!, imageSelected: UIImage? = nil, imageSizeRatio: CGFloat? = nil, imageContentSizeRatio: CGFloat? = nil, config: DOFavoriteButtonConfig? = nil) {
        if let config = config {
            self.config = config
        }
        super.init(frame: frame)
        if let ratio = imageSizeRatio {
            self.imageSizeRatio = ratio
        }
        if let imageContentSizeRatio = imageContentSizeRatio {
            self.imageContentSizeRatio = imageContentSizeRatio
        }
        commonInit()
        self.image = image
        self.imageSelected = imageSelected
        applyCurrentImage()
    }
    
    var isWakingUpFromNib = false
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isWakingUpFromNib = true
        // → awakeFromNib
    }
    public override func awakeFromNib() {
        isWakingUpFromNib = false
        commonInit()
        applyCurrentImage()
    }
    
    private func commonInit() {
        setupLayers()
        setupAnimations()
        setupEvents()
    }
    
    
    private func applyCurrentImage() {
        guard !isWakingUpFromNib else { return }
        
        let image: UIImage
        if self.selected && imageSelected != nil {
            image = imageSelected!
        }
        else {
            guard self.image != nil else { return }
            image = self.image
        }
        
        imageShape.mask = CALayer()
        imageShape.mask!.contents = image.CGImage
        imageShape.mask!.bounds = getImageFrame()
        imageShape.mask!.position = getImageCenterPoint()
    }
    
    
    public func setSelected(selected: Bool, animated: Bool) {
        if selected {
            activate(animated: animated)
        }
        else {
            deactivate(animated: animated)
        }
    }
    
    
    private func setupEvents() {
        self.addTarget(self, action: #selector(DOFavoriteButton.touchDown(_:)), forControlEvents: UIControlEvents.TouchDown)
        self.addTarget(self, action: #selector(DOFavoriteButton.touchUpInside(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addTarget(self, action: #selector(DOFavoriteButton.touchDragExit(_:)), forControlEvents: UIControlEvents.TouchDragExit)
        self.addTarget(self, action: #selector(DOFavoriteButton.touchDragEnter(_:)), forControlEvents: UIControlEvents.TouchDragEnter)
        self.addTarget(self, action: #selector(DOFavoriteButton.touchCancel(_:)), forControlEvents: UIControlEvents.TouchCancel)
    }
    func touchDown(sender: DOFavoriteButton) {
        self.layer.opacity = 0.4
        //touchAnimation()
    }
    func touchCancel(sender: DOFavoriteButton) {
        self.layer.opacity = 1.0
        //touchCancelAnimation()
    }
    func touchUpInside(sender: DOFavoriteButton) {
        self.layer.opacity = 1.0
    }
    func touchDragExit(sender: DOFavoriteButton) {
        self.layer.opacity = 1.0
    }
    func touchDragEnter(sender: DOFavoriteButton) {
        self.layer.opacity = 0.4
    }
}






// animations
extension DOFavoriteButton {
    
    private func touchAnimation() {
        animate {
            imageShape.addAnimation(touchShrink)
        }
    }
    
    private func touchCancelAnimation() {
        animate {
            imageShape.addAnimation(cancelShrink)
        }
    }
    
    private func activate(animated animated: Bool) {
        if !selected {
            selected = true
        }
        if imageSelected != nil {
            applyCurrentImage()
        }
        imageShape.fillColor = imageColorOn.CGColor
        if animated {
            animate {
                switch self.config {
                case .NoCharge, .NoChargeMildBound:
                    imageShape.addAnimation(activationBounce)
                default:
                    imageShape.transform = CATransform3DMakeScale(0.0,   0.0,   1.0)
                    circleShape.addAnimation(circleExpandAnim)
                    circleMask.addAnimation(maskExpandAnim)
                    imageShape.addAnimation(activationBounce)
                }
            }
        }
    }
    
    private func deactivate(animated animated: Bool) {
        if selected {
            selected = false
        }
        if imageSelected != nil {
            applyCurrentImage()
        }
        imageShape.fillColor = imageColorOff.CGColor
        if animated {
            animate {
                imageShape.addAnimation(inactivationBounce)
            }
        }
    }
}





public enum DOFavoriteButtonConfig {
    case MaskExpand
    case CircleToShape
    case MaskExpandBig
    case NoCharge
    case MaskExpandMildBound
    case NoChargeMildBound
    
    static var defaultConfig: DOFavoriteButtonConfig = .MaskExpandMildBound
}

// setup animations
private extension DOFavoriteButton {
    
    //=======================
    // Timing Config
    //=======================
    func setupAnimationDurations(conf conf: DOFavoriteButtonConfig, coefficient c: CFTimeInterval = 1) {
        circleExpandAnim.duration = 0.2 * c
        maskExpandAnim.duration = 0.1 * c
        activationBounce.duration = 0.3 * c
        inactivationBounce.duration = 0.275 * c
        touchShrink.duration = 0.2 * c
        cancelShrink.duration = 0.2 * c
        switch conf {
        case .MaskExpand, .MaskExpandBig:
            break
        case .MaskExpandMildBound:
            circleExpandAnim.duration = 0.3 * c
            maskExpandAnim.duration = 0.05 * c
            activationBounce.duration = 0.6 * c
        case .CircleToShape:
            maskExpandAnim.duration = 0.05 * c
        case .NoChargeMildBound:
            activationBounce.duration = 0.45 * c
        case .NoCharge:
            circleExpandAnim.duration = 0.2 * c
            maskExpandAnim.duration = 0.1 * c
            activationBounce.duration = 0.5 * c
            inactivationBounce.duration = 0.275 * c
            touchShrink.duration = 0.2 * c
            cancelShrink.duration = 0.2 * c
        }
    }
    func setupAnimationDelays(conf conf: DOFavoriteButtonConfig, coefficient c: CFTimeInterval = 1) {
        switch conf {
        case .MaskExpand, .MaskExpandBig:
            circleExpandAnim.beginTime = CACurrentMediaTime()
            maskExpandAnim.beginTime = CACurrentMediaTime() + 0.17 * c
            activationBounce.beginTime = CACurrentMediaTime() + 0.22 * c
            inactivationBounce.beginTime = CACurrentMediaTime()
            touchShrink.beginTime = CACurrentMediaTime()
            cancelShrink.beginTime = CACurrentMediaTime()
        case .MaskExpandMildBound:
            circleExpandAnim.beginTime = CACurrentMediaTime()
            maskExpandAnim.beginTime = CACurrentMediaTime() + (circleExpandAnim.duration - maskExpandAnim.duration) * c
            activationBounce.beginTime = maskExpandAnim.beginTime + 0.0 * c
            inactivationBounce.beginTime = CACurrentMediaTime()
            touchShrink.beginTime = CACurrentMediaTime()
            cancelShrink.beginTime = CACurrentMediaTime()
        case .CircleToShape:
            circleExpandAnim.beginTime = CACurrentMediaTime()
            maskExpandAnim.beginTime = CACurrentMediaTime() + 0.25 * c
            activationBounce.beginTime = CACurrentMediaTime() + 0.2 * c
            inactivationBounce.beginTime = CACurrentMediaTime()
            touchShrink.beginTime = CACurrentMediaTime()
            cancelShrink.beginTime = CACurrentMediaTime()
        case .NoCharge, .NoChargeMildBound:
            circleExpandAnim.beginTime = CACurrentMediaTime()
            maskExpandAnim.beginTime = CACurrentMediaTime()
            activationBounce.beginTime = CACurrentMediaTime()
            inactivationBounce.beginTime = CACurrentMediaTime()
            touchShrink.beginTime = CACurrentMediaTime()
            cancelShrink.beginTime = CACurrentMediaTime()
        }
    }
    func setupTimingFunctions(conf conf: DOFavoriteButtonConfig) {
        switch conf {
        case .MaskExpand, .MaskExpandBig, .CircleToShape:
            circleExpandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.1,0.65,0.09,0.88)
            maskExpandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.53,0.25,0.5,0.89)
            activationBounce.setKeyframes(createScaleKeyframes(scales: [
                0.0,
                0.3,
                0.5,
                0.7,
                
                1.2,
                1.25,
                1.2,
                
                0.9,
                0.875,
                0.875,
                0.9,
                
                1.013,
                1.025,
                1.013,
                ], lastIsIdentity: true))
        case .MaskExpandMildBound:
            //                circleExpandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.02,0.59,0.18,0.84)
            //                circleExpandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.52,0.03,0,0.96)
            //                circleExpandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.69,0.26,0.4,0.83)
            //                circleExpandAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            //            circleExpandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.8,0.15,0,0.59)
            circleExpandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.24,0.43,0.26,0.97)
            maskExpandAnim.timingFunction = circleExpandAnim.timingFunction
            activationBounce.setKeyframes(createScaleKeyframes(scales: [
                0.0,
                0.7,
                1.5,
                1.2,
                1.1,
                ], lastIsIdentity: true))
        case .NoChargeMildBound:
            circleExpandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.1,0.65,0.09,0.88)
            maskExpandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.53,0.25,0.5,0.89)
            activationBounce.setKeyframes(createScaleKeyframes(scales: [
                0.0,
                0.1,
                0.3,
                0.5,
                0.7,
                
                1.2,
                1.25,
                1.2,
                ], lastIsIdentity: true))
            
        case .NoCharge:
            circleExpandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.1,0.65,0.09,0.88)
            maskExpandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.53,0.25,0.5,0.89)
            activationBounce.setKeyframes(createScaleKeyframes(scales: [
                0.0,
                0.1,
                0.3,
                0.5,
                0.7,
                
                1.2,
                1.25,
                1.2,
                
                0.9,
                0.875,
                0.875,
                0.9,
                
                1.013,
                1.025,
                1.013,
                
                0.96,
                0.95,
                
                0.96,
                0.99,
                ], lastIsIdentity: true))
        }
        
    }
    
    func setupAnimations() {
        
        //==============================
        // circleExpand
        //==============================
        circleExpandAnim = {
            let anim = CABasicAnimation(keyPath: "transform")
            anim.fromValue = NSValue(CATransform3D: CATransform3DMakeScale(0, 0, 1.0))
            let toScale: CGFloat = 1
            let transform = CATransform3DMakeScale(toScale, toScale, 1.0)
            anim.toValue = NSValue(CATransform3D: transform)
            anim.fillMode = kCAFillModeForwards
            anim.removedOnCompletion = false
            return anim
            }()
        
        //==============================
        // maskExpand
        //==============================
        maskExpandAnim = {
            let toScale = (self.getImageFrame().width + 1) / (maskCircleStartRadius*2)
            let anim = CABasicAnimation(keyPath: "transform")
            let transform = CATransform3DMakeScale(toScale, toScale, 1.0)
            anim.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
            anim.toValue = NSValue(CATransform3D: transform)
            anim.fillMode = kCAFillModeForwards
            anim.removedOnCompletion = false
            return anim
            }()
        
        //==============================
        // image transform animation
        //==============================
        activationBounce.fillMode = kCAFillModeForwards
        activationBounce.removedOnCompletion = false
        
        //===================================
        // touchDown & touchUp animations
        //===================================
        let touchShurinkSize: CGFloat = 1.0
        let touchExpandSize: CGFloat = 1.26
        
        inactivationBounce.setKeyframes([
            [0.0: NSValue(CATransform3D: CATransform3DMakeScale(1.0,   1.0,   1.0))],
            [0.26: NSValue(CATransform3D: CATransform3DMakeScale(touchExpandSize,   touchExpandSize,   1.0))],
            [0.967: NSValue(CATransform3D: CATransform3DMakeScale(1.01,  1.01,  1.0))],
            [0.1: NSValue(CATransform3D: CATransform3DIdentity)],
            ])
        inactivationBounce.fillMode = kCAFillModeForwards
        inactivationBounce.removedOnCompletion = false
        
        
        touchShrink.setKeyframes([
            [0.0: NSValue(CATransform3D: CATransform3DMakeScale(1.0,   1.0,   1.0))],
            [1: NSValue(CATransform3D: CATransform3DMakeScale(touchShurinkSize,   touchShurinkSize,   1.0))],
            //            (0.967, NSValue(CATransform3D: CATransform3DMakeScale(0.99,  0.99,  1.0))),
            //            (0.1, NSValue(CATransform3D: CATransform3DIdentity)),
            ])
        
        cancelShrink.setKeyframes([
            [0.0: NSValue(CATransform3D: CATransform3DMakeScale(touchShurinkSize,   touchShurinkSize,   1.0))],
            //            (0.26, NSValue(CATransform3D: CATransform3DMakeScale(0.9,   0.9,   1.0))),
            [0.967: NSValue(CATransform3D: CATransform3DMakeScale(0.99,  0.99,  1.0))],
            [0.1: NSValue(CATransform3D: CATransform3DIdentity)],
            ])
        
        let durationsCofficient: CFTimeInterval = 1//Double(16 / imageFrame.size.height)
        setupAnimationDurations(conf: self.config, coefficient: durationsCofficient)
        setupAnimationDelays(conf: self.config, coefficient: durationsCofficient)
        setupTimingFunctions(conf: self.config)
    }
}



// setup layers
private extension DOFavoriteButton {
    
    func setupLayers() {
        self.layer.sublayers = nil
        let imageFrame = getImageFrame()
        let imgCenterPoint = CGPointMake(CGRectGetMidX(imageFrame), CGRectGetMidY(imageFrame))
        
        // making small frame
        let circleFrame = imageFrame.scaleSize(imageContentSizeRatio).centeringOnParentFrame(self.frame)
        
        // circle layer
        circleShape.bounds = circleFrame
        circleShape.position = imgCenterPoint
        circleShape.path = UIBezierPath(ovalInRect: circleFrame).CGPath
        circleShape.fillColor = circleColor.CGColor
        circleShape.transform = CATransform3DMakeScale(0.0, 0.0, 1.0)
        self.layer.addSublayer(circleShape)
        
        // circle mask
        circleMask.bounds = circleFrame
        circleMask.position = imgCenterPoint
        circleMask.fillRule = kCAFillRuleEvenOdd
        circleShape.mask = circleMask
        let maskPath = UIBezierPath(rect: circleFrame)
        maskPath.addArcWithCenter(imgCenterPoint, radius: maskCircleStartRadius, startAngle: CGFloat(0.0), endAngle: CGFloat(M_PI * 2), clockwise: true)
        circleMask.path = maskPath.CGPath
        
        // iamge shape
        imageShape.bounds = imageFrame
        imageShape.position = imgCenterPoint
        imageShape.path = UIBezierPath(rect: imageFrame).CGPath
        imageShape.fillColor = imageColorOff.CGColor
        imageShape.actions = ["fillColor": NSNull()]
        self.layer.addSublayer(imageShape)
    }
    
    func getImageFrame() -> CGRect {
        let imageSize = CGSize(
            width : self.frame.size.width  * imageSizeRatio,
            height: self.frame.size.height * imageSizeRatio
        )
        return CGRect(
            x: self.frame.size.width/2  - imageSize.width/2,//center
            y: self.frame.size.height/2 - imageSize.height/2,//center
            width : imageSize.width,
            height: imageSize.height
        )
    }
    
    func getImageCenterPoint() -> CGPoint {
        let imgFrame = self.getImageFrame()
        return CGPointMake(CGRectGetMidX(imgFrame), CGRectGetMidY(imgFrame))
    }
}


// utility methods
private extension DOFavoriteButton {
    func animate(@noescape addAnimations: ()->Void) {
        setupAnimationDelays(conf: self.config)
        allAnimatedLayers.forEach { $0.removeAllAnimations() }
        CATransaction.begin()
        addAnimations()
        CATransaction.commit()
    }
    
    func createScaleKeyframes(scales scales: [CGFloat], lastIsIdentity: Bool) -> [[NSNumber: AnyObject]] {
        var keyframes: [[NSNumber: AnyObject]] = []
        let numOfKeyframe = Float(scales.count + (lastIsIdentity ? 1 : 0))
        let oneFrame = Float(Float(1) / numOfKeyframe)
        var time: Float = 0
        for scale in scales {
            keyframes.append([NSNumber(float: time) : NSValue(CATransform3D: CATransform3DMakeScale(scale, scale, 1.0))])
            time = time + oneFrame
        }
        if lastIsIdentity {
            keyframes.append([NSNumber(float: time) : NSValue(CATransform3D: CATransform3DIdentity)])
        }
        return keyframes
    }
}

private extension CGRect {
    func centeringOnParentFrame(parent: CGRect) -> CGRect {
        var new = self
        new.origin = CGPoint(
            x: parent.size.width/2 - self.width/2,
            y: parent.size.height/2 - self.height/2
        )
        return new
    }
    func scaleSize(scale: CGFloat) -> CGRect {
        var new = self
        new.size = CGSize(
            width: self.size.width * scale,
            height: self.size.height * scale
        )
        return new
    }
}

private extension CALayer {
    func addAnimation(animation: CAPropertyAnimation) {
        self.addAnimation(animation, forKey: animation.keyPath)
    }
}

private extension CAKeyframeAnimation {
    // argument is array of [keyTime: Value]
    func setKeyframes(frames: [[NSNumber: AnyObject]]) {
        var keyTimes: [NSNumber] = []
        var values: [AnyObject] = []
        for frame in frames {
            for (key, value) in frame {
                keyTimes.append(key)
                values.append(value)
            }
        }
        if keyTimes.count != 0 {
            self.keyTimes = keyTimes
        }
        if values.count != 0 {
            self.values = values
        }
    }
}
