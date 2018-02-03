//
//  LTVCExtension.swift
//  LTScrollView
//
//  Created by 高刘通 on 2018/2/3.
//  Copyright © 2018年 LT. All rights reserved.
//

import Foundation

extension UIViewController {
    private struct LTScrollViewKey {
        static var key = "glt_scrollViewKey"
    }
    public var glt_scrollView: UIScrollView? {
        get {
            return objc_getAssociatedObject(self, &LTScrollViewKey.key) as? UIScrollView
        }
        set {
            objc_setAssociatedObject(self, &LTScrollViewKey.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
