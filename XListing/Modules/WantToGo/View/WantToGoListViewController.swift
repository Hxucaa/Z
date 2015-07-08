//
//  WantToGoListViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-29.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import SDWebImage
import ReactiveCocoa

private let CellIdentifier = "Cell"

public final class WantToGoListViewController: XUIViewController {
    
    // MARK: - UI
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Controls
    
    // MARK: Actions
    
    // MARK: - Private Variables
    var selectedPplArrayM : NSMutableArray = []
    var selectedPplArrayW : NSMutableArray = []
    
    private var viewmodel: IWantToGoListViewModel!
    private var bindingHelper: ReactiveTableBindingHelper<WantToGoViewModel>!
    
    // MARK: - Setup Code
    public override func viewDidLoad() {
        super.viewDidLoad()
        genderSegmentedControl?.addTarget(self, action: "switchSegment", forControlEvents: UIControlEvents.ValueChanged)
        setupTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func bindToViewModel(viewmodel: IWantToGoListViewModel) {
        self.viewmodel = viewmodel
    }
    
    private func setupTableView() {
        bindingHelper = ReactiveTableBindingHelper(
            tableView: tableView,
            sourceSignal: viewmodel.wantToGoViewModelArr.producer,
            storyboardIdentifier: CellIdentifier
            )
            { [unowned self] pos in
                println("log something")
        }
    }
    
    func switchSegment(){
        if (genderSegmentedControl.selectedSegmentIndex == 0) {
            // Male Segment
            viewmodel.showUsers("male")
        } else if (genderSegmentedControl.selectedSegmentIndex == 1) {
            // Female Segment
            viewmodel.showUsers("female")
        }
        
        self.tableView.reloadData()
    }
    
}
