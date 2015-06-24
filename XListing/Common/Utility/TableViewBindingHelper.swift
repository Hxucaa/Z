//
//  TableViewBindingHelper.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import ReactiveCocoa
import UIKit

public protocol ReactiveTableCellViewModel : class {
    
}

public protocol ReactiveTableCellView : class {
    func bindViewModel(viewmodel: ReactiveTableCellViewModel)
}

// a helper that makes it easier to bind to UITableView instances
// see: http://www.scottlogic.com/blog/2014/05/11/reactivecocoa-tableview-binding.html
class ReactiveTableBindingHelper<T: ReactiveTableCellViewModel> {
    
    //MARK: Properties
    private let tableView: UITableView
    private let dataSource: DataSource
    
    //MARK: Public API
    
    /**
    Bind to a storyboard based interface.
    
    :param: tableView            The UITableView.
    :param: sourceSignal         Data source.
    :param: storyboardIdentifier Storyboard identifier for the cell.
    :param: selectionCommand     What to do when a cell is selected.
    */
    init(tableView: UITableView, sourceSignal: SignalProducer<[T], NoError>, storyboardIdentifier: String, selectionCommand: (Int -> ())? = nil) {
        self.tableView = tableView
        
        dataSource = DataSource(storyboardIdentifier: storyboardIdentifier, selectionCommand: selectionCommand)
        
        sourceSignal.start(next: { data in
            self.dataSource.data = data as [AnyObject]
            self.tableView.reloadData()
        })
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
    /**
    Bind to a XIB based interface.
    
    :param: tableView            The UITableView.
    :param: sourceSignal         Data source.
    :param: storyboardIdentifier Storyboard identifier for the cell.
    :param: selectionCommand     What to do when a cell is selected.
    */
    init(tableView: UITableView, sourceSignal: SignalProducer<[T], NoError>, nibName: String, selectionCommand: (Int -> ())? = nil) {
        self.tableView = tableView
        
        let nib = UINib(nibName: nibName, bundle: nil)
        // create an instance of the template cell and register with the table view
        let templateCell = nib.instantiateWithOwner(nil, options: nil)[0] as! UITableViewCell
        tableView.registerNib(nib, forCellReuseIdentifier: templateCell.reuseIdentifier!)
        
        dataSource = DataSource(templateCell: templateCell, selectionCommand: selectionCommand)
        
        sourceSignal.start(next: { data in
            self.dataSource.data = data as [AnyObject]
            self.tableView.reloadData()
        })
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
}

class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var templateCell: UITableViewCell?
    private var storyboardIdentifier: String?
    private let selectionCommand: (Int -> ())?
    var data: [AnyObject] = [AnyObject]()
    
    convenience init(storyboardIdentifier: String, selectionCommand: (Int -> ())? = nil) {
        self.init(selectionCommand: selectionCommand)
        self.storyboardIdentifier = storyboardIdentifier
    }
    
    private init(selectionCommand: (Int -> ())? = nil) {
        self.selectionCommand = selectionCommand
    }
    
    convenience init(templateCell: UITableViewCell, selectionCommand: (Int -> ())? = nil) {
        self.init(selectionCommand: selectionCommand)
        self.templateCell = templateCell
    }
    
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    /**
    Asks the data source for a cell to insert in a particular location of the table view. (required)
    
    :param: tableView A table-view object requesting the cell.
    :param: indexPath An index path locating a row in tableView.
    
    :returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item: AnyObject = data[indexPath.row]
        
        var cell: UITableViewCell
        if let identifier = storyboardIdentifier {
            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(templateCell!.reuseIdentifier!) as! UITableViewCell
        }
        
        if let reactiveView = cell as? ReactiveTabelCellView {
            reactiveView.bindViewModel(item as! ReactiveTableCellViewModel)
        }
        else {
            fatalError("UITableViewCell must implement ReactiveView protocol")
        }
        return cell
    }
    
    /**
    Tells the delegate that the specified row is now selected.
    
    :param: tableView A table-view object informing the delegate about the new row selection.
    :param: indexPath An index path locating the new selected row in tableView.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectionCommand != nil {
            selectionCommand!(indexPath.row)
        }
    }
    
}