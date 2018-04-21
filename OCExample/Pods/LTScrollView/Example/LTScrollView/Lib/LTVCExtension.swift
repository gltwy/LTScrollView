//
//  LTVCExtension.swift
//  LTScrollView
//
//  Created by 高刘通 on 2018/2/3.
//  Copyright © 2018年 LT. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    private struct LTVCKey {
        static var sKey = "glt_scrollViewKey"
        static var oKey = "glt_upOffsetKey"
    }
    
    @objc public var glt_scrollView: UIScrollView? {
        get { return objc_getAssociatedObject(self, &LTVCKey.sKey) as? UIScrollView }
        set { objc_setAssociatedObject(self, &LTVCKey.sKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public var glt_upOffset: String? {
        get { return objc_getAssociatedObject(self, &LTVCKey.oKey) as? String }
        set { objc_setAssociatedObject(self, &LTVCKey.oKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

