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

//MARK: LTPageView相关的接口见此处
@objc protocol LTPageViewHeaders {
    
    //MARK: 构造方法
    @objc init(frame: CGRect, currentViewController: UIViewController, viewControllers:[UIViewController], titles: [String], layout: LTLayout)
    
    //MARK: 选中了第几个位置
    @objc var didSelectIndexBlock: PageViewDidSelectIndexBlock? { get }
    
    //MARK: 添加完子控制器回调
    @objc var addChildVcBlock: AddChildViewControllerBlock? { get }
    
    //MARK: 点击切换滚动过程动画
    @objc var isClickScrollAnimation: Bool { get }
    
    //MARK: pageView代理
    @objc weak var delegate: LTPageViewDelegate? { get }
    
    //MARK: 自定义子view
    @objc func customLayoutItems(handle: (([LTPageTitleItemView], LTPageView) -> Void)?)
}

public class LTPageView: UIView, LTPageViewHeaders {
    
    //当前的控制器
    private weak var currentViewController: UIViewController?
    
    //控制器数组
    private var viewControllers: [UIViewController]
    
    //标题数组
    private var titles: [String]
    
    //设置默认布局，具体设置请查看LTLayout类
    private var layout: LTLayout
    
    //当前选中的位置
    private var glt_currentIndex: Int = 0;
    
    //选中了第几个位置
    @objc public var didSelectIndexBlock: PageViewDidSelectIndexBlock?
    
    //添加完子控制器回调
    @objc public var addChildVcBlock: AddChildViewControllerBlock?
    
    // 点击切换滚动过程动画
    @objc public var isClickScrollAnimation = false {
        didSet {
            titleView.isClickScrollAnimation = isClickScrollAnimation
        }
    }
    
    //pageView的scrollView左右滑动监听
    @objc public weak var delegate: LTPageViewDelegate?
    
    //自定义子view
    func customLayoutItems(handle: (([LTPageTitleItemView], LTPageView) -> Void)?) {
        handle?(titleView.allItemViews(), self)
    }
    
    private lazy var titleView: LTPageTitleView = {
        let titleView = LTPageTitleView(frame: CGRect(x: 0, y: 0, width: glt_width, height: layout.sliderHeight), titles: titles, layout: layout)
        titleView.backgroundColor = layout.titleViewBgColor
        return titleView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: glt_width, height: glt_height))
        scrollView.contentSize = CGSize(width: glt_width * CGFloat(self.titles.count), height: 0)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = layout.isShowBounces
        scrollView.isScrollEnabled = layout.isScrollEnabled
        scrollView.showsHorizontalScrollIndicator = layout.showsHorizontalScrollIndicator
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    @objc required public init(frame: CGRect, currentViewController: UIViewController, viewControllers:[UIViewController], titles: [String], layout: LTLayout) {
        self.currentViewController = currentViewController
        self.viewControllers = viewControllers
        self.titles = titles
        self.layout = layout
        guard viewControllers.count == titles.count else {
            fatalError("控制器数量和标题数量不一致")
        }
        super.init(frame: frame)
        
        self.addSubview(self.scrollView)
        
        guard !layout.isSinglePageView else { return }
        
        addSubview(self.titleView)
        
        glt_createViewController(0)
        
        _makeupPageView(self.titleView)
    }
    
    /* 滚动到某个位置 */
    @objc public func scrollToIndex(index: Int)  {
        titleView.scrollToIndex(index: index)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LTPageView {
    
    final func _makeupPageView(_ titleView: LTPageTitleView) {
        
        //设置滑动view的代理为LTPageTitleView
        self.delegate = titleView
        
        //将当前的scrollView传递给titleView
        titleView.mainScrollView = scrollView
        
        //当titleView的选中位置传递给scrollView
        titleView.scrollIndexHandle = {[weak self] in
            guard let `self` = self else { return 0 }
            return self.currentIndex()
        }
        
        //通过pageView创建自子控制器
        titleView.glt_createViewControllerHandle = {[weak self] index in
            self?.glt_createViewController(index)
        }
        
        //选中某个位置的回调
        titleView.glt_didSelectTitleViewHandle = {[weak self] index in
            guard let `self` = self else { return }
            self.didSelectIndexBlock?(self, index)
        }
    }
    
    final func makeupPageView(_ pageView:LTPageView, _ titleView: LTPageTitleView) {
        //设置滑动view的代理为LTPageTitleView
        pageView.delegate = titleView
        titleView.mainScrollView = pageView.scrollView
        titleView.scrollIndexHandle = {[weak pageView] in
            return pageView?.currentIndex() ?? 0
        }
        titleView.glt_createViewControllerHandle = {[weak pageView] index in
            pageView?.glt_createViewController(index)
        }
        titleView.glt_didSelectTitleViewHandle = {[weak pageView] index in
            pageView?.didSelectIndexBlock?((pageView)!, index)
        }
    }
}

extension LTPageView {
    
    //仅内部调用创建控制器
    final func glt_createViewController(_ index: Int)  {
        
        //如果当前控制器不存在直接return
        guard let currentViewController = currentViewController else { return }
        
        let viewController = viewControllers[index]
        
        //判断是否包含当前控制器，如果包含无需要再次创建
        guard !currentViewController.children.contains(viewController) else { return }
        
        //设置viewController的frame
        let X = scrollView.glt_width * CGFloat(index)
        let Y = layout.isSinglePageView ? 0 : layout.sliderHeight
        let W = scrollView.glt_width
        let H = scrollView.glt_height
        viewController.view.frame = CGRect(x: X, y: Y, width: W, height: H)
        
        //将控制器的view添加到scrollView上
        scrollView.addSubview(viewController.view)
        
        //将控制器作为当前控制器的子控制器
        currentViewController.addChild(viewController)
                
        //抛出回调给外界
        addChildVcBlock?(index, viewController)
        
        guard let glt_scrollView = viewController.glt_scrollView else { return }
        
        if #available(iOS 11.0, *) {
            glt_scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            viewController.automaticallyAdjustsScrollViewInsets = false
        }
        //修正外部scrollView的高
        glt_scrollView.glt_height = glt_scrollView.glt_height - Y
    }
    
    //获取当前位置
    private func currentIndex() -> Int {
        if scrollView.bounds.width == 0 || scrollView.bounds.height == 0 {
            return 0
        }
        let index = Int((scrollView.contentOffset.x + scrollView.bounds.width * 0.5) / scrollView.bounds.width)
        return max(0, index)
    }
}

//MARK: 提供给外界监听的方法
extension LTPageView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidScroll?(scrollView)
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


