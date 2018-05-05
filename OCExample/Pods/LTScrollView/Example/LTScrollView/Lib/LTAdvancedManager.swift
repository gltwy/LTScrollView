//
//  LTAdvancedManager.swift
//  LTScrollView_Example
//
//  Created by 高刘通 on 2018/2/6.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

@objc public protocol LTAdvancedScrollViewDelegate: class {
    @objc optional func glt_scrollViewOffsetY(_ offsetY: CGFloat)
}

public class LTAdvancedManager: UIView {
    
    public typealias LTAdvancedDidSelectIndexHandle = (Int) -> Void
    @objc public var advancedDidSelectIndexHandle: LTAdvancedDidSelectIndexHandle?
    
    @objc public weak var delegate: LTAdvancedScrollViewDelegate?
    
    private var kHeaderHeight: CGFloat = 0.0
    private var currentSelectIndex: Int = 0
    private var lastDiffTitleToNav:CGFloat = 0.0
    private var headerView: UIView?
    private var viewControllers: [UIViewController]
    private var titles: [String]
    private var currentViewController: UIViewController
    private var pageView: LTPageView!
    
//    @objc public var testVC: UIViewController?
    
    
    @objc public init(frame: CGRect, viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: LTLayout, headerViewHandle handle: () -> UIView) {
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
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LTAdvancedManager {
    
//    @objc public func loadSuccessData(_ notification: Notification) {
//        DispatchQueue.main.after(0.01, execute: {
//            let vc = self.testVC!
//            let contentSizeH = vc.glt_scrollView?.contentSize.height ?? 0
//            let boundsH = vc.glt_scrollView?.bounds.height ?? 0
//            if contentSizeH <  boundsH {
//                vc.glt_scrollView?.setContentOffset(CGPoint(x: 0, y: -self.kHeaderHeight-44), animated: true)
//                self.testMethod(vc.glt_scrollView!)
//            }else {
//                vc.glt_scrollView?.contentOffset.y = self.distanceBottomOffset()
//            }
//        })
//    }
    
    private func createSubViews() {
        
//        NotificationCenter.default.addObserver(self, selector: #selector(loadSuccessData(_:)), name: Notification.Name("loadSuccess"), object: nil)
        
        pageView.pageTitleView.frame.origin.y = kHeaderHeight
        backgroundColor = UIColor.white
        addSubview(pageView)
        pageViewDidSelect()
        pageView.addChildVcBlock = {[weak self] in
            guard let `self` = self else { return }
            let vc = self.viewControllers[$0]
//            self.testVC = vc
            self.scrollInsets(vc, self.kHeaderHeight+44)
            self.contentScrollViewScrollConfig($1)
            DispatchQueue.main.after(0.01, execute: {
                let contentSizeH = vc.glt_scrollView?.contentSize.height ?? 0
                let boundsH = vc.glt_scrollView?.bounds.height ?? 0
                if contentSizeH <  boundsH {
                    vc.glt_scrollView?.setContentOffset(CGPoint(x: 0, y: -self.kHeaderHeight-44), animated: true)
                    self.adjustMethod(vc.glt_scrollView!)
                }else {
                    vc.glt_scrollView?.contentOffset.y = self.distanceBottomOffset()
                }
            })
        }
        guard let viewController = viewControllers.first else { return }
//        self.testVC = viewController
        self.contentScrollViewScrollConfig(viewController)
        scrollInsets(viewController, kHeaderHeight+44)
    }
    
    func adjustMethod(_ scrollView: UIScrollView) {
        let currentVc = self.viewControllers[self.currentSelectIndex]
        let scrollUpOffset = CGFloat(Double(currentVc.glt_upOffset ?? String(describing: self.distanceBottomOffset())) ?? Double(self.distanceBottomOffset()))
        let absOffset = scrollView.contentOffset.y - scrollUpOffset
        self.contentScrollViewDidScroll(scrollView, absOffset)
        currentVc.glt_upOffset = String(describing: scrollView.contentOffset.y)
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
            self.advancedDidSelectIndexHandle?($1)
            let vc = self.viewControllers[self.currentSelectIndex]
            let contentSizeH = vc.glt_scrollView?.contentSize.height ?? 0
            let boundsH = vc.glt_scrollView?.bounds.height ?? 0
            if contentSizeH <  boundsH {
                vc.glt_scrollView?.setContentOffset(CGPoint(x: 0, y: -self.kHeaderHeight-44), animated: true)
            }
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
        self.delegate?.glt_scrollViewOffsetY?((currentVc.glt_scrollView?.contentOffset.y ?? 0) + self.kHeaderHeight + 44)
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

