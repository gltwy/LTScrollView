//
//  LTScrollExtension.swift
//  LTScrollView
//
//  Created by 高刘通 on 2018/2/3.
//  Copyright © 2018年 LT. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    public typealias LTScrollHandle = (UIScrollView) -> Void
    
    private struct LTHandleKey {
        static var key = "glt_handle"
    }
    
    public var scrollHandle: LTScrollHandle? {
        get { return objc_getAssociatedObject(self, &LTHandleKey.key) as? LTScrollHandle }
        set { objc_setAssociatedObject(self, &LTHandleKey.key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
}

extension UIScrollView {
    
    public class func initializeOnce() {
        DispatchQueue.once(token: UIDevice.current.identifierForVendor?.uuidString ?? "LTScrollView") {
            let originSelector = Selector(("_notifyDidScroll"))
            let swizzleSelector = #selector(glt_scrollViewDidScroll)
            glt_swizzleMethod(self, originSelector, swizzleSelector)
        }
    }
    
    @objc dynamic func glt_scrollViewDidScroll() {
        self.glt_scrollViewDidScroll()
        guard let scrollHandle = scrollHandle else { return }
        scrollHandle(self)
    }
}

extension NSObject {
    
    internal static func glt_swizzleMethod(_ cls: AnyClass?, _ originSelector: Selector, _ swizzleSelector: Selector)  {
        let originMethod = class_getInstanceMethod(cls, originSelector)
        let swizzleMethod = class_getInstanceMethod(cls, swizzleSelector)
        guard let swMethod = swizzleMethod, let oMethod = originMethod else { return }
        let didAddSuccess: Bool = class_addMethod(cls, originSelector, method_getImplementation(swMethod), method_getTypeEncoding(swMethod))
        if didAddSuccess {
            class_replaceMethod(cls, swizzleSelector, method_getImplementation(oMethod), method_getTypeEncoding(oMethod))
        } else {
            method_exchangeImplementations(oMethod, swMethod)
        }
    }
}




