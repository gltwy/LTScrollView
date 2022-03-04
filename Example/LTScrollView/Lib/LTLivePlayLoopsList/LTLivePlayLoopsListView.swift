//
//  LTLivePlayLoopsListView.swift
//  LTScrollView_Example
//
//  Created by gaoliutong on 2022/3/3.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

@objc public protocol LTLivePlayLoopsListDelegate: UIScrollViewDelegate {
    
    /// 当前选中的view
    func didSelect(livePlayView: LTLivePlayLoopsListView, inView: UIView, index: Int)
    
    /// 预加载view
    func prefetch(livePlayView: LTLivePlayLoopsListView, inView: UIView, index: Int)
    
    @objc optional
    /// 在此处可以手动控制具体情况下是否可以滑动
    /// - Returns: true可以滑动；false不可以滑动
    func checkCanScroll() -> Bool
}

@objc public protocol LTLivePlayLoopsListDataSource: NSObjectProtocol {
    
    func numberofItems(livePlayView: LTLivePlayLoopsListView) -> Int
}

public protocol LTLivePlayLoopsListInterface {
    
    /// 设置数据源
    var dataSource: LTLivePlayLoopsListDataSource? { get set }
    
    /// 设置代理 - 对应LTLivePlayLoopsListDelegate
    var delegate: UIScrollViewDelegate? { get set }
    
    /// 当reload的时候首次选中第几个位置，通常在reloadData前设置该属性，默认选中当前的位置
    var currentIndex: Int { get set }
    
    /// 是否开启无限轮博 默认开启
    var isCanLoops: Bool { get set }
    
    /// 更新数据源后需要调用reloadData
    func reloadData()
    
    /// 滚动到第几个位置, 调用此方法前确认已经调用reloadData
    func scrollTo(index: Int)
}


/// 对外提供接口请参考LTLivePlayLoopsListInterface
public class LTLivePlayLoopsListView: UIScrollView, LTLivePlayLoopsListInterface {
    
    @objc public var isCanLoops = true
    
    @objc public var currentIndex = 0
    
    @objc public weak var dataSource: LTLivePlayLoopsListDataSource?
    
    @objc override weak public var delegate: UIScrollViewDelegate? {
        didSet {
            myDelegate = delegate as? LTLivePlayLoopsListDelegate
        }
    }
    
    @objc public init(frame: CGRect, content: UIView.Type) {
        self.topView = content.init()
        self.currentView = content.init()
        self.bottomView = content.init()
        super.init(frame: frame)
        itemW = frame.width
        itemH = frame.height
        glt_setupSystem()
        glt_setupSubViews()
    }
    
    @objc public func scrollTo(index: Int) {
        _scrollTo(index: index)
    }
    
    @objc public func reloadData() {
        _reloadData()
    }
    
    private lazy var itemW: CGFloat = 0
    private lazy var itemH: CGFloat = 0
    private lazy var totalCount = 0
    private var isNeedCheck = false
    private var topView: UIView
    private var currentView: UIView
    private var bottomView: UIView
    private weak var myDelegate: LTLivePlayLoopsListDelegate?

    public override var contentOffset: CGPoint {
        set {
            if newValue.equalTo(self.contentOffset) {
                return
            }
            
            if let func_checkCanScroll = myDelegate?.checkCanScroll {
                let canScroll = func_checkCanScroll()
                guard canScroll else { return }
            }
            
            if !isCanLoops && isNeedCheck {
                if (currentIndex == totalCount - 1 && newValue.y > itemH) || currentIndex == 0 && newValue.y < itemH {
                    return
                }
            }
            
            super.contentOffset = newValue
            
            if newValue.y >= 2 * itemH {
                isScrollEnabled = false
                (currentView, bottomView, topView) = (bottomView, topView, currentView)
                didShow(index: currentIndex + 1)
                prefetchingNextView()
                reset()
                isScrollEnabled = true
            }else if (newValue.y <= 0) {
                isScrollEnabled = false
                (currentView, topView, bottomView) = (topView, bottomView, currentView)
                didShow(index: currentIndex - 1)
                prefetchingTopView()
                reset()
                isScrollEnabled = true
            }
        }
        get { super.contentOffset }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LTLivePlayLoopsListView {
    
    private func glt_setupSystem() {
        scrollsToTop = false
        contentSize = CGSize(width: itemW, height: itemH * 3.0)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = true
        isPagingEnabled = true
        bounces = false
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func glt_setupSubViews() {
        addSubview(topView)
        addSubview(currentView)
        addSubview(bottomView)
        reset()
    }
    
    private func reset() {
        isNeedCheck = false
        super.contentOffset = CGPoint(x: 0, y: itemH)
        isNeedCheck = true
        topView.frame = CGRect(x: 0, y: 0, width: itemW, height: itemH)
        currentView.frame = CGRect(x: 0, y: itemH, width: itemW, height: itemH)
        bottomView.frame = CGRect(x: 0, y: itemH * 2, width: itemW, height: itemH)
    }
    
    private func didShow(index: Int) {
        currentIndex = cycleIndex(index: index)
        if currentIndex >= totalCount || currentIndex < 0 {
            return
        }
        myDelegate?.didSelect(livePlayView: self, inView: currentView, index: currentIndex)
    }
    
    private func cycleIndex(index: Int) -> Int {
        if !isCanLoops {
            return index
        }
        if index < 0 {
            return totalCount - 1
        }else if index >= totalCount {
            return 0
        }
        return index
    }
    
    private func prefetchingShow(view: UIView, index: Int) {
        let newIndex = cycleIndex(index: index)
        if newIndex >= totalCount || newIndex < 0 {
            return
        }
        myDelegate?.prefetch(livePlayView: self, inView: view, index: newIndex)
    }
    
    private func prefetchingNextView() {
        prefetchingShow(view: bottomView, index: currentIndex + 1)
    }
    
    private func prefetchingTopView() {
        prefetchingShow(view: topView, index: currentIndex - 1)
    }
    
    private func _scrollTo(index: Int) {
        if index >= totalCount {
            return
        }
        prefetchingShow(view: currentView, index: index)
        didShow(index: index)
        if totalCount <= 1 {
            isScrollEnabled = false
            return
        }
        prefetchingNextView()
        prefetchingTopView()
    }
    
    private func _reloadData() {
        if let count = dataSource?.numberofItems(livePlayView: self) {
            totalCount = count
            scrollTo(index: currentIndex)
        }
    }
}
