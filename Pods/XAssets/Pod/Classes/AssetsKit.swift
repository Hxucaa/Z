//
//  AssetsKit.swift
//  XAssets
//
//  Created by Connor Wang on 2015-08-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

public class AssetsKit : NSObject {

    //// Cache

    private struct Cache {
        static var primaryColor: UIColor = UIColor(red: 0.212, green: 0.663, blue: 0.647, alpha: 1.000)
        static var femaleIconFill: UIColor = UIColor(red: 1.000, green: 0.384, blue: 0.659, alpha: 1.000)
        static var maleIconFill: UIColor = UIColor(red: 0.157, green: 0.302, blue: 0.608, alpha: 1.000)
        static var iconUntapped: UIColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        static var imageOfFemaleIcon: UIImage?
        static var femaleIconTargets: [AnyObject]?
        static var imageOfMaleIcon: UIImage?
        static var maleIconTargets: [AnyObject]?
        static var imageOfCakeIcon: UIImage?
        static var cakeIconTargets: [AnyObject]?
    }

    //// Colors

    public class var primaryColor: UIColor { return Cache.primaryColor }
    public class var femaleIconFill: UIColor { return Cache.femaleIconFill }
    public class var maleIconFill: UIColor { return Cache.maleIconFill }
    public class var iconUntapped: UIColor { return Cache.iconUntapped }

    //// Drawing Methods

    public class func drawLandingIcon(#scale: CGFloat) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()

        //// Color Declarations
        let iconFillColor = AssetsKit.primaryColor.colorWithAlpha(0.7)

        //// Group
        //// Polygon Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 15, 8)
        CGContextScaleCTM(context, scale, scale)

        var polygonPath = UIBezierPath()
        polygonPath.moveToPoint(CGPointMake(131.6, 288.52))
        polygonPath.addLineToPoint(CGPointMake(260.27, 217.86))
        polygonPath.addLineToPoint(CGPointMake(260.27, 71.64))
        polygonPath.addLineToPoint(CGPointMake(131.6, 0))
        polygonPath.addLineToPoint(CGPointMake(0, 71.64))
        polygonPath.addLineToPoint(CGPointMake(0, 217.86))
        polygonPath.addLineToPoint(CGPointMake(131.6, 288.52))
        polygonPath.closePath()
        polygonPath.lineCapStyle = kCGLineCapSquare;

        polygonPath.lineJoinStyle = kCGLineJoinBevel;

        iconFillColor.setFill()
        polygonPath.fill()
        iconFillColor.setStroke()
        polygonPath.lineWidth = 10
        polygonPath.stroke()

        CGContextRestoreGState(context)


        //// Text Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 14, 7)
        CGContextScaleCTM(context, scale, scale)

        let textRect = CGRectMake(0, 0, 260.27, 288.52)
        var textTextContent = NSString(string: "来")
        let textStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.Center

        let textFontAttributes = [NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 180)!, NSForegroundColorAttributeName: UIColor.whiteColor(), NSParagraphStyleAttributeName: textStyle]

        let textTextHeight: CGFloat = textTextContent.boundingRectWithSize(CGSizeMake(textRect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
        CGContextSaveGState(context)
        CGContextClipToRect(context, textRect);
        textTextContent.drawInRect(CGRectMake(textRect.minX, textRect.minY + (textRect.height - textTextHeight) / 2, textRect.width, textTextHeight), withAttributes: textFontAttributes)
        CGContextRestoreGState(context)

        CGContextRestoreGState(context)
    }

    public class func drawFemaleIcon() {

        //// Group
        //// Bezier Drawing
        var bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(17.37, 2.68))
        bezierPath.addCurveToPoint(CGPointMake(13.33, 3.14), controlPoint1: CGPointMake(15.98, 2.68), controlPoint2: CGPointMake(14.63, 2.85))
        bezierPath.addCurveToPoint(CGPointMake(17.37, -0.3), controlPoint1: CGPointMake(13.55, 1.21), controlPoint2: CGPointMake(15.27, -0.3))
        bezierPath.addCurveToPoint(CGPointMake(21.42, 3.14), controlPoint1: CGPointMake(19.48, -0.3), controlPoint2: CGPointMake(21.2, 1.21))
        bezierPath.addCurveToPoint(CGPointMake(17.37, 2.68), controlPoint1: CGPointMake(20.12, 2.85), controlPoint2: CGPointMake(18.78, 2.68))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(17.37, 26.57))
        bezierPath.addCurveToPoint(CGPointMake(15.38, 27.32), controlPoint1: CGPointMake(16.27, 26.57), controlPoint2: CGPointMake(15.38, 26.9))
        bezierPath.addCurveToPoint(CGPointMake(17.37, 28.07), controlPoint1: CGPointMake(15.38, 27.73), controlPoint2: CGPointMake(16.27, 28.07))
        bezierPath.addCurveToPoint(CGPointMake(19.37, 27.32), controlPoint1: CGPointMake(18.48, 28.07), controlPoint2: CGPointMake(19.37, 27.73))
        bezierPath.addCurveToPoint(CGPointMake(17.37, 26.57), controlPoint1: CGPointMake(19.37, 26.9), controlPoint2: CGPointMake(18.48, 26.57))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(34.75, 25.34))
        bezierPath.addCurveToPoint(CGPointMake(31.19, 30.22), controlPoint1: CGPointMake(34.75, 27.61), controlPoint2: CGPointMake(33.26, 29.54))
        bezierPath.addCurveToPoint(CGPointMake(17.4, 38), controlPoint1: CGPointMake(28.54, 34.95), controlPoint2: CGPointMake(23.26, 38))
        bezierPath.addCurveToPoint(CGPointMake(3.63, 30.23), controlPoint1: CGPointMake(11.55, 38), controlPoint2: CGPointMake(6.28, 34.96))
        bezierPath.addCurveToPoint(CGPointMake(0, 25.34), controlPoint1: CGPointMake(1.53, 29.58), controlPoint2: CGPointMake(0, 27.63))
        bezierPath.addCurveToPoint(CGPointMake(1.74, 21.52), controlPoint1: CGPointMake(0, 23.82), controlPoint2: CGPointMake(0.68, 22.46))
        bezierPath.addCurveToPoint(CGPointMake(1.32, 18.25), controlPoint1: CGPointMake(1.48, 20.46), controlPoint2: CGPointMake(1.32, 19.37))
        bezierPath.addCurveToPoint(CGPointMake(17.37, 3.56), controlPoint1: CGPointMake(1.32, 10.15), controlPoint2: CGPointMake(8.53, 3.56))
        bezierPath.addCurveToPoint(CGPointMake(33.43, 18.25), controlPoint1: CGPointMake(26.23, 3.56), controlPoint2: CGPointMake(33.43, 10.15))
        bezierPath.addCurveToPoint(CGPointMake(33.01, 21.52), controlPoint1: CGPointMake(33.43, 19.37), controlPoint2: CGPointMake(33.28, 20.46))
        bezierPath.addCurveToPoint(CGPointMake(34.75, 25.34), controlPoint1: CGPointMake(34.08, 22.46), controlPoint2: CGPointMake(34.75, 23.82))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(31.36, 25.34))
        bezierPath.addCurveToPoint(CGPointMake(29.57, 23.41), controlPoint1: CGPointMake(31.36, 24.28), controlPoint2: CGPointMake(30.56, 23.41))
        bezierPath.addCurveToPoint(CGPointMake(28.63, 24.68), controlPoint1: CGPointMake(29.3, 23.85), controlPoint2: CGPointMake(28.98, 24.28))
        bezierPath.addCurveToPoint(CGPointMake(29.13, 21.61), controlPoint1: CGPointMake(28.94, 23.67), controlPoint2: CGPointMake(29.11, 22.64))
        bezierPath.addCurveToPoint(CGPointMake(21.68, 18.28), controlPoint1: CGPointMake(27.07, 21.59), controlPoint2: CGPointMake(24.23, 20.39))
        bezierPath.addCurveToPoint(CGPointMake(17.38, 12.54), controlPoint1: CGPointMake(19.45, 16.45), controlPoint2: CGPointMake(17.93, 14.32))
        bezierPath.addCurveToPoint(CGPointMake(13.08, 18.28), controlPoint1: CGPointMake(16.82, 14.32), controlPoint2: CGPointMake(15.31, 16.45))
        bezierPath.addCurveToPoint(CGPointMake(5.62, 21.61), controlPoint1: CGPointMake(10.52, 20.39), controlPoint2: CGPointMake(7.69, 21.59))
        bezierPath.addCurveToPoint(CGPointMake(6.13, 24.68), controlPoint1: CGPointMake(5.64, 22.64), controlPoint2: CGPointMake(5.81, 23.67))
        bezierPath.addCurveToPoint(CGPointMake(5.19, 23.41), controlPoint1: CGPointMake(5.77, 24.28), controlPoint2: CGPointMake(5.45, 23.85))
        bezierPath.addCurveToPoint(CGPointMake(3.39, 25.34), controlPoint1: CGPointMake(4.19, 23.41), controlPoint2: CGPointMake(3.39, 24.28))
        bezierPath.addCurveToPoint(CGPointMake(5.19, 27.27), controlPoint1: CGPointMake(3.39, 26.41), controlPoint2: CGPointMake(4.19, 27.27))
        bezierPath.addCurveToPoint(CGPointMake(5.89, 27.12), controlPoint1: CGPointMake(5.43, 27.27), controlPoint2: CGPointMake(5.67, 27.22))
        bezierPath.addCurveToPoint(CGPointMake(17.4, 34.8), controlPoint1: CGPointMake(7.51, 31.58), controlPoint2: CGPointMake(12.05, 34.8))
        bezierPath.addCurveToPoint(CGPointMake(28.91, 27.13), controlPoint1: CGPointMake(22.75, 34.8), controlPoint2: CGPointMake(27.29, 31.59))
        bezierPath.addCurveToPoint(CGPointMake(29.57, 27.27), controlPoint1: CGPointMake(29.12, 27.22), controlPoint2: CGPointMake(29.34, 27.27))
        bezierPath.addCurveToPoint(CGPointMake(31.36, 25.34), controlPoint1: CGPointMake(30.56, 27.27), controlPoint2: CGPointMake(31.36, 26.41))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(11.95, 20.98))
        bezierPath.addCurveToPoint(CGPointMake(10.13, 22.7), controlPoint1: CGPointMake(10.94, 20.98), controlPoint2: CGPointMake(10.13, 21.75))
        bezierPath.addCurveToPoint(CGPointMake(11.95, 24.42), controlPoint1: CGPointMake(10.13, 23.65), controlPoint2: CGPointMake(10.94, 24.42))
        bezierPath.addCurveToPoint(CGPointMake(13.77, 22.7), controlPoint1: CGPointMake(12.95, 24.42), controlPoint2: CGPointMake(13.77, 23.64))
        bezierPath.addCurveToPoint(CGPointMake(11.95, 20.98), controlPoint1: CGPointMake(13.77, 21.75), controlPoint2: CGPointMake(12.96, 20.98))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(22.8, 20.98))
        bezierPath.addCurveToPoint(CGPointMake(20.98, 22.7), controlPoint1: CGPointMake(21.8, 20.98), controlPoint2: CGPointMake(20.98, 21.75))
        bezierPath.addCurveToPoint(CGPointMake(22.8, 24.42), controlPoint1: CGPointMake(20.98, 23.65), controlPoint2: CGPointMake(21.8, 24.42))
        bezierPath.addCurveToPoint(CGPointMake(24.62, 22.7), controlPoint1: CGPointMake(23.81, 24.42), controlPoint2: CGPointMake(24.62, 23.64))
        bezierPath.addCurveToPoint(CGPointMake(22.8, 20.98), controlPoint1: CGPointMake(24.63, 21.75), controlPoint2: CGPointMake(23.81, 20.98))
        bezierPath.closePath()
        AssetsKit.femaleIconFill.setFill()
        bezierPath.fill()
    }

    public class func drawMaleIcon() {

        //// Oval Drawing
        var ovalPath = UIBezierPath(ovalInRect: CGRectMake(15.2, 25.05, 4, 1.6))
        AssetsKit.maleIconFill.setFill()
        ovalPath.fill()


        //// Group
        //// Bezier Drawing
        var bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(34.27, 20.55))
        bezierPath.addLineToPoint(CGPointMake(34.27, 13.32))
        bezierPath.addCurveToPoint(CGPointMake(34.17, 11.91), controlPoint1: CGPointMake(34.27, 12.82), controlPoint2: CGPointMake(34.23, 12.35))
        bezierPath.addCurveToPoint(CGPointMake(34.15, 11.72), controlPoint1: CGPointMake(34.16, 11.85), controlPoint2: CGPointMake(34.16, 11.79))
        bezierPath.addCurveToPoint(CGPointMake(34.1, 11.54), controlPoint1: CGPointMake(34.14, 11.66), controlPoint2: CGPointMake(34.12, 11.6))
        bezierPath.addCurveToPoint(CGPointMake(33.59, 9.84), controlPoint1: CGPointMake(33.99, 10.91), controlPoint2: CGPointMake(33.82, 10.35))
        bezierPath.addCurveToPoint(CGPointMake(20.72, 0.16), controlPoint1: CGPointMake(31.78, 5.47), controlPoint2: CGPointMake(26.64, 1.34))
        bezierPath.addCurveToPoint(CGPointMake(6.12, 6.41), controlPoint1: CGPointMake(14.42, -1.09), controlPoint2: CGPointMake(7.71, 2.26))
        bezierPath.addCurveToPoint(CGPointMake(1.13, 13.32), controlPoint1: CGPointMake(3.11, 7.32), controlPoint2: CGPointMake(1.13, 9.28))
        bezierPath.addLineToPoint(CGPointMake(1.13, 20.56))
        bezierPath.addCurveToPoint(CGPointMake(0, 24.02), controlPoint1: CGPointMake(0.43, 21.51), controlPoint2: CGPointMake(0, 22.71))
        bezierPath.addCurveToPoint(CGPointMake(3.67, 29.33), controlPoint1: CGPointMake(0, 26.52), controlPoint2: CGPointMake(1.55, 28.65))
        bezierPath.addCurveToPoint(CGPointMake(17.73, 38), controlPoint1: CGPointMake(6.36, 34.6), controlPoint2: CGPointMake(11.75, 38))
        bezierPath.addCurveToPoint(CGPointMake(31.79, 29.31), controlPoint1: CGPointMake(23.71, 38), controlPoint2: CGPointMake(29.1, 34.59))
        bezierPath.addCurveToPoint(CGPointMake(35.4, 24.01), controlPoint1: CGPointMake(33.88, 28.61), controlPoint2: CGPointMake(35.4, 26.5))
        bezierPath.addCurveToPoint(CGPointMake(34.27, 20.55), controlPoint1: CGPointMake(35.4, 22.71), controlPoint2: CGPointMake(34.97, 21.5))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(30.26, 26.18))
        bezierPath.addCurveToPoint(CGPointMake(29.59, 26.03), controlPoint1: CGPointMake(30.02, 26.18), controlPoint2: CGPointMake(29.8, 26.12))
        bezierPath.addCurveToPoint(CGPointMake(17.73, 34.62), controlPoint1: CGPointMake(27.91, 31.02), controlPoint2: CGPointMake(23.24, 34.62))
        bezierPath.addCurveToPoint(CGPointMake(5.86, 26.01), controlPoint1: CGPointMake(12.21, 34.62), controlPoint2: CGPointMake(7.53, 31.01))
        bezierPath.addCurveToPoint(CGPointMake(5.14, 26.18), controlPoint1: CGPointMake(5.64, 26.12), controlPoint2: CGPointMake(5.39, 26.18))
        bezierPath.addCurveToPoint(CGPointMake(3.3, 24.01), controlPoint1: CGPointMake(4.12, 26.18), controlPoint2: CGPointMake(3.3, 25.21))
        bezierPath.addCurveToPoint(CGPointMake(5.14, 21.85), controlPoint1: CGPointMake(3.3, 22.82), controlPoint2: CGPointMake(4.12, 21.85))
        bezierPath.addCurveToPoint(CGPointMake(5.2, 21.86), controlPoint1: CGPointMake(5.16, 21.85), controlPoint2: CGPointMake(5.18, 21.86))
        bezierPath.addCurveToPoint(CGPointMake(6.17, 15.89), controlPoint1: CGPointMake(5.21, 20.17), controlPoint2: CGPointMake(5.56, 17.5))
        bezierPath.addCurveToPoint(CGPointMake(9.99, 18.11), controlPoint1: CGPointMake(6.97, 17.04), controlPoint2: CGPointMake(8.19, 18.11))
        bezierPath.addLineToPoint(CGPointMake(9.99, 18.11))
        bezierPath.addCurveToPoint(CGPointMake(10.25, 18.1), controlPoint1: CGPointMake(10.08, 18.11), controlPoint2: CGPointMake(10.16, 18.11))
        bezierPath.addCurveToPoint(CGPointMake(10.61, 17.82), controlPoint1: CGPointMake(10.42, 18.09), controlPoint2: CGPointMake(10.56, 17.98))
        bezierPath.addCurveToPoint(CGPointMake(16.08, 13.06), controlPoint1: CGPointMake(10.63, 17.78), controlPoint2: CGPointMake(12.13, 13.48))
        bezierPath.addCurveToPoint(CGPointMake(14.71, 17.55), controlPoint1: CGPointMake(16.25, 13.9), controlPoint2: CGPointMake(16.5, 16.18))
        bezierPath.addCurveToPoint(CGPointMake(14.56, 17.99), controlPoint1: CGPointMake(14.58, 17.66), controlPoint2: CGPointMake(14.52, 17.83))
        bezierPath.addCurveToPoint(CGPointMake(14.9, 18.31), controlPoint1: CGPointMake(14.6, 18.16), controlPoint2: CGPointMake(14.73, 18.28))
        bezierPath.addCurveToPoint(CGPointMake(16.97, 18.44), controlPoint1: CGPointMake(14.93, 18.31), controlPoint2: CGPointMake(15.75, 18.44))
        bezierPath.addCurveToPoint(CGPointMake(25.28, 15.51), controlPoint1: CGPointMake(19.05, 18.44), controlPoint2: CGPointMake(22.82, 18.05))
        bezierPath.addCurveToPoint(CGPointMake(26.08, 18.87), controlPoint1: CGPointMake(25.69, 15.94), controlPoint2: CGPointMake(26.42, 16.99))
        bezierPath.addCurveToPoint(CGPointMake(26.28, 19.31), controlPoint1: CGPointMake(26.05, 19.05), controlPoint2: CGPointMake(26.13, 19.22))
        bezierPath.addCurveToPoint(CGPointMake(26.49, 19.37), controlPoint1: CGPointMake(26.34, 19.35), controlPoint2: CGPointMake(26.41, 19.37))
        bezierPath.addCurveToPoint(CGPointMake(26.75, 19.26), controlPoint1: CGPointMake(26.58, 19.37), controlPoint2: CGPointMake(26.68, 19.33))
        bezierPath.addCurveToPoint(CGPointMake(29.44, 16.33), controlPoint1: CGPointMake(26.84, 19.19), controlPoint2: CGPointMake(28.37, 17.83))
        bezierPath.addCurveToPoint(CGPointMake(30.26, 21.85), controlPoint1: CGPointMake(29.96, 17.96), controlPoint2: CGPointMake(30.25, 20.31))
        bezierPath.addLineToPoint(CGPointMake(30.26, 21.85))
        bezierPath.addCurveToPoint(CGPointMake(32.11, 24.01), controlPoint1: CGPointMake(31.29, 21.85), controlPoint2: CGPointMake(32.11, 22.81))
        bezierPath.addCurveToPoint(CGPointMake(30.26, 26.18), controlPoint1: CGPointMake(32.11, 25.21), controlPoint2: CGPointMake(31.29, 26.18))
        bezierPath.closePath()
        AssetsKit.maleIconFill.setFill()
        bezierPath.fill()
        AssetsKit.iconUntapped.setStroke()
        bezierPath.lineWidth = 0
        bezierPath.stroke()


        //// Oval 2 Drawing
        var oval2Path = UIBezierPath(ovalInRect: CGRectMake(9.95, 20.15, 3.6, 3.6))
        AssetsKit.maleIconFill.setFill()
        oval2Path.fill()


        //// Oval 3 Drawing
        var oval3Path = UIBezierPath(ovalInRect: CGRectMake(21.85, 20.15, 3.6, 3.6))
        AssetsKit.maleIconFill.setFill()
        oval3Path.fill()
    }

    public class func drawCakeIcon() {

        //// Group
        //// Bezier Drawing
        var bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(40, 33.29))
        bezierPath.addCurveToPoint(CGPointMake(40.09, 32.79), controlPoint1: CGPointMake(40.06, 33.13), controlPoint2: CGPointMake(40.09, 32.97))
        bezierPath.addLineToPoint(CGPointMake(40.09, 17.28))
        bezierPath.addCurveToPoint(CGPointMake(38.74, 15.93), controlPoint1: CGPointMake(40.09, 16.54), controlPoint2: CGPointMake(39.49, 15.93))
        bezierPath.addLineToPoint(CGPointMake(25.62, 15.93))
        bezierPath.addLineToPoint(CGPointMake(25.62, 8.27))
        bezierPath.addLineToPoint(CGPointMake(25.29, 8.2))
        bezierPath.addCurveToPoint(CGPointMake(23.36, 7.83), controlPoint1: CGPointMake(25.05, 8.15), controlPoint2: CGPointMake(24.24, 7.97))
        bezierPath.addCurveToPoint(CGPointMake(23.38, 7.49), controlPoint1: CGPointMake(23.36, 7.73), controlPoint2: CGPointMake(23.37, 7.61))
        bezierPath.addCurveToPoint(CGPointMake(23.58, 7.54), controlPoint1: CGPointMake(23.45, 7.51), controlPoint2: CGPointMake(23.51, 7.53))
        bezierPath.addCurveToPoint(CGPointMake(23.86, 7.57), controlPoint1: CGPointMake(23.67, 7.56), controlPoint2: CGPointMake(23.76, 7.57))
        bezierPath.addCurveToPoint(CGPointMake(25.31, 6.94), controlPoint1: CGPointMake(24.39, 7.57), controlPoint2: CGPointMake(24.98, 7.31))
        bezierPath.addCurveToPoint(CGPointMake(25.38, 4.68), controlPoint1: CGPointMake(25.88, 6.2), controlPoint2: CGPointMake(25.55, 5.21))
        bezierPath.addCurveToPoint(CGPointMake(22.91, 0.7), controlPoint1: CGPointMake(24.95, 3.4), controlPoint2: CGPointMake(23.97, 1.63))
        bezierPath.addCurveToPoint(CGPointMake(22.45, 0.63), controlPoint1: CGPointMake(22.79, 0.59), controlPoint2: CGPointMake(22.6, 0.57))
        bezierPath.addCurveToPoint(CGPointMake(22.2, 1.02), controlPoint1: CGPointMake(22.3, 0.7), controlPoint2: CGPointMake(22.2, 0.86))
        bezierPath.addCurveToPoint(CGPointMake(22.03, 2.61), controlPoint1: CGPointMake(22.2, 1.52), controlPoint2: CGPointMake(22.14, 2.03))
        bezierPath.addCurveToPoint(CGPointMake(21.52, 3.61), controlPoint1: CGPointMake(21.93, 3.03), controlPoint2: CGPointMake(21.75, 3.29))
        bezierPath.addCurveToPoint(CGPointMake(21.1, 4.26), controlPoint1: CGPointMake(21.39, 3.79), controlPoint2: CGPointMake(21.25, 3.99))
        bezierPath.addCurveToPoint(CGPointMake(21.86, 6.96), controlPoint1: CGPointMake(20.43, 5.6), controlPoint2: CGPointMake(21.26, 6.38))
        bezierPath.addCurveToPoint(CGPointMake(22.46, 7.59), controlPoint1: CGPointMake(22.07, 7.16), controlPoint2: CGPointMake(22.3, 7.37))
        bezierPath.addCurveToPoint(CGPointMake(22.51, 7.65), controlPoint1: CGPointMake(22.48, 7.61), controlPoint2: CGPointMake(22.5, 7.63))
        bezierPath.addCurveToPoint(CGPointMake(22.51, 7.71), controlPoint1: CGPointMake(22.51, 7.67), controlPoint2: CGPointMake(22.51, 7.69))
        bezierPath.addCurveToPoint(CGPointMake(21.54, 7.65), controlPoint1: CGPointMake(22.13, 7.67), controlPoint2: CGPointMake(21.8, 7.65))
        bezierPath.addCurveToPoint(CGPointMake(20.4, 8.1), controlPoint1: CGPointMake(21.1, 7.65), controlPoint2: CGPointMake(20.58, 7.7))
        bezierPath.addCurveToPoint(CGPointMake(20.58, 8.86), controlPoint1: CGPointMake(20.34, 8.24), controlPoint2: CGPointMake(20.28, 8.53))
        bezierPath.addCurveToPoint(CGPointMake(20.52, 15.16), controlPoint1: CGPointMake(20.68, 9.07), controlPoint2: CGPointMake(20.74, 10.35))
        bezierPath.addCurveToPoint(CGPointMake(20.48, 15.93), controlPoint1: CGPointMake(20.5, 15.5), controlPoint2: CGPointMake(20.49, 15.74))
        bezierPath.addLineToPoint(CGPointMake(6.86, 15.93))
        bezierPath.addCurveToPoint(CGPointMake(5.5, 17.28), controlPoint1: CGPointMake(6.11, 15.93), controlPoint2: CGPointMake(5.5, 16.54))
        bezierPath.addLineToPoint(CGPointMake(5.5, 32.79))
        bezierPath.addCurveToPoint(CGPointMake(5.6, 33.29), controlPoint1: CGPointMake(5.5, 32.97), controlPoint2: CGPointMake(5.54, 33.14))
        bezierPath.addLineToPoint(CGPointMake(0, 33.29))
        bezierPath.addLineToPoint(CGPointMake(1.63, 35.91))
        bezierPath.addLineToPoint(CGPointMake(1.69, 36))
        bezierPath.addLineToPoint(CGPointMake(42.9, 36))
        bezierPath.addLineToPoint(CGPointMake(44.92, 33.29))
        bezierPath.addLineToPoint(CGPointMake(40, 33.29))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(23.61, 6.4))
        bezierPath.addCurveToPoint(CGPointMake(23.62, 3.63), controlPoint1: CGPointMake(23.85, 5.37), controlPoint2: CGPointMake(24.1, 4.3))
        bezierPath.addLineToPoint(CGPointMake(23.51, 3.47))
        bezierPath.addLineToPoint(CGPointMake(22.82, 3.96))
        bezierPath.addLineToPoint(CGPointMake(22.93, 4.12))
        bezierPath.addCurveToPoint(CGPointMake(22.77, 6.2), controlPoint1: CGPointMake(23.18, 4.48), controlPoint2: CGPointMake(22.95, 5.47))
        bezierPath.addLineToPoint(CGPointMake(22.76, 6.26))
        bezierPath.addCurveToPoint(CGPointMake(22.69, 6.57), controlPoint1: CGPointMake(22.73, 6.37), controlPoint2: CGPointMake(22.71, 6.47))
        bezierPath.addCurveToPoint(CGPointMake(22.44, 6.33), controlPoint1: CGPointMake(22.61, 6.49), controlPoint2: CGPointMake(22.53, 6.41))
        bezierPath.addCurveToPoint(CGPointMake(21.86, 4.65), controlPoint1: CGPointMake(21.84, 5.76), controlPoint2: CGPointMake(21.48, 5.41))
        bezierPath.addCurveToPoint(CGPointMake(22.22, 4.09), controlPoint1: CGPointMake(21.96, 4.45), controlPoint2: CGPointMake(22.08, 4.29))
        bezierPath.addCurveToPoint(CGPointMake(22.86, 2.79), controlPoint1: CGPointMake(22.48, 3.73), controlPoint2: CGPointMake(22.72, 3.39))
        bezierPath.addCurveToPoint(CGPointMake(22.99, 2.03), controlPoint1: CGPointMake(22.91, 2.52), controlPoint2: CGPointMake(22.96, 2.28))
        bezierPath.addCurveToPoint(CGPointMake(24.57, 4.95), controlPoint1: CGPointMake(23.71, 2.95), controlPoint2: CGPointMake(24.3, 4.13))
        bezierPath.addCurveToPoint(CGPointMake(24.65, 6.4), controlPoint1: CGPointMake(24.74, 5.47), controlPoint2: CGPointMake(24.91, 6.06))
        bezierPath.addCurveToPoint(CGPointMake(23.74, 6.7), controlPoint1: CGPointMake(24.47, 6.6), controlPoint2: CGPointMake(24.04, 6.76))
        bezierPath.addCurveToPoint(CGPointMake(23.57, 6.59), controlPoint1: CGPointMake(23.6, 6.68), controlPoint2: CGPointMake(23.57, 6.62))
        bezierPath.addCurveToPoint(CGPointMake(23.56, 6.57), controlPoint1: CGPointMake(23.56, 6.58), controlPoint2: CGPointMake(23.56, 6.58))
        bezierPath.addLineToPoint(CGPointMake(23.61, 6.4))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(23.15, 9.02))
        bezierPath.addLineToPoint(CGPointMake(23.37, 8.69))
        bezierPath.addCurveToPoint(CGPointMake(24.77, 8.96), controlPoint1: CGPointMake(23.94, 8.79), controlPoint2: CGPointMake(24.46, 8.9))
        bezierPath.addLineToPoint(CGPointMake(24.77, 15.78))
        bezierPath.addLineToPoint(CGPointMake(21.34, 15.78))
        bezierPath.addLineToPoint(CGPointMake(21.37, 15.2))
        bezierPath.addCurveToPoint(CGPointMake(21.35, 8.5), controlPoint1: CGPointMake(21.57, 10.75), controlPoint2: CGPointMake(21.57, 9.07))
        bezierPath.addCurveToPoint(CGPointMake(22.69, 8.59), controlPoint1: CGPointMake(21.65, 8.48), controlPoint2: CGPointMake(22.1, 8.51))
        bezierPath.addCurveToPoint(CGPointMake(22.99, 8.91), controlPoint1: CGPointMake(22.77, 8.73), controlPoint2: CGPointMake(22.86, 8.84))
        bezierPath.addLineToPoint(CGPointMake(23.15, 9.02))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(12.5, 24.52))
        bezierPath.addCurveToPoint(CGPointMake(13.31, 24.57), controlPoint1: CGPointMake(12.77, 24.55), controlPoint2: CGPointMake(13.05, 24.57))
        bezierPath.addCurveToPoint(CGPointMake(19.15, 19.31), controlPoint1: CGPointMake(16.6, 24.57), controlPoint2: CGPointMake(18.11, 21.92))
        bezierPath.addCurveToPoint(CGPointMake(21.3, 21.02), controlPoint1: CGPointMake(19.93, 19.59), controlPoint2: CGPointMake(20.59, 20.29))
        bezierPath.addCurveToPoint(CGPointMake(24.7, 23.4), controlPoint1: CGPointMake(22.24, 22.01), controlPoint2: CGPointMake(23.22, 23.03))
        bezierPath.addCurveToPoint(CGPointMake(25.67, 23.53), controlPoint1: CGPointMake(25.05, 23.49), controlPoint2: CGPointMake(25.37, 23.53))
        bezierPath.addCurveToPoint(CGPointMake(28.74, 20.3), controlPoint1: CGPointMake(27.73, 23.53), controlPoint2: CGPointMake(28.31, 21.66))
        bezierPath.addCurveToPoint(CGPointMake(29.35, 18.96), controlPoint1: CGPointMake(28.92, 19.72), controlPoint2: CGPointMake(29.12, 19.07))
        bezierPath.addCurveToPoint(CGPointMake(30.87, 20.72), controlPoint1: CGPointMake(29.64, 18.96), controlPoint2: CGPointMake(30.46, 20.14))
        bezierPath.addCurveToPoint(CGPointMake(34.76, 24.29), controlPoint1: CGPointMake(31.89, 22.19), controlPoint2: CGPointMake(33.18, 24.02))
        bezierPath.addCurveToPoint(CGPointMake(37.47, 23.83), controlPoint1: CGPointMake(35.73, 24.52), controlPoint2: CGPointMake(36.66, 24.36))
        bezierPath.addCurveToPoint(CGPointMake(39.24, 21.69), controlPoint1: CGPointMake(38.18, 23.36), controlPoint2: CGPointMake(38.77, 22.65))
        bezierPath.addLineToPoint(CGPointMake(39.24, 32.79))
        bezierPath.addCurveToPoint(CGPointMake(38.74, 33.29), controlPoint1: CGPointMake(39.24, 33.07), controlPoint2: CGPointMake(39.02, 33.29))
        bezierPath.addLineToPoint(CGPointMake(6.86, 33.29))
        bezierPath.addCurveToPoint(CGPointMake(6.36, 32.79), controlPoint1: CGPointMake(6.58, 33.29), controlPoint2: CGPointMake(6.36, 33.07))
        bezierPath.addLineToPoint(CGPointMake(6.36, 19.58))
        bezierPath.addCurveToPoint(CGPointMake(8.07, 21.37), controlPoint1: CGPointMake(6.98, 20.07), controlPoint2: CGPointMake(7.51, 20.7))
        bezierPath.addCurveToPoint(CGPointMake(12.5, 24.52), controlPoint1: CGPointMake(9.21, 22.71), controlPoint2: CGPointMake(10.38, 24.09))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(37, 23.12))
        bezierPath.addCurveToPoint(CGPointMake(34.93, 23.45), controlPoint1: CGPointMake(36.38, 23.53), controlPoint2: CGPointMake(35.72, 23.64))
        bezierPath.addCurveToPoint(CGPointMake(31.56, 20.22), controlPoint1: CGPointMake(33.66, 23.24), controlPoint2: CGPointMake(32.5, 21.57))
        bezierPath.addCurveToPoint(CGPointMake(29.35, 18.1), controlPoint1: CGPointMake(30.73, 19.04), controlPoint2: CGPointMake(30.08, 18.1))
        bezierPath.addCurveToPoint(CGPointMake(28.99, 18.18), controlPoint1: CGPointMake(29.23, 18.1), controlPoint2: CGPointMake(29.11, 18.13))
        bezierPath.addCurveToPoint(CGPointMake(27.92, 20.06), controlPoint1: CGPointMake(28.42, 18.45), controlPoint2: CGPointMake(28.19, 19.2))
        bezierPath.addCurveToPoint(CGPointMake(25.65, 22.67), controlPoint1: CGPointMake(27.52, 21.35), controlPoint2: CGPointMake(27.11, 22.67))
        bezierPath.addCurveToPoint(CGPointMake(24.9, 22.58), controlPoint1: CGPointMake(25.42, 22.67), controlPoint2: CGPointMake(25.17, 22.64))
        bezierPath.addCurveToPoint(CGPointMake(21.91, 20.43), controlPoint1: CGPointMake(23.67, 22.27), controlPoint2: CGPointMake(22.78, 21.34))
        bezierPath.addCurveToPoint(CGPointMake(18.98, 18.38), controlPoint1: CGPointMake(21.02, 19.5), controlPoint2: CGPointMake(20.17, 18.61))
        bezierPath.addLineToPoint(CGPointMake(18.62, 18.31))
        bezierPath.addLineToPoint(CGPointMake(18.49, 18.64))
        bezierPath.addCurveToPoint(CGPointMake(13.29, 23.72), controlPoint1: CGPointMake(17.49, 21.28), controlPoint2: CGPointMake(16.16, 23.72))
        bezierPath.addCurveToPoint(CGPointMake(12.64, 23.68), controlPoint1: CGPointMake(13.07, 23.72), controlPoint2: CGPointMake(12.85, 23.7))
        bezierPath.addCurveToPoint(CGPointMake(8.72, 20.81), controlPoint1: CGPointMake(10.84, 23.32), controlPoint2: CGPointMake(9.76, 22.04))
        bezierPath.addCurveToPoint(CGPointMake(6.36, 18.55), controlPoint1: CGPointMake(8.06, 20.03), controlPoint2: CGPointMake(7.3, 19.14))
        bezierPath.addLineToPoint(CGPointMake(6.36, 17.28))
        bezierPath.addCurveToPoint(CGPointMake(6.86, 16.78), controlPoint1: CGPointMake(6.36, 17.01), controlPoint2: CGPointMake(6.58, 16.78))
        bezierPath.addLineToPoint(CGPointMake(20.67, 16.78))
        bezierPath.addLineToPoint(CGPointMake(20.72, 16.83))
        bezierPath.addLineToPoint(CGPointMake(20.91, 16.83))
        bezierPath.addCurveToPoint(CGPointMake(21.11, 16.78), controlPoint1: CGPointMake(20.98, 16.83), controlPoint2: CGPointMake(21.05, 16.81))
        bezierPath.addLineToPoint(CGPointMake(38.74, 16.78))
        bezierPath.addCurveToPoint(CGPointMake(39.24, 17.28), controlPoint1: CGPointMake(39.02, 16.78), controlPoint2: CGPointMake(39.24, 17))
        bezierPath.addLineToPoint(CGPointMake(39.25, 18.95))
        bezierPath.addCurveToPoint(CGPointMake(37, 23.12), controlPoint1: CGPointMake(38.98, 20.43), controlPoint2: CGPointMake(38.25, 22.3))
        bezierPath.closePath()
        bezierPath.moveToPoint(CGPointMake(2.16, 35.15))
        bezierPath.addLineToPoint(CGPointMake(1.54, 34.15))
        bezierPath.addLineToPoint(CGPointMake(43.22, 34.15))
        bezierPath.addLineToPoint(CGPointMake(42.47, 35.15))
        bezierPath.addLineToPoint(CGPointMake(2.16, 35.15))
        bezierPath.closePath()
        AssetsKit.femaleIconFill.setFill()
        bezierPath.fill()
    }

    //// Generated Images

    public class func imageOfLandingIcon(#scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(160, 160), false, 0)
            AssetsKit.drawLandingIcon(scale: scale)

        let imageOfLandingIcon = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfLandingIcon
    }

    public class var imageOfFemaleIcon: UIImage {
        if Cache.imageOfFemaleIcon != nil {
            return Cache.imageOfFemaleIcon!
        }

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(35, 38), false, 0)
            AssetsKit.drawFemaleIcon()

        Cache.imageOfFemaleIcon = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfFemaleIcon!
    }

    public class var imageOfMaleIcon: UIImage {
        if Cache.imageOfMaleIcon != nil {
            return Cache.imageOfMaleIcon!
        }

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(35, 38), false, 0)
            AssetsKit.drawMaleIcon()

        Cache.imageOfMaleIcon = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfMaleIcon!
    }

    public class var imageOfCakeIcon: UIImage {
        if Cache.imageOfCakeIcon != nil {
            return Cache.imageOfCakeIcon!
        }

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(45, 36), false, 0)
            AssetsKit.drawCakeIcon()

        Cache.imageOfCakeIcon = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfCakeIcon!
    }

    //// Customization Infrastructure

    @IBOutlet var femaleIconTargets: [AnyObject]! {
        get { return Cache.femaleIconTargets }
        set {
            Cache.femaleIconTargets = newValue
            for target: AnyObject in newValue {
                target.setImage(AssetsKit.imageOfFemaleIcon)
            }
        }
    }

    @IBOutlet var maleIconTargets: [AnyObject]! {
        get { return Cache.maleIconTargets }
        set {
            Cache.maleIconTargets = newValue
            for target: AnyObject in newValue {
                target.setImage(AssetsKit.imageOfMaleIcon)
            }
        }
    }

    @IBOutlet var cakeIconTargets: [AnyObject]! {
        get { return Cache.cakeIconTargets }
        set {
            Cache.cakeIconTargets = newValue
            for target: AnyObject in newValue {
                target.setImage(AssetsKit.imageOfCakeIcon)
            }
        }
    }

}



extension UIColor {
    func colorWithHue(newHue: CGFloat) -> UIColor {
        var saturation: CGFloat = 1.0, brightness: CGFloat = 1.0, alpha: CGFloat = 1.0
        self.getHue(nil, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: newHue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    func colorWithSaturation(newSaturation: CGFloat) -> UIColor {
        var hue: CGFloat = 1.0, brightness: CGFloat = 1.0, alpha: CGFloat = 1.0
        self.getHue(&hue, saturation: nil, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
    }
    func colorWithBrightness(newBrightness: CGFloat) -> UIColor {
        var hue: CGFloat = 1.0, saturation: CGFloat = 1.0, alpha: CGFloat = 1.0
        self.getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }
    func colorWithAlpha(newAlpha: CGFloat) -> UIColor {
        var hue: CGFloat = 1.0, saturation: CGFloat = 1.0, brightness: CGFloat = 1.0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: newAlpha)
    }
    func colorWithHighlight(highlight: CGFloat) -> UIColor {
        var red: CGFloat = 1.0, green: CGFloat = 1.0, blue: CGFloat = 1.0, alpha: CGFloat = 1.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: red * (1-highlight) + highlight, green: green * (1-highlight) + highlight, blue: blue * (1-highlight) + highlight, alpha: alpha * (1-highlight) + highlight)
    }
    func colorWithShadow(shadow: CGFloat) -> UIColor {
        var red: CGFloat = 1.0, green: CGFloat = 1.0, blue: CGFloat = 1.0, alpha: CGFloat = 1.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: red * (1-shadow), green: green * (1-shadow), blue: blue * (1-shadow), alpha: alpha * (1-shadow) + shadow)
    }
}

@objc protocol StyleKitSettableImage {
    func setImage(image: UIImage!)
}

@objc protocol StyleKitSettableSelectedImage {
    func setSelectedImage(image: UIImage!)
}