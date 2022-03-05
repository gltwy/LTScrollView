//
//  LTFollowMoveView.swift
//  LTScrollView_Example
//
//  Created by gaoliutong on 2022/3/5.
//  Copyright © 2022 CocoaPods. All rights reserved.
//  对外提供接口请参考LTFollowMoveViewInterface
//

import UIKit

@objc public protocol LTFollowMoveViewDelegate: NSObjectProtocol {
    
    @objc optional
    /// 即将显示
    func willShow(followView: LTFollowMoveView)
    
    @objc optional
    /// 显示完成
    func showFinished(followView: LTFollowMoveView)
    
    @objc optional
    /// 消失完成
    func dismissFinished(followView: LTFollowMoveView)
}

protocol LTFollowMoveViewInterface {
    
    /// 代理方法
    var delegate: LTFollowMoveViewDelegate? { get set }
    
    /// 弹出、隐藏动画时间 - 需在show(inView:)前赋值有效
    var duration: TimeInterval { get set }
    
    /// 当相对坐标的偏移量大于80的时候（快速滑动），也会消失，默认不消失
    var isQuickPanHide: Bool { get set }
    
    /// 拖动内容视图顶部的空白处，内容视图是否也可以下滑、默认true
    var isCanPanBlank: Bool { get set }
    
    /// 点击内容视图顶部的空白处隐藏 - 默认true
    var isTapHide: Bool { get set }
    
    /// 向下滑动消失的比例，默认为当拉伸到内容视图高度1半的时候消失
    /// 取值范围 [0, 1], 默认0.5
    /// 数值越小，拖动越少就会消失，反之需要拖动更多才会消失
    var stretchRate: CGFloat { get set }
    
    /// 显示
    func show(inView parentView: UIView)
    
    /// 隐藏
    func dismiss()
    
    /// 展示完成闭包回调
    var showFinishedHandle: (() -> Void)? { get set }
    
    /// 消失完成闭包回调
    var dismissFinishedHandle: (() -> Void)? { get set }
}

/// 对外提供接口请参考LTFollowMoveViewInterface
public class LTFollowMoveView: UIView, LTFollowMoveViewInterface {

    private weak var contentView: UIView?
    
    @objc public weak var delegate: LTFollowMoveViewDelegate?
    
    @objc public init(frame: CGRect, contentView: UIView) {
        self.contentView = contentView
        super.init(frame: frame)
        addSubview(contentView)
        addGestureRecognizer(tapGesture)
        addGestureRecognizer(panGesture)
    }
    
    @objc public var duration: TimeInterval = 0.2
    
    @objc public var isQuickPanHide = false
    
    @objc public var isCanPanBlank = true
    
    @objc public var isTapHide = true
    
    @objc public var stretchRate: CGFloat = 0.5
    
    @objc public var willShowHandle: (() -> Void)?

    @objc public var showFinishedHandle: (() -> Void)?
    
    @objc public var dismissFinishedHandle: (() -> Void)?
    
    @objc public func show(inView parentView: UIView) {
        parentView.addSubview(self)
        contentView?.frame.origin.y = frame.size.height
        show()
    }
    
    @objc public func dismiss() {
        _dismiss()
    }
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.delegate = self
        return tapGesture
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        return panGesture
    }()
    
    private var contentScrollView: UIScrollView?
    private lazy var isScrollView = false
    private var contentTop: CGFloat = 0
    private var translationY: CGFloat = 0
    private var isShowCallBack = true
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LTFollowMoveView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self || touch.view == contentView {
            isScrollView = false
            return true
        }
        isScrollView = false
        var touchView = touch.view
        while touchView != nil {
            if touchView?.isKind(of: UIScrollView.self) ?? false {
                isScrollView = true
                contentScrollView = touchView as? UIScrollView
            }
            touchView = touchView?.next as? UIView
        }
        return true
    }
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let contentView = contentView else { return false }
        let point = gestureRecognizer.location(in: contentView)
        if contentView.layer.contains(point) && tapGesture == gestureRecognizer && gestureRecognizer.view == self {
            return false
        }
        if !contentView.layer.contains(point) && panGesture == gestureRecognizer && gestureRecognizer.view == self {
            return isCanPanBlank
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let isScroll = otherGestureRecognizer.view?.isKind(of: UIScrollView.self), isScroll {
            return true
        }
        return false
    }
    
}

extension LTFollowMoveView {
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        guard let contentView = contentView else { return }
        let point = gesture.location(in: self.contentView)
        if !contentView.layer.contains(point) && gesture.view == self && isTapHide {
            dismiss()
        }
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let contentView = contentView else { return }
        let translationY = gesture.translation(in: contentView).y
        if gesture.state == .ended {
            contentScrollView?.isScrollEnabled = true
            if translationY >= contentView.bounds.height * stretchRate && !isScrollView {
                dismiss()
            }else {
                let velocityY = gesture.velocity(in: contentView).y
                if velocityY > 0 && self.translationY > 80 && !isScrollView && isQuickPanHide {
                    dismiss()
                }else {
                    show()
                }
            }
            return
        }
        
        if isScrollView {
            if let contentScrollView = contentScrollView, contentScrollView.contentOffset.y <= 0 && translationY > 0 {
                self.contentScrollView?.contentOffset = .zero
                self.contentScrollView?.isScrollEnabled = false
                isScrollView = false
                self.contentView?.frame.origin.y = contentTop + translationY
            }
        }else {
            if translationY > 0 {
                self.contentView?.frame.origin.y = contentTop + translationY
            }
        }
        self.translationY = translationY
    }
}

extension LTFollowMoveView {
    
    private func show() {
        if self.isShowCallBack {
            self.delegate?.willShow?(followView: self)
            self.willShowHandle?()
        }
        UIView.animate(withDuration: duration) { [weak self] in
            guard let `self` = self, let contentView = self.contentView else { return }
            self.contentView?.frame.origin.y = self.frame.size.height - contentView.frame.size.height
            self.contentTop = contentView.frame.origin.y
        } completion: {[weak self] _ in
            guard let `self` = self else { return }
            if self.isShowCallBack {
                self.delegate?.showFinished?(followView: self)
                self.showFinishedHandle?()
                self.isShowCallBack = false
            }
        }
    }
    
    private func _dismiss() {
        UIView.animate(withDuration: duration) { [weak self] in
            guard let `self` = self else { return }
            self.contentView?.frame.origin.y = self.frame.size.height
        } completion: {[weak self] _ in
            guard let `self` = self else { return }
            self.delegate?.dismissFinished?(followView: self)
            self.dismissFinishedHandle?()
            self.removeFromSuperview()
        }
    }
}
