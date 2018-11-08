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
    
    //设置悬停位置Y值
    @objc public var hoverY: CGFloat = 0
    
    /* 点击切换滚动过程动画 */
    @objc public var isClickScrollAnimation = false {
        didSet {
            titleView.isClickScrollAnimation = isClickScrollAnimation
        }
    }
    
    /* 代码设置滚动到第几个位置 */
    @objc public func scrollToIndex(index: Int)  {
        pageView.scrollToIndex(index: index)
    }
    
    private var kHeaderHeight: CGFloat = 0.0
    private var currentSelectIndex: Int = 0
    private var lastDiffTitleToNav:CGFloat = 0.0
    private var headerView: UIView?
    private var viewControllers: [UIViewController]
    private var titles: [String]
    private weak var currentViewController: UIViewController?
    private var pageView: LTPageView!
    private var layout: LTLayout
    var isCustomTitleView: Bool = false
    
    private var titleView: LTPageTitleView!
    
    @objc public init(frame: CGRect, viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: LTLayout, titleView: LTPageTitleView? = nil, headerViewHandle handle: () -> UIView) {
        UIScrollView.initializeOnce()
        UICollectionViewFlowLayout.loadOnce()
        self.viewControllers = viewControllers
        self.titles = titles
        self.currentViewController = currentViewController
        self.layout = layout
        super.init(frame: frame)
        UICollectionViewFlowLayout.glt_sliderHeight = layout.sliderHeight
        layout.isSinglePageView = true
        if titleView != nil {
            isCustomTitleView = true
            self.titleView = titleView!
        }else {
            self.titleView = setupTitleView()
        }
        self.titleView.isCustomTitleView = isCustomTitleView
        pageView = setupPageViewConfig(currentViewController: currentViewController, layout: layout, titleView: titleView)
        setupSubViewsConfig(handle)
    }
    
    deinit {
        deallocConfig()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LTAdvancedManager {
    private func setupTitleView() -> LTPageTitleView {
        let titleView = LTPageTitleView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: layout.sliderHeight), titles: titles, layout: layout)
        return titleView
    }
}


extension LTAdvancedManager {
    //MARK: 创建PageView
    private func setupPageViewConfig(currentViewController:UIViewController, layout: LTLayout, titleView: LTPageTitleView?) -> LTPageView {
        let pageView = LTPageView(frame: self.bounds, currentViewController: currentViewController, viewControllers: viewControllers, titles: titles, layout:layout, titleView: titleView)
        if titles.count != 0 {
            pageView.glt_createViewController(0)
        }
        DispatchQueue.main.after(0.01) {
            pageView.addSubview(self.titleView)
            pageView.setupGetPageViewScrollView(pageView, self.titleView)
        }
        return pageView
    }
}


extension LTAdvancedManager {
    
    private func setupSubViewsConfig(_ handle: () -> UIView) {
        let headerView = handle()
        kHeaderHeight = headerView.bounds.height
        self.headerView = headerView
        lastDiffTitleToNav = kHeaderHeight
        setupSubViews()
        addSubview(headerView)
    }
    
    private func setupSubViews() {
        titleView.frame.origin.y = kHeaderHeight
        backgroundColor = UIColor.white
        addSubview(pageView)
        setupPageViewDidSelectItem()
        setupFirstAddChildViewController()
        guard let viewController = viewControllers.first else { return }
        self.contentScrollViewScrollConfig(viewController)
        scrollInsets(viewController, kHeaderHeight+layout.sliderHeight)
    }
    
}


extension LTAdvancedManager {
    
    //设置ScrollView的contentInset
    private func scrollInsets(_ currentVC: UIViewController ,_ up: CGFloat) {
        currentVC.glt_scrollView?.contentInset = UIEdgeInsetsMake(up, 0, 0, 0)
        currentVC.glt_scrollView?.scrollIndicatorInsets = UIEdgeInsetsMake(up, 0, 0, 0)
    }
    
    //MARK: 首次创建pageView的ChildVC回调
    private func setupFirstAddChildViewController() {
        
        //首次创建pageView的ChildVC回调
        pageView.addChildVcBlock = {[weak self] in
            guard let `self` = self else { return }
            let currentVC = self.viewControllers[$0]
            
            //设置ScrollView的contentInset
            self.scrollInsets(currentVC, self.kHeaderHeight+self.layout.sliderHeight)
            //            self.scrollInsets(currentVC, 100)
            
            //初始化滚动回调 首次加载并不会执行内部方法
            self.contentScrollViewScrollConfig($1)
            
            //注意：节流---否则此方法无效。。
            self.setupFirstAddChildScrollView()
        }
    }
    
    func glt_adjustScrollViewContentSizeHeight(glt_scrollView: UIScrollView?) {
        guard let glt_scrollView = glt_scrollView else { return }
        //当前ScrollView的contentSize的高 = 当前ScrollView的的高 避免自动掉落
        let sliderH = self.layout.sliderHeight
        if glt_scrollView.contentSize.height < glt_scrollView.bounds.height - sliderH {
            glt_scrollView.contentSize.height = glt_scrollView.bounds.height - sliderH
        }
    }
    
    //MARK: 首次创建pageView的ChildVC回调 自适应调节
    private func setupFirstAddChildScrollView() {
        
        //注意：节流---否则此方法无效。。
        DispatchQueue.main.after(0.01, execute: {
            
            let currentVC = self.viewControllers[self.currentSelectIndex]
            
            guard let glt_scrollView = currentVC.glt_scrollView else { return }
            
            self.glt_adjustScrollViewContentSizeHeight(glt_scrollView: glt_scrollView)
            
            glt_scrollView.contentOffset.y = self.distanceBottomOffset()
            
            /*
             //当前ScrollView的contentSize的高
             let contentSizeHeight = glt_scrollView.contentSize.height
             
             //当前ScrollView的的高
             let boundsHeight = glt_scrollView.bounds.height - self.layout.sliderHeight
             
             //此处说明内容的高度小于bounds 应该让pageTitleView自动回滚到初始位置
             if contentSizeHeight <  boundsHeight {
             
             //为自动掉落加一个动画
             UIView.animate(withDuration: 0.12, animations: {
             //初始的偏移量 即初始的contentInset的值
             let offsetPoint = CGPoint(x: 0, y: -self.kHeaderHeight-self.layout.sliderHeight)
             
             //注意：此处调用此方法并不会执行scrollViewDidScroll:原因未可知
             glt_scrollView.setContentOffset(offsetPoint, animated: true)
             
             //在这里手动执行一下scrollViewDidScroll:事件
             self.setupGlt_scrollViewDidScroll(scrollView: glt_scrollView, currentVC: currentVC)
             })
             
             
             }else {
             //首次初始化，通过改变当前ScrollView的偏移量，来确保ScrollView正好在pageTitleView下方
             glt_scrollView.contentOffset.y = self.distanceBottomOffset()
             }
             */
        })
        
    }
    
    //MARK: 当前的scrollView滚动的代理方法开始
    private func contentScrollViewScrollConfig(_ viewController: UIViewController) {
        
        viewController.glt_scrollView?.scrollHandle = {[weak self] scrollView in
            
            guard let `self` = self else { return }
            
            let currentVC = self.viewControllers[self.currentSelectIndex]
            
            guard currentVC.glt_scrollView == scrollView else { return }
            
            self.glt_adjustScrollViewContentSizeHeight(glt_scrollView: currentVC.glt_scrollView)
            
            self.setupGlt_scrollViewDidScroll(scrollView: scrollView, currentVC: currentVC)
        }
    }
    
    //MARK: 当前控制器的滑动方法事件处理 1
    private func setupGlt_scrollViewDidScroll(scrollView: UIScrollView, currentVC: UIViewController)  {
        
        //pageTitleView距离屏幕顶部到pageTitleView最底部的距离
        let distanceBottomOffset = self.distanceBottomOffset()
        
        //当前控制器上一次的偏移量
        let glt_upOffsetString = currentVC.glt_upOffset ?? String(describing: distanceBottomOffset)
        
        //先转化为Double(String转CGFloat步骤：String -> Double -> CGFloat)
        let glt_upOffsetDouble = Double(glt_upOffsetString) ?? Double(distanceBottomOffset)
        
        //再转化为CGFloat
        let glt_upOffset = CGFloat(glt_upOffsetDouble)
        
        //计算上一次偏移和当前偏移量y的差值
        let absOffset = scrollView.contentOffset.y - glt_upOffset
        
        //处理滚动
        self.contentScrollViewDidScroll(scrollView, absOffset)
        
        //记录上一次的偏移量
        currentVC.glt_upOffset = String(describing: scrollView.contentOffset.y)
    }
    
    
    //MARK: 当前控制器的滑动方法事件处理 2
    private func contentScrollViewDidScroll(_ contentScrollView: UIScrollView, _ absOffset: CGFloat)  {
        
        //获取当前控制器
        let currentVc = viewControllers[currentSelectIndex]
        
        //外部监听当前ScrollView的偏移量
        self.delegate?.glt_scrollViewOffsetY?((currentVc.glt_scrollView?.contentOffset.y ?? kHeaderHeight) + self.kHeaderHeight + layout.sliderHeight)
        
        //获取偏移量
        let offsetY = contentScrollView.contentOffset.y
        
        //获取当前pageTitleView的Y值
        var pageTitleViewY = titleView.frame.origin.y
        
        //pageTitleView从初始位置上升的距离
        let titleViewBottomDistance = offsetY + kHeaderHeight + layout.sliderHeight
        
        let headerViewOffset = titleViewBottomDistance + pageTitleViewY
        
        if absOffset > 0 && titleViewBottomDistance > 0 {//向上滑动
            if headerViewOffset >= kHeaderHeight {
                pageTitleViewY += -absOffset
                if pageTitleViewY <= hoverY {
                    pageTitleViewY = hoverY
                }
            }
        }else{//向下滑动
            if headerViewOffset < kHeaderHeight {
                pageTitleViewY = -titleViewBottomDistance + kHeaderHeight
                if pageTitleViewY >= kHeaderHeight {
                    pageTitleViewY = kHeaderHeight
                }
            }
        }
        
        titleView.frame.origin.y = pageTitleViewY
        headerView?.frame.origin.y = pageTitleViewY - kHeaderHeight
        let lastDiffTitleToNavOffset = pageTitleViewY - lastDiffTitleToNav
        lastDiffTitleToNav = pageTitleViewY
        //使其他控制器跟随改变
        for subVC in viewControllers {
            glt_adjustScrollViewContentSizeHeight(glt_scrollView: subVC.glt_scrollView)
            guard subVC != currentVc else { continue }
            guard let vcGlt_scrollView = subVC.glt_scrollView else { continue }
            vcGlt_scrollView.contentOffset.y += (-lastDiffTitleToNavOffset)
            subVC.glt_upOffset = String(describing: vcGlt_scrollView.contentOffset.y)
        }
    }
    
    private func distanceBottomOffset() -> CGFloat {
        return -(titleView.frame.origin.y + layout.sliderHeight)
    }
}


extension LTAdvancedManager {
    
    //MARK: pageView选中事件
    private func setupPageViewDidSelectItem()  {
        
        pageView.didSelectIndexBlock = {[weak self] in
            
            guard let `self` = self else { return }
            
            self.setupUpViewControllerEndRefreshing()
            
            self.currentSelectIndex = $1
            
            self.advancedDidSelectIndexHandle?($1)
            
            self.setupContentSizeBoundsHeightAdjust()
            
        }
    }
    
    //MARK: 内容的高度小于bounds 应该让pageTitleView自动回滚到初始位置
    private func setupContentSizeBoundsHeightAdjust()  {
        
        DispatchQueue.main.after(0.01, execute: {
            
            let currentVC = self.viewControllers[self.currentSelectIndex]
            
            guard let glt_scrollView = currentVC.glt_scrollView else { return }
            
            self.glt_adjustScrollViewContentSizeHeight(glt_scrollView: glt_scrollView)
            
            //当前ScrollView的contentSize的高
            let contentSizeHeight = glt_scrollView.contentSize.height
            
            //当前ScrollView的的高
            let boundsHeight = glt_scrollView.bounds.height - self.layout.sliderHeight
            
            //此处说明内容的高度小于bounds 应该让pageTitleView自动回滚到初始位置
            //这里不用再进行其他操作，因为会调用ScrollViewDidScroll:
            if contentSizeHeight <  boundsHeight {
                let offsetPoint = CGPoint(x: 0, y: -self.kHeaderHeight-self.layout.sliderHeight)
                glt_scrollView.setContentOffset(offsetPoint, animated: true)
            }
        })
    }
    
    //MARK: 处理下拉刷新的过程中切换导致的问题
    private func setupUpViewControllerEndRefreshing() {
        //如果正在下拉，则在切换之前把上一个的ScrollView的偏移量设置为初始位置
        DispatchQueue.main.after(0.01) {
            let upVC = self.viewControllers[self.currentSelectIndex]
            guard let glt_scrollView = upVC.glt_scrollView else { return }
            //判断是下拉
            if glt_scrollView.contentOffset.y < (-self.kHeaderHeight-self.layout.sliderHeight) {
                let offsetPoint = CGPoint(x: 0, y: -self.kHeaderHeight-self.layout.sliderHeight)
                glt_scrollView.setContentOffset(offsetPoint, animated: true)
            }
        }
    }
    
}

extension LTAdvancedManager {
    private func deallocConfig() {
        for viewController in viewControllers {
            viewController.glt_scrollView?.delegate = nil
        }
    }
}
