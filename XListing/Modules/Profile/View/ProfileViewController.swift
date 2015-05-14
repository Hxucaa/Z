//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public class ProfileViewController : UIViewController {

    public var profileVM: IProfileViewModel?

    public override func viewDidLoad() {
        super.viewDidLoad()
        println("I'm in ProfileViewController")
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
