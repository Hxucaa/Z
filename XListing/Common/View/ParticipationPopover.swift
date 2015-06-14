//
//  ParticipationPopover.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public struct ParticipationPopover {
    
    public weak var delegate: ParticipationPopoverDelegate!
   
    public func createPopover () -> UIAlertController{
        
        var alert = UIAlertController(title: "请选一种", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "我想去", style: UIAlertActionStyle.Default) { alert in
            self.delegate.alertAction(1)
            })
        alert.addAction(UIAlertAction(title: "我想请客", style: UIAlertActionStyle.Default) { alert in
            self.delegate.alertAction(2)
            })
        alert.addAction(UIAlertAction(title: "我想 AA", style: UIAlertActionStyle.Default) { alert in
            self.delegate.alertAction(3)
            })
        
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        return alert

    }
}

