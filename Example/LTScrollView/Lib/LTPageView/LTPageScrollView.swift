//
//  LTPageScrollView.swift
//  LTScrollView_Example
//
//  Created by gaoliutong on 2022/2/16.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

public class LTPageScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    /** 如果LTPageView 与 LTSimple结合使用 需要将它设置为true */
    @objc public var isSimpeMix = false
    
    @objc public var gestureRecognizerEnabledHandle: ((Bool) -> Void)?
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let gestureView = gestureRecognizer.view else { return gestureBeginRet(true) }
       
        guard isSimpeMix else {  return gestureBeginRet(true)  }
        
        guard gestureRecognizer.isKind(of: NSClassFromString("UIScrollViewPanGestureRecognizer")!) else {
            return gestureBeginRet(true)
        }
        
        let velocityX = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: gestureView).x
        
        if velocityX > 0 { // 右滑
            if self.contentOffset.x == 0 {
                return gestureBeginRet(false)
            }
        }else if velocityX < 0 {// 左滑
            if self.contentOffset.x + self.glt_width == self.contentSize.width {
                return gestureBeginRet(false)
            }
        }
        
        return gestureBeginRet(true)
    }
    
    private func gestureBeginRet(_ isEnabled: Bool) -> Bool {
        gestureRecognizerEnabledHandle?(isEnabled)
        return isEnabled
    }
    
}
