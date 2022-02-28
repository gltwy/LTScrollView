//
//  LTTableView.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/14.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit

/// 外界可以继承自LTTableView做一些特殊处理
public class LTTableView: UITableView, UIGestureRecognizerDelegate {
   
    /// 滑动是否是simpleManager（即是headerView）？否则滑动的是cell上的pageView
    private var isScrollSimple = false
    
    /** 如果LTPageView 与 LTSimple结合使用 需要将它设置为true */
    @objc var isSimpeMix = false
    
    /** 是否到了边缘 - 当到了边缘的时候也不能滑动 */
    @objc var isEnabled = true
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (isScrollSimple || !isEnabled) && isSimpeMix {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard isSimpeMix else { return true }
        var touchView = touch.view
        while touchView != nil {
            if let isSimple = touchView?.isKind(of: LTSimpleManager.self), isSimple {
                self.isScrollSimple = true
                return true
            }
            touchView = touchView?.next as? UIView
        }
        self.isScrollSimple = false
        return true
    }
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        isEnabled = true
        return true
    }
}
