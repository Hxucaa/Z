//
//  ViewController.swift
//  XListing
//
//  Created by Lance on 2015-03-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit

public class FeaturedListViewController: UIViewController {

    @IBOutlet weak var featuredButton: UIButton!
    private var featuredButtonSignal: Signal<NSString?>?
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var nameSChineseLabel: UILabel!
    @IBOutlet weak var nameEnglishLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    /// ViewModel
    public var featuredListVM: IFeaturedListViewModel?
    private var dynamicArraySignal: Signal<([AnyObject]?, NSKeyValueChange, NSIndexSet)>?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupFeaturedButton()
        setupOther()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    Setup signals for FeaturedButton
    */
    private func setupFeaturedButton() {
        featuredButtonSignal = featuredButton?.signal(controlEvents: UIControlEvents.TouchUpInside, map: { (button: UIControl?) -> NSString in
            return "Query Featured List"
        })
        
        let featuredListRetrievalSignal = featuredButtonSignal?
            .startWith("Querying on start")  // startWith will send the signal right way. Perfect for initiating data retrieval on view loading.
            .flatMap { _ in
                Signal<Void>.fromTask(self.featuredListVM!.requestAllBusinesses())
        }
        
        // no need to assign a private variable of the signal if specify the owner
        featuredListRetrievalSignal?.ownedBy(self)
        
        // Even though the signal does not display anything, it has to have an output to complete the life cycle. Otherwise the signal will not work at all.
        featuredListRetrievalSignal! ~> {}
        // set up println to react to signal
        // NOTE: ^{ ... } = closure-first operator, same as `signal ~> { ... }`
        //^{ println($0!) } <~ featuredButtonSignal!
        
        // remove signal-binding
        //featuredButtonSignal = nil
    }
    
    private func setupOther() {
        dynamicArraySignal = featuredListVM?.dynamicArray.signal()
        let businessVMSignal = dynamicArraySignal?.map { (changedValues, change, indexSet) -> BusinessViewModel in
            if changedValues?.count > 1 {
                //MARK: can't possibly be more than one item in the array???
                println("Warning: more than one value in the array.")
            }
            return (changedValues as! [BusinessViewModel])[0]
        }
        businessVMSignal?.ownedBy(self)
        
        let nameSChineseLabelSignal = businessVMSignal?.map { businessVM -> NSString? in
            return businessVM.nameSChinese
        }
        nameSChineseLabelSignal?.ownedBy(self)
        
        let nameEnglishLabelSignal = businessVMSignal?.map { businessVM -> NSString? in
            return businessVM.nameEnglish
        }
        nameEnglishLabelSignal?.ownedBy(self)
        
        let addressLabelSignal = businessVMSignal?.map { businessVM -> NSString? in
            return businessVM.address
        }
        addressLabelSignal?.ownedBy(self)
        
        let resultSignal = businessVMSignal?.map { businessVM -> NSString? in
            return businessVM.description
        }
        resultSignal?.ownedBy(self)
        
        (resultTextView, "text") <~ resultSignal!
        (nameSChineseLabel, "text") <~ nameSChineseLabelSignal!
        (nameEnglishLabel, "text") <~ nameEnglishLabelSignal!
        (addressLabel, "text") <~ addressLabelSignal!
    }
}

