 //
 //  LTSimpleManager.swift
 //  LTScrollView
 //
 //  Created by 高刘通 on 2018/2/3.
 //  Copyright © 2018年 LT. All rights reserved.
 //
 
 import UIKit
 
 @objc public protocol LTSimpleScrollViewDelegate: class {
    @objc optional func glt_scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func glt_scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
 }
 
 public class LTSimpleManager: UIView {
    
    @objc public func configHeaderView(_ handle: (() -> UIView?)?) {
        guard let handle = handle else { return }
        guard let headerView = handle() else { return }
        kHeaderHeight = headerView.bounds.height
        tableView.tableHeaderView = headerView
    }
    
    public typealias LTSimpleDidSelectIndexHandle = (Int) -> Void
    @objc public var sampleDidSelectIndexHandle: LTSimpleDidSelectIndexHandle?
    @objc  public func didSelectIndexHandle(_ handle: LTSimpleDidSelectIndexHandle?) {
        guard let handle = handle else { return }
        sampleDidSelectIndexHandle = handle
    }
    
    public typealias LTSimpleRefreshTableViewHandle = (UIScrollView, Int) -> Void
    @objc public var simpleRefreshTableViewHandle: LTSimpleRefreshTableViewHandle?
    @objc public func refreshTableViewHandle(_ handle: LTSimpleRefreshTableViewHandle?) {
        guard let handle = handle else { return }
        simpleRefreshTableViewHandle = handle
    }
    
    /* LTSimple的scrollView上下滑动监听 */
    @objc public weak var delegate: LTSimpleScrollViewDelegate?
    
    private var contentTableView: UIScrollView?
    private var kHeaderHeight: CGFloat = 0.0
    private var headerView: UIView?
    private var viewControllers: [UIViewController]
    private var titles: [String]
    private var currentViewController: UIViewController
    private var pageView: LTPageView!
    private var currentSelectIndex: Int = 0
    
    private lazy var tableView: LTTableView = {
        let tableView = LTTableView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height), style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        registerCell(tableView, UITableViewCell.self)
        return tableView
    }()
    
    @objc public init(viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: LTLayout) {
        UIScrollView.initializeOnce()
        self.viewControllers = viewControllers
        self.titles = titles
        self.currentViewController = currentViewController
        let Y: CGFloat = glt_iphoneX ? 64+24 : 64
        let defaultFrame = CGRect(x: 0, y: Y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height  - Y)
        super.init(frame: defaultFrame)
        pageView = createPageViewConfig(currentViewController: currentViewController, layout: layout)
        createSubViews()
    }
    
    @objc public init(frame: CGRect, viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: LTLayout) {
        UIScrollView.initializeOnce()
        self.viewControllers = viewControllers
        self.titles = titles
        self.currentViewController = currentViewController
        super.init(frame: frame)
        pageView = createPageViewConfig(currentViewController: currentViewController, layout: layout)
        createSubViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deallocConfig()
    }
 }
 
 extension LTSimpleManager {
    
    private func createPageViewConfig(currentViewController:UIViewController, layout: LTLayout) -> LTPageView {
        let pageView = LTPageView(frame: self.bounds, currentViewController: currentViewController, viewControllers: viewControllers, titles: titles, layout:layout)
        pageView.delegate = self
        return pageView
    }
 }
 
 extension LTSimpleManager: LTPageViewDelegate {
    
    public func glt_scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.tableView.isScrollEnabled = false
    }
    
    public func glt_scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.tableView.isScrollEnabled = true
    }
    
 }
 
 extension LTSimpleManager {
    
    private func createSubViews() {
        backgroundColor = UIColor.white
        addSubview(tableView)
        refreshData()
        pageViewDidSelectConfig()
        guard let viewController = viewControllers.first else { return }
        contentScrollViewScrollConfig(viewController)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func contentScrollViewScrollConfig(_ viewController: UIViewController) {
        viewController.glt_scrollView?.scrollHandle = {[weak self] scrollView in
            guard let `self` = self else { return }
            self.contentTableView = scrollView
            if self.tableView.contentOffset.y < self.kHeaderHeight {
                scrollView.contentOffset = .zero;
                scrollView.showsVerticalScrollIndicator = false
            }else{
                scrollView.showsVerticalScrollIndicator = true
            }
        }
    }
    
 }
 
 extension LTSimpleManager {
    private func refreshData()  {
        DispatchQueue.main.after(0.001) {
            UIView.animate(withDuration: 0.34, animations: {
                self.tableView.contentInset = .zero
            })
            self.simpleRefreshTableViewHandle?(self.tableView, self.currentSelectIndex)
        }
    }
 }
 
 extension LTSimpleManager {
    private func pageViewDidSelectConfig()  {
        pageView.didSelectIndexBlock = {[weak self] in
            guard let `self` = self else { return }
            self.currentSelectIndex = $1
            self.refreshData()
            self.sampleDidSelectIndexHandle?($1)
        }
        pageView.addChildVcBlock = {[weak self] in
            guard let `self` = self else { return }
            self.contentScrollViewScrollConfig($1)
        }
        
    }
 }
 
 extension LTSimpleManager: UITableViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidScroll?(scrollView)
        guard scrollView == tableView, let contentTableView = contentTableView else { return }
        let offsetY = scrollView.contentOffset.y
        if contentTableView.contentOffset.y > 0.0 || offsetY > kHeaderHeight {
            tableView.contentOffset = CGPoint(x: 0.0, y: kHeaderHeight)
        }
        if scrollView.contentOffset.y < kHeaderHeight {
            for viewController in viewControllers {
                guard viewController.glt_scrollView != scrollView else { continue }
                viewController.glt_scrollView?.contentOffset = .zero
            }
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewWillBeginDragging?(scrollView)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.glt_scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
 }
 
 extension LTSimpleManager: UITableViewDataSource, LTTableViewProtocal {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellWithTableView(tableView)
        cell.selectionStyle = .none
        cell.contentView.addSubview(pageView)
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height
    }
 }
 
 extension LTSimpleManager {
    private func deallocConfig() {
        for viewController in viewControllers {
            viewController.glt_scrollView?.delegate = nil
        }
    }
 }
 
 
