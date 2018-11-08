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
    //刷新tableView的代理方法
    @objc optional func glt_refreshScrollView(_ scrollView: UIScrollView, _ index: Int);
 }
 
 public class LTSimpleManager: UIView {
    
    /* headerView配置 */
    @objc public func configHeaderView(_ handle: (() -> UIView?)?) {
        guard let handle = handle else { return }
        guard let headerView = handle() else { return }
        setupHeaderView(headerView: headerView)
    }
    
    /* 动态改变header的高度 */
    @objc public var glt_headerHeight: CGFloat = 0.0 {
        didSet {
            kHeaderHeight = CGFloat(Int(glt_headerHeight))
            if layout.isHovered == false {
                hoverY = 0.0
                kHeaderHeight += self.layout.sliderHeight
                titleView.frame.origin.y = kHeaderHeight - layout.sliderHeight
            }
            headerView?.frame.size.height = kHeaderHeight
            tableView.tableHeaderView = headerView
        }
    }
    
    public typealias LTSimpleDidSelectIndexHandle = (Int) -> Void
    @objc public var sampleDidSelectIndexHandle: LTSimpleDidSelectIndexHandle?
    @objc public func didSelectIndexHandle(_ handle: LTSimpleDidSelectIndexHandle?) {
        sampleDidSelectIndexHandle = handle
    }
    
    public typealias LTSimpleRefreshTableViewHandle = (UIScrollView, Int) -> Void
    @objc public var simpleRefreshTableViewHandle: LTSimpleRefreshTableViewHandle?
    @objc public func refreshTableViewHandle(_ handle: LTSimpleRefreshTableViewHandle?) {
        simpleRefreshTableViewHandle = handle
    }
    
    /* 代码设置滚动到第几个位置 */
    @objc public func scrollToIndex(index: Int)  {
        titleView.scrollToIndex(index: index)
    }
    
    /* 点击切换滚动过程动画  */
    @objc public var isClickScrollAnimation = false {
        didSet {
            titleView.isClickScrollAnimation = isClickScrollAnimation
        }
    }
    
    //设置悬停位置Y值
    @objc public var hoverY: CGFloat = 0
    
    /* LTSimple的scrollView上下滑动监听 */
    @objc public weak var delegate: LTSimpleScrollViewDelegate?
    
    private var contentTableView: UIScrollView?
    private var kHeaderHeight: CGFloat = 0.0
    private var headerView: UIView?
    private var viewControllers: [UIViewController]
    private var titles: [String]
    private var layout: LTLayout
    private weak var currentViewController: UIViewController?
    private var pageView: LTPageView!
    private var currentSelectIndex: Int = 0
    var isCustomTitleView: Bool = false
    
    private var titleView: LTPageTitleView!
    
    private lazy var tableView: LTTableView = {
        let tableView = LTTableView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height), style:.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        registerCell(tableView, UITableViewCell.self)
        return tableView
    }()
    
    @objc public init(frame: CGRect, viewControllers: [UIViewController], titles: [String], currentViewController:UIViewController, layout: LTLayout, titleView: LTPageTitleView? = nil) {
        UIScrollView.initializeOnce()
        self.viewControllers = viewControllers
        self.titles = titles
        self.currentViewController = currentViewController
        self.layout = layout
        super.init(frame: frame)
        layout.isSinglePageView = true
        if titleView != nil {
            isCustomTitleView = true
            self.titleView = titleView!
        }else {
            self.titleView = setupTitleView()
        }
        self.titleView.isCustomTitleView = isCustomTitleView
        self.titleView.delegate = self
        pageView = createPageViewConfig(currentViewController: currentViewController, layout: layout, titleView: titleView)
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
    private func setupTitleView() -> LTPageTitleView {
        let titleView = LTPageTitleView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: layout.sliderHeight), titles: titles, layout: layout)
        return titleView
    }
 }
 
 extension LTSimpleManager {
    
    private func createPageViewConfig(currentViewController:UIViewController, layout: LTLayout, titleView: LTPageTitleView?) -> LTPageView {
        let pageView = LTPageView(frame: self.bounds, currentViewController: currentViewController, viewControllers: viewControllers, titles: titles, layout:layout, titleView: titleView)
        if titles.count != 0 {
            pageView.glt_createViewController(0)
        }
        return pageView
    }
 }
 
 extension LTSimpleManager: LTPageViewDelegate {
    
    public func glt_scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tableView.isScrollEnabled = false
    }
    
    public func glt_scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        tableView.isScrollEnabled = true
    }
    
 }
 
 extension LTSimpleManager {
    
    private func createSubViews() {
        backgroundColor = UIColor.white
        addSubview(tableView)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        setupRefreshData()
        pageViewDidSelectConfig()
        guard let viewController = viewControllers.first else { return }
        viewController.beginAppearanceTransition(true, animated: true)
        contentScrollViewScrollConfig(viewController)
        pageView.setupGetPageViewScrollView(pageView, titleView)
    }
    
    private func contentScrollViewScrollConfig(_ viewController: UIViewController) {
        viewController.glt_scrollView?.scrollHandle = {[weak self] scrollView in
            guard let `self` = self else { return }
            self.contentTableView = scrollView
            if self.tableView.contentOffset.y  < self.kHeaderHeight - self.hoverY {
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
                scrollView.showsVerticalScrollIndicator = false
            }else{
                scrollView.showsVerticalScrollIndicator = true
            }
        }
    }
    
 }
 
 extension LTSimpleManager {
    private func setupRefreshData()  {
        DispatchQueue.main.after(0.001) {
            UIView.animate(withDuration: 0.34, animations: {
                self.tableView.contentInset = .zero
            })
            self.simpleRefreshTableViewHandle?(self.tableView, self.currentSelectIndex)
            self.delegate?.glt_refreshScrollView?(self.tableView, self.currentSelectIndex)
        }
        
    }
 }
 
 extension LTSimpleManager {
    private func pageViewDidSelectConfig()  {
        pageView.didSelectIndexBlock = {[weak self] in
            guard let `self` = self else { return }
            self.currentSelectIndex = $1
            self.setupRefreshData()
            self.sampleDidSelectIndexHandle?($1)
        }
        pageView.addChildVcBlock = {[weak self] in
            guard let `self` = self else { return }
            self.contentScrollViewScrollConfig($1)
        }
    }
 }
 
 extension LTSimpleManager: UITableViewDelegate {
    
    /*
     * 0 到 kHeaderHeight - hoverY 之间，滑动的是底部tableView，并且此时要将内容scrollView的contentoffset设置为0
     * 当 大于 kHeaderHeight - hoverY 的时候， 滑动的是内容ScrollView，此时将底部tableView的contentoffset y固定为kHeaderHeight - hoverY
     */
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.glt_scrollViewDidScroll?(scrollView)
        guard scrollView == tableView, let contentTableView = contentTableView else { return }
        let offsetY = scrollView.contentOffset.y
        if contentTableView.contentOffset.y > 0 || offsetY > kHeaderHeight - hoverY {
            tableView.contentOffset = CGPoint(x: 0.0, y: kHeaderHeight - hoverY)
        }
        //滑动期间将其他的内容scrollView contentOffset设置为0
        if scrollView.contentOffset.y < kHeaderHeight - hoverY {
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
        if layout.isHovered {
            pageView.addSubview(titleView)
        }
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
 
 //MARK: HeaderView设置
 extension LTSimpleManager {
    
    private func setupHeaderView(headerView: UIView) {
        //获取headerView的高度
        kHeaderHeight = CGFloat(Int(headerView.bounds.height))
        //判断是否悬停 默认为true开启悬停，如果不开启悬停则需要把hoverY的值设置为0，并重新设置kHeaderHeight，因为布局结构改变（正常情况下titleView是在pageView上，pageView在cell上，如果悬停则titleView放到了headerView上）
        if layout.isHovered == false {
            hoverY = 0.0
            kHeaderHeight += self.layout.sliderHeight
        }
        headerView.frame.size.height = kHeaderHeight
        if self.layout.isHovered == false {
            //此处需要延时一下才有效
            DispatchQueue.main.after(0.0001) {
                //设置titleView的y值
                self.titleView.frame.origin.y = self.kHeaderHeight - self.layout.sliderHeight
                headerView.addSubview(self.titleView)
            }
        }
        self.headerView = headerView
        tableView.tableHeaderView = headerView
    }
    
 }
 
 
