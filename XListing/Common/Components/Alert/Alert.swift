//
//  Alert.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-30.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import Whisper

protocol IAlert {
    func presentError(message: String, navigationController: UINavigationController)
}

final class Alert : IAlert {
    
    func presentError(message: String, navigationController: UINavigationController) {
        let message = Message(title: message, backgroundColor: UIColor.redColor())
        Whisper(message, to: navigationController, action: .Present)
    }
}
