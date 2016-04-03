//
//  SocialBusinessViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Dollar
import Cartography
import AMScrollingNavbar

private let UserCellIdentifier = "SocialBusiness_UserCell"
private let userControllerIdentifier = "UserProfileViewController"
private let BusinessHeightRatio = 0.61
private let UserHeightRatio = 0.224
private let ScreenWidth = UIScreen.mainScreen().bounds.size.width
private let WTGBarHeight = CGFloat(70)

final class SocialBusinessViewController : XUIViewController {
    
    typealias InputViewModel = (modelSelected: ControlEvent<UserInfo>, refreshTrigger: Observable<Void>, fetchMoreTrigger: Observable<Void>) -> ISocialBusinessViewModel

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

        return tableView
    }()
    
    private let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, UserInfo>>()

    private lazy var backButton: BackButton = {
        let button = BackButton()

        let goBack = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { observer, disposable in
                self?.navigationController?.popViewControllerAnimated(true)
                observer.sendCompleted()
            }
        }

        button.addTarget(goBack.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)

        return button
    }()

    private lazy var headerView: SocialBusinessHeaderView = {
        let view = SocialBusinessHeaderView(frame: CGRectMake(0, 0, ScreenWidth, CGFloat(ScreenWidth) * CGFloat(BusinessHeightRatio)))

        return view
    }()

    private lazy var utilityHeaderView: SocialBusiness_UtilityHeaderView = {
        let view = SocialBusiness_UtilityHeaderView()
        view.setDetailInfoButtonStyleRegular()
        view.addSubview(DividerView(frame: CGRect(x: 0, y: 59, width: ScreenWidth, height: 1)))
        return view
    }()

    // MARK: - Properties
    private var inputViewModel: InputViewModel!
    private var viewmodel: ISocialBusinessViewModel!
//        didSet {
//            headerView.bindToViewModel(viewmodel.headerViewModel)
//        }
        
//    private let compositeDisposable = CompositeDisposable()
//    private var singleSectionInfiniteTableViewManager: SingleSectionInfiniteTableViewManager<UITableView, SocialBusinessViewModel>!
    
    // MARK: - Life Cycle
    
    private static let startLoadingOffset: CGFloat = 20.0
    
    private static func isNearTheBottomEdge(contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
        return contentOffset.y + tableView.frame.size.height + startLoadingOffset > tableView.contentSize.height
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        singleSectionInfiniteTableViewManager = SingleSectionInfiniteTableViewManager(tableView: tableView, viewmodel: self.viewmodel as! SocialBusinessViewModel)
        
        let tableView = self.tableView

        view.addSubview(tableView)
        view.addSubview(backButton)

        constrain(tableView) { view in
            view.top == view.superview!.top - 20
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
            view.leading == view.superview!.leading
        }

        constrain(backButton) { view in
            view.top == view.superview!.topMargin + 12
            view.leading == view.superview!.leading
        }

        
        dataSource.configureCell = { _, tv, ip, info in
            let cell = tv.dequeueReusableCellWithIdentifier(UserCellIdentifier) as! SocialBusiness_UserCell
            cell.bindToCellData(info)
            
            return cell
        }
        
        let loadNextPageTrigger = tableView.rx_contentOffset
            .debug("sdfsdfsdf")
            .flatMap { offset in
                SocialBusinessViewController.isNearTheBottomEdge(offset, tableView)
                    ? Observable.empty()
                    : Observable.empty()
            }
            .startWith(())
        
        let modelSelected = tableView.rx_modelSelected(UserInfo)
        
        viewmodel = inputViewModel(modelSelected: modelSelected, refreshTrigger: Observable.just(()), fetchMoreTrigger: loadNextPageTrigger)
        headerView.bindToCellData(viewmodel.businessName, location: viewmodel.city, eta: viewmodel.calculateEta(), imageURL: viewmodel.businessImageURL)
        title = viewmodel.businessName
        
        
        
        // change the color of the back button based on where the table view is scrolled
        //        DynamicProperty(object: tableView, keyPath: "contentOffset").producer
        tableView.rx_contentOffset
            .subscribeNext {value in
                if value.y > self.headerView.frame.height - 64 {
                    let attributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont(name: Fonts.FontAwesome, size: 17)!]
                    let attributedString = NSAttributedString(string: Icons.Chevron.rawValue, attributes: attributes)
                    self.backButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
                }
                else {
                    let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: Fonts.FontAwesome, size: 17)!]
                    let attributedString = NSAttributedString(string: Icons.Chevron.rawValue, attributes: attributes)
                    self.backButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
                }
            }
            .addDisposableTo(disposeBag)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Use followScrollView(_: delay:) to start following the scrolling of a scrollable view (e.g.: a UIScrollView or UITableView).
        let navigationController = self.navigationController as? ScrollingNavigationController
        navigationController?.followScrollView(tableView, delay: 50.0)

//        utilityHeaderView.setDetailInfoButtonStyleRegular()
        

//        compositeDisposable += viewmodel.fetchMoreData()
//            .take(1)
//            .start()
//
//        compositeDisposable += utilityHeaderView.detailInfoProxy
//            .takeUntilViewWillDisappear(self)
//            .logLifeCycle(LogContext.SocialBusiness, signalName: "utilityHeaderView.detailInfoProxy")
//            .startWithNext { [weak self] in
//                self?.viewmodel.pushBusinessDetail(true)
//            }
//
//        compositeDisposable +=  utilityHeaderView.startEventProxy
//            .takeUntilViewWillDisappear(self)
//            .logLifeCycle(LogContext.SocialBusiness, signalName: "utilityHeaderView.startEventProxy")
//            .promoteErrors(NSError)
//            .startWithNext {
//                self.showParticipationOptions()
//            }
//
//        let tapGesture = UITapGestureRecognizer()
//        headerView.addGestureRecognizer(tapGesture)
//        compositeDisposable += tapGesture.rac_gestureSignal().toSignalProducer()
//            .takeUntilViewWillDisappear(self)
//            .logLifeCycle(LogContext.SocialBusiness, signalName: "SocialBusinessHeaderView tapGesture")
//            .startWithNext { [weak self] _ in
//                self?.viewmodel.pushBusinessDetail(true)
//            }
//
//        // create a signal associated with `tableView:didSelectRowAtIndexPath:` form delegate `UITableViewDelegate`
//        // when the specified row is now selected
//        compositeDisposable += rac_signalForSelector(Selector("tableView:didSelectRowAtIndexPath:"), fromProtocol: UITableViewDelegate.self).toSignalProducer()
//            // forwards events from producer until the view controller is going to disappear
//            .takeUntilViewWillDisappear(self)
//            .map { ($0 as! RACTuple).second as! NSIndexPath }
//            .logLifeCycle(LogContext.SocialBusiness, signalName: "tableView:didSelectRowAtIndexPath:")
//            .startWithNext { [weak self] indexPath in
//                self?.viewmodel.pushUserProfile(indexPath.row, animated: true)
//            }
//
//        compositeDisposable += singleSectionInfiniteTableViewManager.reactToDataSource(targetedSection: 0)
//            .takeUntilViewWillDisappear(self)
//            .logLifeCycle(LogContext.SocialBusiness, signalName: "viewmodel.collectionDataSource.producer")
//            .start()

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Stop the behaviour when view will
        (self.navigationController as? ScrollingNavigationController)?.showNavbar(animated: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // if the view controller with the scroll view pushes new controllers, call showNavbar(animated:) in your viewWillDisappear(animated:)
        (self.navigationController as? ScrollingNavigationController)?.showNavbar(animated: true)
    }

    func getHeaderDestinationPoint() -> CGPoint {
        let headerRect = view.convertRect(headerView.frame, fromView: headerView)
        return headerRect.origin
    }

    // MARK: - Bindings
    
    func bindToViewModel(inputViewModel: InputViewModel) {
        self.inputViewModel = inputViewModel
    }

    // MARK: - Others

//    private func showParticipationOptions() {
//        let wtgAlert = UIAlertController(title: "你想怎么约?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
//
//        wtgAlert.addAction(UIAlertAction(title: ParticipationType.Treat.description, style: .Default, handler: { (action: UIAlertAction!) in
//            self.utilityHeaderView.disableStartEventButton(ParticipationType.Treat)
//            self.viewmodel.participate(ParticipationType.Treat)
//        }))
//
//        wtgAlert.addAction(UIAlertAction(title: ParticipationType.AA.description, style: .Default, handler: { (action: UIAlertAction!) in
//            self.utilityHeaderView.disableStartEventButton(ParticipationType.AA)
//            self.viewmodel.participate(ParticipationType.AA)
//        }))
//
//        wtgAlert.addAction(UIAlertAction(title: ParticipationType.ToGo.description, style: .Default, handler: { (action: UIAlertAction!) in
//            self.utilityHeaderView.disableStartEventButton(ParticipationType.ToGo)
//            self.viewmodel.participate(ParticipationType.ToGo)
//        }))
//
//        wtgAlert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (action: UIAlertAction!) in
//
//        }))
//
//        presentViewController(wtgAlert, animated: true, completion: nil)
//
//    }
}

extension SocialBusinessViewController : UITableViewDelegate {

//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return utilityHeaderView
//    }

//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 59
//    }
}

//extension SocialBusinessViewController : UINavigationControllerDelegate {
//    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        if fromVC is SocialBusinessViewController && toVC is BusinessDetailViewController && operation == .Push {
//
//            // convert to navigation controller's coordinate system so that the height of status bar and navigation bar is taken into account of
//            let start: CGRect
//            let destination = CGPointMake(0, 0)
//
//            start = view.convertRect(headerView.frame, fromView: headerView)
//
//            if let _ = viewmodel.businessCoverImage {
//                let animateHeaderView = SocialBusinessHeaderView(frame: headerView.frame)
//                animateHeaderView.bindToViewModel(viewmodel.headerViewModel)
//                return SBtoBDAnimator(startRect: start, destination: destination, headerView: animateHeaderView, utilityHeaderView: self.utilityHeaderView)
//            }
//            else {
//                return nil
//            }
//        }
//        return nil
//    }
//}
//
