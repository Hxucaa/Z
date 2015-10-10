//
//  AssetsKit+extension.swift
//  Pods
//
//  Created by Lance Zhu on 2015-08-24.
//
//

import Foundation

extension AssetsKit {
    
    
    private class func drawingLabel(#draw: Void -> Void, sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, textInput: String? = nil) -> UIImage {
        
        // enter the size of the original drawing
        
        let rect = CGRect(origin: CGPointZero, size: sizeToFit ?? drawingSize)
        UIGraphicsBeginImageContextWithOptions(sizeToFit ?? drawingSize, opaque ?? true, imageContextScale ?? 0)
        
        if let backgroundColor = backgroundColor {
            backgroundColor.set()
            UIRectFill(rect)
        }
        
        draw()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private class func drawing(#draw: Void -> Void, sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        // enter the size of the original drawing
        
        let rect = CGRect(origin: CGPointZero, size: sizeToFit ?? drawingSize)
        UIGraphicsBeginImageContextWithOptions(sizeToFit ?? drawingSize, opaque ?? true, imageContextScale ?? 0)
        
        if let backgroundColor = backgroundColor {
            backgroundColor.set()
            UIRectFill(rect)
        }
        
        draw()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private class func drawingJoinButton(#draw: Void -> Void, sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, ifAA: Bool? = false, ifGo: Bool? = false, ifPay: Bool? = false, ifNotTapped: Bool? = false) -> UIImage {
       
        // enter the size of the original drawing
        
        let rect = CGRect(origin: CGPointZero, size: sizeToFit ?? drawingSize)
        UIGraphicsBeginImageContextWithOptions(sizeToFit ?? drawingSize, opaque ?? true, imageContextScale ?? 0)
        
        if let backgroundColor = backgroundColor {
        backgroundColor.set()
        UIRectFill(rect)
        
        }
        
        draw()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    internal class func x_imageOfJoinButton(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, ifAA: Bool? = false, ifGo: Bool? = false, ifPay: Bool? = false, ifNotTapped: Bool? = false) -> UIImage {
        
        return self.drawingJoinButton(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawJoinButton(scaleX: scaledX, scaleY: scaledY, ifAA: ifAA!, ifGo: ifGo!, ifPay: ifPay!, ifNotTapped: ifNotTapped!)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            ifAA: ifAA,
            ifGo: ifGo,
            ifPay: ifPay,
            ifNotTapped: ifNotTapped
        )
    }
    
    
    internal class func x_imageOfVenusLabel(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, textInput: String? = "") -> UIImage {
        
        return self.drawingLabel(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawVenusLabel(scaleX: scaledX, scaleY: scaledY, generation: textInput!)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            textInput: textInput
        )
    }
    
    internal class func x_imageOfMarsLabel(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, textInput: String? = "") -> UIImage {
        
        return self.drawingLabel(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawMarsLabel(scaleX: scaledX, scaleY: scaledY, generation: textInput!)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            textInput: textInput
        )
    }

    internal class func x_imageOfPriceIcon(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawPriceIcon(scaleX: scaledX, scaleY: scaledY)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfCarIcon(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawCarIcon(scaleX: scaledX, scaleY: scaledY)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfShareButton(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawShareButton(scaleX: scaledX, scaleY: scaledY, ifShadow: shadow!)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfFilterButton(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawFilterButton(scaleX: scaledX, scaleY: scaledY, ifShadow: shadow!)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfSearchButton(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawSearchButton(scaleX: scaledX, scaleY: scaledY)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfProfileButton(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawProfileButton(scaleX: scaledX, scaleY: scaledY, ifPressed: false)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfChatButton(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawChatButton(scaleX: scaledX, scaleY: scaledY, ifPressed: false)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfNearbyButton(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawNearbyButton(scaleX: scaledX, scaleY: scaledY, ifPressed: false)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfHomeButton(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawHomeButton(scaleX: scaledX, scaleY: scaledY, ifPressed: false)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    
    internal class func x_imageOfCakeIcon(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawCakeIcon(scaleX: scaledX, scaleY: scaledY)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfFemaleIcon(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawFemaleIcon(scaleX: scaledX, scaleY: scaledY, ifPressed: false)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfMaleIcon(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawMaleIcon(scaleX: scaledX, scaleY: scaledY, ifPressed: false)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfFlameIcon(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawFlameIcon(scaleX: scaledX, scaleY: scaledY, ifTrending: true)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfEtcIcon(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawEtcIcon(scaleX: scaledX, scaleY: scaledY)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfTreatIcon(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawTreatIcon(scaleX: scaledX, scaleY: scaledY)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
    internal class func x_imageOfWTGIcon(sizeToFit: CGSize?, drawingSize: CGSize, backgroundColor: UIColor? = nil, opaque: Bool? = true, imageContextScale: CGFloat? = 0, pressed: Bool? = false, shadow: Bool? = false) -> UIImage {
        
        return self.drawing(
            draw: {
                // calculate scaleX and scaleY based on size
                let scaledX: CGFloat = (sizeToFit ?? drawingSize).width / drawingSize.width
                let scaledY: CGFloat = (sizeToFit ?? drawingSize).height / drawingSize.height
                // change this function to the appropriate drawing function
                AssetsKit.drawWTGIcon(scaleX: scaledX, scaleY: scaledY)
            },
            
            sizeToFit: sizeToFit,
            drawingSize: drawingSize,
            backgroundColor: backgroundColor,
            opaque: opaque,
            imageContextScale: imageContextScale,
            pressed: pressed,
            shadow: shadow
        )
    }
    
}