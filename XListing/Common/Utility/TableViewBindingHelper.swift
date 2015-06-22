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

protocol ReactiveView {
    func bindViewModel(viewmodel: ReactiveTableCellViewModel)
}

// a helper that makes it easier to bind to UITableView instances
// see: http://www.scottlogic.com/blog/2014/05/11/reactivecocoa-tableview-binding.html
class TableViewBindingHelper<T: ReactiveTableCellViewModel> {
    
    //MARK: Properties
    
    var delegate: UITableViewDelegate?
    
    private let tableView: UITableView
//    private let templateCell: UITableViewCell
    private let selectionCommand: RACCommand?
    private let dataSource: GenericDataSource<T>
    
    //MARK: Public API
    
    init(tableView: UITableView, sourceSignal: SignalProducer<[T], NoError>, identifier: String, selectionCommand: RACCommand? = nil) {
        self.tableView = tableView
        self.selectionCommand = selectionCommand
        
//        if let nibName = nibName {
//            let nib = UINib(nibName: nibName, bundle: nil)
//            
//            // create an instance of the template cell and register with the table view
//            templateCell = nib.instantiateWithOwner(nil, options: nil)[0] as! UITableViewCell
//            tableView.registerNib(nib, forCellReuseIdentifier: templateCell.reuseIdentifier!)
//        }
//        templateCell
//        dataSource = DataSource(data: [AnyObject](), templateCell: templateCell)
        dataSource = GenericDataSource<T>(identifier: identifier)
        
        sourceSignal.start(next: { data in
            self.dataSource.data = data as [AnyObject]
            self.tableView.reloadData()
        })
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }
    
//    convenience init(tableView: UITableView, sourceSignal: SignalProducer<[T], NoError>, identifier: String, selectionCommand: RACCommand? = nil) {
//        self.init(tableView: tableView, )
//    }
}

class GenericDataSource<T: ReactiveTableCellViewModel> : DataSource {
    
    override init(identifier: String) {
        super.init(identifier: identifier)
    }
}

class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
//    private let templateCell: UITableViewCell
    private let identifier: String
    var data: [AnyObject] = [AnyObject]()
    
    
//    init(data: [AnyObject], templateCell: UITableViewCell) {
//        self.data = data
//        self.templateCell = templateCell
//    }
    
    init(identifier: String) {
        self.identifier = identifier
    }
    
    /**
    If you are using storyboard for TableViewCell, use this version and provide cell identifier.
    
    :param: data       Data view model array.
    :param: identifier Cell identifier.
    */
//    convenience init(data: [AnyObject], identifier: String) {
//        
//    }
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
//        let cell = tableView.dequeueReusableCellWithIdentifier(templateCell.reuseIdentifier!) as! UITableViewCell
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! UITableViewCell
        if let reactiveView = cell as? ReactiveView {
            reactiveView.bindViewModel(item as! ReactiveTableCellViewModel)
        }
        else {
            fatalError("UITableViewCell must implement ReactiveView protocol")
        }
        return cell
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return templateCell.frame.size.height
//    }
    
    /**
    Tells the delegate that the specified row is now selected.
    
    :param: tableView A table-view object informing the delegate about the new row selection.
    :param: indexPath An index path locating the new selected row in tableView.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /* if selectionCommand != nil {
        selectionCommand?.execute(data[indexPath.row])
        }*/
    }
    
}