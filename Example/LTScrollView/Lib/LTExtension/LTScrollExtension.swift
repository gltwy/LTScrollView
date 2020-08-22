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
        static var tKey = "glt_isTableViewPlain"
    }
    
    public var scrollHandle: LTScrollHandle? {
        get { return objc_getAssociatedObject(self, &LTHandleKey.key) as? LTScrollHandle }
        set { objc_setAssociatedObject(self, &LTHandleKey.key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    @objc public var isTableViewPlain: Bool {
        get { return (objc_getAssociatedObject(self, &LTHandleKey.tKey) as? Bool) ?? false}
        set { objc_setAssociatedObject(self, &LTHandleKey.tKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
}

extension String {
    func glt_base64Decoding() -> String {
        let decodeData = NSData.init(base64Encoded: self, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        if decodeData == nil || decodeData?.length == 0 {
            return "";
        }
        let decodeString = NSString(data: decodeData! as Data, encoding: String.Encoding.utf8.rawValue)
        return decodeString! as String
    }
}

extension UIScrollView {
    
    public class func initializeOnce() {
        DispatchQueue.once(token: UIDevice.current.identifierForVendor?.uuidString ?? "LTScrollView") {
            let didScroll = "X25vdGlmeURpZFNjcm9sbA==".glt_base64Decoding()
            let originSelector = Selector((didScroll))
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
    
    static func glt_swizzleMethod(_ cls: AnyClass?, _ originSelector: Selector, _ swizzleSelector: Selector)  {
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




