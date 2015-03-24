//
//  ViewController.swift
//  XListing
//
//  Created by Lance on 2015-03-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit

class FeaturedListViewController: UIViewController {

    @IBOutlet weak var featuredButton: UIButton!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var nameSChineseLabel: UILabel!
    @IBOutlet weak var nameEnglishLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    private var featuredButtonSignal: Signal<NSString?>?
//    private var featuredListRetrievalSignal: Signal<[FeaturedListDisplayData]>?
    private var nameSChineseLabelSignal: Signal<NSString?>?
    private var nameEnglishLabelSignal: Signal<NSString?>?
    private var addressLabelSignal: Signal<NSString?>?
    
    private var resultSignal: Signal<NSString?>?
    
    
    var featuredListPresenter: FeaturedListPresenter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        PopulateParse.Populate()
        
//        var f = FeaturedListPresenter()
//        f.getList()
        setupDisplayingFeaturedList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupDisplayingFeaturedList() {
        /// The next three lines of code achieve the same thing: send a signal with NSSrting on touch up inside event
        ///
        ///
        //        featuredButtonSignal = featuredButton?.buttonSignal("Query Featured List")
        
        //        featuredButtonSignal = featuredButton?.buttonSignal { (button: UIButton?) -> NSString in
        //            return "Query Featured List"
        //        }
        
        featuredButtonSignal = featuredButton?.signal(controlEvents: UIControlEvents.TouchUpInside, map: { (button: UIControl?) -> NSString in
            return "Query Featured List"
        })
        ///
        ///
        /// Code block ends
        
        
        
        let featuredListRetrievalSignal = featuredButtonSignal?
            //            .startWith("Querying on start")  // startWith will send the signal right way. Perfect for initiating data retrieval on view loading.
            .flatMap { _ in
                Signal<[FeaturedListDisplayData]>.fromTask(self.featuredListPresenter!.getList())
        }
        
        // no need to assign a private variable of the signal if specify the owner
        featuredListRetrievalSignal?.ownedBy(self)
        
        nameSChineseLabelSignal = featuredListRetrievalSignal?.map { displayDataArr -> NSString? in
            if displayDataArr.count > 0 {
                return displayDataArr[0].nameSChinese
            }
            else {
                return nil
            }
        }
        
        nameEnglishLabelSignal = featuredListRetrievalSignal?.map {
            displayDataArr -> NSString? in
            if displayDataArr.count > 0 {
                return displayDataArr[0].nameEnglish
            }
            else {
                return nil
            }
        }
        
        
        addressLabelSignal = featuredListRetrievalSignal?.map {
            displayDataArr -> NSString? in
            if displayDataArr.count > 0 {
                return displayDataArr[0].address
            }
            else {
                return nil
            }
        }
        
        resultSignal = featuredListRetrievalSignal?.map { displayDataArr -> NSString? in
            var result = ""
            for item in displayDataArr {
                result += displayDataArr.description
            }
            return result
        }
        
        // set up ui controls to react to signal
        (resultTextView, "text") <~ resultSignal!
        (nameSChineseLabel, "text") <~ nameSChineseLabelSignal!
        (nameEnglishLabel, "text") <~ nameEnglishLabelSignal!
        (addressLabel, "text") <~ addressLabelSignal!
        
        // set up println to react to signal
        // NOTE: ^{ ... } = closure-first operator, same as `signal ~> { ... }`
        //^{ println($0!) } <~ featuredButtonSignal!
        
        // remove signal-binding
        //featuredButtonSignal = nil
    }
}

