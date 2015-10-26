//
//  SocialBusinessViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveArray
import Dollar
import Cartography

private let UserCellIdentifier = "SocialBusiness_UserCell"
private let userControllerIdentifier = "UserProfileViewController"
private let BusinessHeightRatio = 0.61
private let UserHeightRatio = 0.224
private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
private let WTGBarHeight = CGFloat(70)

public final class SocialBusinessViewController : XUIViewController {
    
    // MARK: - UI Controls
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, ScreenWidth, 600), style: UITableViewStyle.Plain)
        
        tableView.registerClass(SocialBusiness_UserCell.self, forCellReuseIdentifier: UserCellIdentifier)
        
        tableView.showsHorizontalScrollIndicator = false
        tableView.opaque = true
        tableView.tableHeaderView = self.headerView
        tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 8)
        tableView.backgroundColor = .whiteColor()
        tableView.rowHeight = CGFloat(ScreenWidth) * CGFloat(UserHeightRatio)
        tableView.dataSource = self
        
        return tableView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: Fonts.FontAwesome, size: 17)!]
        var attributedString = NSAttributedString(string: Icons.Chevron, attributes: attributes)
        button.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        
        let goBack = Action<UIButton, Void, NoError> { button in
            return SignalProducer { sink ,disposable in
                self.navigationController!.popViewControllerAnimated(true)
                sendCompleted(sink)
            }
        }
        
        button.addTarget(goBack.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        
        return button
    }()
    
    private lazy var headerView: SocialBusinessHeaderView =  {
        let view = SocialBusinessHeaderView(frame: CGRectMake(0, 0, ScreenWidth, CGFloat(ScreenWidth) * CGFloat(BusinessHeightRatio)))
        
        return view
    }()
    
    private lazy var utilityHeaderView: SocialBusiness_UtilityHeaderView = {
        let view = SocialBusiness_UtilityHeaderView()
        view.setDetailInfoButtonStyleRegular()
        return view
    }()
    
    // MARK: - Properties
    private var viewmodel: ISocialBusinessViewModel! {
        didSet {
            viewmodel.businessName.producer
                |> start(next: { [weak self] name in
                    self?.title = name
                })
            headerView.bindToViewModel(viewmodel.headerViewModel)
        }
    }
    private let compositeDisposable = CompositeDisposable()
    private var singleSectionInfiniteTableViewManager: SingleSectionInfiniteTableViewManager<UITableView, SocialBusinessViewModel>!
    
    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(backButton)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        constrain(tableView) { view in
            view.top == view.superview!.top - 20
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
            view.leading == view.superview!.leading
        }
        
        constrain(backButton) { view in
            view.top == view.superview!.topMargin + 12
            view.leading == view.superview!.leading
            //view.width == 24
            view.height == 40
        }
        
        singleSectionInfiniteTableViewManager = SingleSectionInfiniteTableViewManager(tableView: tableView, viewmodel: self.viewmodel as! SocialBusinessViewModel)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.hidesBarsOnSwipe = false
        utilityHeaderView.setDetailInfoButtonStyleRegular()
        tableView.reloadData()
        
        // change the color of the back button based on where the table view is scrolled
        DynamicProperty(object: tableView, keyPath: "contentOffset").producer
            |> map({
                
                ($0 as! NSValue).CGPointValue()
            })
            |> start(next: {value in
                if value.y > self.headerView.frame.height - 64 {
                    let attributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: Fonts.FontAwesome, size: 17)!]
                    var attributedString = NSAttributedString(string: Icons.Chevron, attributes: attributes)
                    self.backButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
                } else {
                    let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: Fonts.FontAwesome, size: 17)!]
                    var attributedString = NSAttributedString(string: Icons.Chevron, attributes: attributes)
                    self.backButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
                }
        })
        
        compositeDisposable += viewmodel.fetchMoreData()
            |> take(1)
            |> start()
        
        compositeDisposable += utilityHeaderView.detailInfoProxy
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.SocialBusiness, "utilityHeaderView.detailInfoProxy")
            |> start(next: { [weak self] in
                self?.viewmodel.pushBusinessDetail(true)
            })
        
        compositeDisposable +=  utilityHeaderView.startEventProxy
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.SocialBusiness, "utilityHeaderView.startEventProxy")
            |> promoteErrors(NSError)
            |> flatMap(FlattenStrategy.Concat) { _ -> SignalProducer<Bool, NSError> in
                return self.viewmodel.participate(ParticipationType.ToGo)
            }
            |> start()
        
        let tapGesture = UITapGestureRecognizer()
        headerView.addGestureRecognizer(tapGesture)
        compositeDisposable += tapGesture.rac_gestureSignal().toSignalProducer()
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.SocialBusiness, "SocialBusinessHeaderView tapGesture")
            |> start(next: { [weak self] _ in
                self?.viewmodel.pushBusinessDetail(true)
            })
        
        // create a signal associated with `tableView:didSelectRowAtIndexPath:` form delegate `UITableViewDelegate`
        // when the specified row is now selected
        compositeDisposable += rac_signalForSelector(Selector("tableView:didSelectRowAtIndexPath:"), fromProtocol: UITableViewDelegate.self).toSignalProducer()
            // forwards events from producer until the view controller is going to disappear
            |> takeUntilViewWillDisappear(self)
            |> map { ($0 as! RACTuple).second as! NSIndexPath }
            |> logLifeCycle(LogContext.SocialBusiness, "tableView:didSelectRowAtIndexPath:")
            |> start(
                next: { [weak self] indexPath in
                    self?.viewmodel.pushUserProfile(indexPath.row, animated: true)
                }
            )
        
        compositeDisposable += singleSectionInfiniteTableViewManager.reactToDataSource(targetedSection: 0)
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.SocialBusiness, "viewmodel.collectionDataSource.producer")
            |> start()
        
        /**
        Assigning UITableView delegate has to happen after signals are established.
        
        - tableView.delegate is assigned to self somewhere in UITableViewController designated initializer
        
        - UITableView caches presence of optional delegate methods to avoid -respondsToSelector: calls
        
        - You use -rac_signalForSelector:fromProtocol: and RAC creates method implementation for you in runtime. But UITableView knows nothing about this implementation, it still thinks that there's no such method
        
        The solution is to reassign delegate after all your -rac_signalForSelector:fromProtocol: calls:
        */
        tableView.delegate = nil
        tableView.delegate = self
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    public func getHeaderDestinationPoint() -> CGPoint {
        let headerRect = view.convertRect(headerView.frame, fromView: headerView)
        return headerRect.origin
    }

    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: ISocialBusinessViewModel) {
        self.viewmodel = viewmodel
        
    }
    
    // MARK: - Others
}

extension SocialBusinessViewController : UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return viewmodel.collectionDataSource.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier(UserCellIdentifier) as! SocialBusiness_UserCell
        cell.bindViewModel(viewmodel.collectionDataSource.array[indexPath.row])
        return cell
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return utilityHeaderView
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 59
    }
}

extension SocialBusinessViewController : UINavigationControllerDelegate {
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC is SocialBusinessViewController && toVC is BusinessDetailViewController && operation == .Push {
            
            // convert to navigation controller's coordinate system so that the height of status bar and navigation bar is taken into account of
            let start: CGRect
            var destination = CGPointMake(0, 0)

            start = view.convertRect(headerView.frame, fromView: headerView)
            
            if let image = viewmodel.businessCoverImage {
                let animateHeaderView = SocialBusinessHeaderView(frame: headerView.frame)
                animateHeaderView.bindToViewModel(viewmodel.headerViewModel)
                return SBtoBDAnimator(startRect: start, destination: destination, headerView: animateHeaderView, utilityHeaderView: self.utilityHeaderView)
            }
            else {
                return nil
            }
        }
        return nil
    }
}

