//
//  LTAdvancedManager.swift
//  LTScrollView_Example
//
//  Created by 高刘通 on 2018/2/6.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

public class LTAdvancedManager: UIView {
    
    public typealias LTAdvancedDidSelectIndexHandle = (Int) -> Void
    public var advancedDidSelectIndexHandle: LTAdvancedDidSelectIndexHandle?

    private var kHeaderHeight: CGFloat = 0.0
    private var currentSelectIndex: Int = 0
    private var lastDiffTitleToNav:CGFloat = 0.0
    private var headerView: UIView?
    private var viewControllers: [UIViewController]
    private var titles: [String]
    private var currentViewController: UIViewController
    private var pageView: LTPageView!
    
    public init(viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: LTLayout, headerViewHandle handle: () -> UIView) {
        UIScrollView.initializeOnce()
        self.viewControllers = viewControllers
        self.titles = titles
        self.currentViewController = currentViewController
        let Y: CGFloat = glt_iphoneX ? 64+24 : 64
        let defaultFrame = CGRect(x: 0, y: Y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height  - Y)
        super.init(frame: defaultFrame)
        pageView = createPageViewConfig(currentViewController: currentViewController, layout: layout)
        initSubViewsConfig(handle)
    }
    
    public init(frame: CGRect, viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: LTLayout, headerViewHandle handle: () -> UIView) {
        UIScrollView.initializeOnce()
        self.viewControllers = viewControllers
        self.titles = titles
        self.currentViewController = currentViewController
        super.init(frame: frame)
        pageView = createPageViewConfig(currentViewController: currentViewController, layout: layout)
        initSubViewsConfig(handle)
    }
  
    private func initSubViewsConfig(_ handle: () -> UIView) {
        let headerView = handle()
        kHeaderHeight = headerView.bounds.height
        self.headerView = headerView
        lastDiffTitleToNav = kHeaderHeight
        createSubViews()
        addSubview(headerView)
    }
    
    public init(viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: LTLayout) {
        UIScrollView.initializeOnce()
        self.viewControllers = viewControllers
        self.titles = titles
        self.currentViewController = currentViewController
        let Y: CGFloat = glt_iphoneX ? 64+24 : 64
        let defaultFrame = CGRect(x: 0, y: Y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height  - Y)
        super.init(frame: defaultFrame)
        pageView = createPageViewConfig(currentViewController: currentViewController, layout: layout)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LTAdvancedManager {
    
    private func createSubViews() {
        pageView.pageTitleView.frame.origin.y = kHeaderHeight
        backgroundColor = UIColor.white
        addSubview(pageView)
        pageViewDidSelect()
        pageView.addChildVcBlock = {[weak self] in
            guard let `self` = self else { return }
            let vc = self.viewControllers[$0]
            vc.glt_scrollView?.contentOffset.y = self.distanceBottomOffset()
            self.contentScrollViewScrollConfig($1)
            self.scrollInsets(vc, self.kHeaderHeight+44)
        }
        guard let viewController = viewControllers.first else { return }
        self.contentScrollViewScrollConfig(viewController)
        scrollInsets(viewController, kHeaderHeight+44)
    }
  
    private func scrollInsets(_ currentVC: UIViewController ,_ up: CGFloat) {
        currentVC.glt_scrollView?.contentInset = UIEdgeInsetsMake(up, 0, 0, 0)
        currentVC.glt_scrollView?.scrollIndicatorInsets = UIEdgeInsetsMake(up, 0, 0, 0)
    }
}

extension LTAdvancedManager {
    
    private func createPageViewConfig(currentViewController:UIViewController, layout: LTLayout) -> LTPageView {
        let pageView = LTPageView(frame: self.bounds, currentViewController: currentViewController, viewControllers: viewControllers, titles: titles, layout:layout)
        return pageView
    }
}

extension LTAdvancedManager {
    func pageViewDidSelect()  {
        pageView.didSelectIndexBlock = {[weak self] in
            guard let `self` = self else { return }
            self.currentSelectIndex = $1
            guard let handle = self.advancedDidSelectIndexHandle else { return }
            handle($1)
        }
    }
}

extension LTAdvancedManager {
    
    private func contentScrollViewScrollConfig(_ viewController: UIViewController) {
        viewController.glt_scrollView?.scrollHandle = {[weak self] scrollView in
            guard let `self` = self else { return }
            let currentVc = self.viewControllers[self.currentSelectIndex]
            let scrollUpOffset = CGFloat(Double(currentVc.glt_upOffset ?? String(describing: self.distanceBottomOffset())) ?? Double(self.distanceBottomOffset()))
            let absOffset = scrollView.contentOffset.y - scrollUpOffset
            self.contentScrollViewDidScroll(scrollView, absOffset)
            currentVc.glt_upOffset = String(describing: scrollView.contentOffset.y)
        }
    }
    
    private func distanceBottomOffset() -> CGFloat {
        return -(self.pageView.pageTitleView.frame.origin.y + 44)
    }
    
    private func contentScrollViewDidScroll(_ contentScrollView: UIScrollView, _ absOffset: CGFloat)  {
        let currentVc = viewControllers[self.currentSelectIndex]
        guard currentVc.glt_scrollView == contentScrollView else { return }
        let offsetY = contentScrollView.contentOffset.y
        var pageTitleViewY = pageView.pageTitleView.frame.origin.y
        let titleViewBottomDistance = offsetY + kHeaderHeight + 44
        let headerViewOffset = titleViewBottomDistance + pageTitleViewY
        if absOffset > 0 && titleViewBottomDistance > 0 {
            if headerViewOffset >= kHeaderHeight {
                pageTitleViewY += -absOffset
                if pageTitleViewY <= 0 { pageTitleViewY = 0 }
            }
        }else{
            if headerViewOffset <= kHeaderHeight {
                pageTitleViewY = -titleViewBottomDistance + kHeaderHeight
                if pageTitleViewY >= kHeaderHeight { pageTitleViewY = kHeaderHeight }
            }
        }
        pageView.pageTitleView.frame.origin.y = pageTitleViewY
        headerView?.frame.origin.y = pageTitleViewY - kHeaderHeight
        let lastDiffTitleToNavOffset = pageTitleViewY - lastDiffTitleToNav
        lastDiffTitleToNav = pageTitleViewY
        for VC in viewControllers {
            guard VC != currentVc else { continue }
            VC.glt_scrollView?.contentOffset.y += (-lastDiffTitleToNavOffset)
        }
    }
}

