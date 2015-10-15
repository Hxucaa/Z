//
//  FullScreenImageViewController.swift
//  
//
//  Created by Bruce Li on 2015-10-14.
//
//

import UIKit

public final class FullScreenImageViewController: UIViewController {

    
    private var viewmodel : IFullScreenImageViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    public func bindToViewModel(viewmodel: IFullScreenImageViewModel) {
        self.viewmodel = viewmodel
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
