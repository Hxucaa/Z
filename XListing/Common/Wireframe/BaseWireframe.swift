//
//  BaseWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

private let MainStoryboardName = "Main"

public class BaseWireframe {
    
    public let rootWireframe: IRootWireframe
    
    public init(rootWireframe: IRootWireframe) {
        self.rootWireframe = rootWireframe
    }

}

/**
    Below should be protected methods.
*/
extension BaseWireframe {
    /**
        Get view controller from the storyboard based on its identifier.
        
        :param: identifier A String of the identifier associated with the view controller
        :returns: An instance of the view controller.
    */
    public func getViewControllerFromStoryboard(identifier: String, storyboardName: String = MainStoryboardName) -> AnyObject {
        let storyboard = mainStoryboard(storyboardName)
        let viewController: AnyObject! = storyboard.instantiateViewControllerWithIdentifier(identifier)
        return viewController
        
    }
    
    /**
        Get storyboard.
        
        :returns: The UIStoryboard
    */
    public func mainStoryboard(name: String) -> UIStoryboard {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard
    }
}