//
//  LTPageView.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/14.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit

public typealias PageViewDidSelectIndexBlock = (LTPageView, Int) -> Void
public typealias AddChildViewControllerBlock = (Int, UIViewController) -> Void

@objc public protocol LTPageViewDelegate: class {
    @objc optional func glt_scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @objc optional func glt_scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional func glt_scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
}

public class LTPageView: UIView {
    
    private weak var currentViewController: UIViewController?
    private var viewControllers: [UIViewController]
    private var titles: [String]
    private var layout: LTLayout = LTLayout()
    private var glt_currentIndex: Int = 0;
    
    @objc public var didSelectIndexBlock: PageViewDidSelectIndexBlock?
    @objc public var addChildVcBlock: AddChildViewControllerBlock?
    
    /* 点击切换滚动过程动画  */
    @objc public var isClickScrollAnimation = false {
        didSet {
            pageTitleView.isClickScrollAnimation = isClickScrollAnimation
        }
    }
    
    /* pageView的scrollView左右滑动监听 */
    @objc public weak var delegate: LTPageViewDelegate?
    
    var isCustomTitleView: Bool = false
    
    var pageTitleView: LTPageTitleView!
    
    @objc public lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        scrollView.contentSize = CGSize(width: self.bounds.width * CGFloat(self.titles.count), height: 0)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = layout.isShowBounces
        scrollView.isScrollEnabled = layout.isScrollEnabled
        scrollView.showsHorizontalScrollIndicator = layout.showsHorizontalScrollIndicator
        return scrollView
    }()
    
    
    @objc public init(frame: CGRect, currentViewController: UIViewController, viewControllers:[UIViewController], titles: [String], layout: LTLayout, titleView: LTPageTitleView? = nil) {
        self.currentViewController = currentViewController
        self.viewControllers = viewControllers
        self.titles = titles
        self.layout = layout
        guard viewControllers.count == titles.count else {
            fatalError("控制器数量和标题数量不一致")
        }
        super.init(frame: frame)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        if titleView != nil {
            isCustomTitleView = true
            self.pageTitleView = titleView!
        }else {
            self.pageTitleView = setupTitleView()
        }
        self.pageTitleView.isCustomTitleView = isCustomTitleView
        setupSubViews()
    }
    
    /* 滚动到某个位置 */
    @objc public func scrollToIndex(index: Int)  {
        pageTitleView.scrollToIndex(index: index)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LTPageView {
    
    private func setupSubViews()  {
        addSubview(scrollView)
        if layout.isSinglePageView == false {
            addSubview(pageTitleView)
            glt_createViewController(0)
            setupGetPageViewScrollView(self, pageTitleView)
        }
    }
    
}

extension LTPageView {
    private func setupTitleView() -> LTPageTitleView {
        let pageTitleView = LTPageTitleView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.layout.sliderHeight), titles: titles, layout: layout)
        pageTitleView.backgroundColor = self.layout.titleViewBgColor
        return pageTitleView
    }
}

extension LTPageView {
    func setupGetPageViewScrollView(_ pageView:LTPageView, _ titleView: LTPageTitleView) {
        pageView.delegate = titleView
        titleView.mainScrollView = pageView.scrollView
        titleView.scrollIndexHandle = pageView.currentIndex
        titleView.glt_createViewControllerHandle = {[weak pageView] index in
            pageView?.glt_createViewController(index)
        }
        titleView.glt_didSelectTitleViewHandle = {[weak pageView] index in
            pageView?.didSelectIndexBlock?((pageView)!, index)
        }
    }
}

extension LTPageView {
    
    public func glt_createViewController(_ index: Int)  {
        let VC = viewControllers[index]
        guard let currentViewController = currentViewController else { return }
        if currentViewController.childViewControllers.contains(VC) {
            return
        }
        var viewControllerY: CGFloat = 0.0
        layout.isSinglePageView ? viewControllerY = 0.0 : (viewControllerY = layout.sliderHeight)
        VC.view.frame = CGRect(x: scrollView.bounds.width * CGFloat(index), y: viewControllerY, width: scrollView.bounds.width, height: scrollView.bounds.height)
        scrollView.addSubview(VC.view)
        currentViewController.addChildViewController(VC)
        VC.automaticallyAdjustsScrollViewInsets = false
        addChildVcBlock?(index, VC)
        if let glt_scrollView = VC.glt_scrollView {
            if #available(iOS 11.0, *) {
                glt_scrollView.contentInsetAdjustmentBehavior = .never
            }
            glt_scrollView.frame.size.height = glt_scrollView.frame.size.height - viewControllerY
        }
    }
    
    public func currentIndex() -> Int {
        if scrollView.bounds.width == 0 || scrollView.bounds.height == 0 {
            return 0
        }
        let index = Int((scrollView.contentOffset.x + scrollView.bounds.width * 0.5) / scrollView.bounds.width)
        return max(0, index)
    }
    
}

extension LTPageView {
    
    private func getRGBWithColor(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("请使用RGB方式给标题颜色赋值")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}

extension UIColor {
    
    public convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}

extension LTPageView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidScroll?(scrollView)
        if isCustomTitleView {
            let index = currentIndex()
            if glt_currentIndex != index {
                glt_createViewController(index)
                didSelectIndexBlock?(self, index)
                glt_currentIndex = index
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


