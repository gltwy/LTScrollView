 //
//  LTSimpleManager.swift
//  LTScrollView
//
//  Created by 高刘通 on 2018/2/3.
//  Copyright © 2018年 LT. All rights reserved.
//

import UIKit

public class LTSimpleManager: UIView {
    
    public func configHeaderView(_ handle: (() -> UIView?)?) {
        guard let handle = handle else { return }
        guard let headerView = handle() else { return }
        kHeaderHeight = headerView.bounds.height
        tableView.tableHeaderView = headerView
    }
    
    public typealias LTSimpleDidSelectIndexHandle = (Int) -> Void
    public var sampleDidSelectIndexHandle: LTSimpleDidSelectIndexHandle?
    public func didSelectIndexHandle(_ handle: LTSimpleDidSelectIndexHandle?) {
        guard let handle = handle else { return }
        sampleDidSelectIndexHandle = handle
    }
    
    public typealias LTSimpleRefreshTableViewHandle = (UIScrollView, Int) -> Void
    public var simpleRefreshTableViewHandle: LTSimpleRefreshTableViewHandle?
    public func refreshTableViewHandle(_ handle: LTSimpleRefreshTableViewHandle?) {
        guard let handle = handle else { return }
        simpleRefreshTableViewHandle = handle
    }
    
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

    public init(viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: LTLayout) {
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
    
    public init(frame: CGRect, viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: LTLayout) {
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
        return pageView
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
        } else {
            // Fallback on earlier versions
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
            guard let simpleRefreshTableViewHandle = self.simpleRefreshTableViewHandle else { return }
            simpleRefreshTableViewHandle(self.tableView, self.currentSelectIndex)
        }
    }
}

extension LTSimpleManager {
    private func pageViewDidSelectConfig()  {
        pageView.didSelectIndexBlock = {[weak self] in
            guard let `self` = self else { return }
            self.currentSelectIndex = $1
            self.refreshData()
            guard let handle = self.sampleDidSelectIndexHandle else { return }
            handle($1)
        }
        pageView.addChildVcBlock = {[weak self] in
            guard let `self` = self else { return }
            self.contentScrollViewScrollConfig($1)
        }
    }
}

extension LTSimpleManager: UITableViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
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

