//
//  BaseWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

let storyboardName = "Main"

class BaseWireframe {
    

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
    final func getViewControllerFromStoryboard(identifier: String) -> AnyObject {
        let storyboard = mainStoryboard()
        let viewController: AnyObject! = storyboard.instantiateViewControllerWithIdentifier(identifier)
        return viewController
        
    }
    
    /**
        Get storyboard.
        
        :returns: The UIStoryboard
    */
    final func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle())
        return storyboard
    }
}