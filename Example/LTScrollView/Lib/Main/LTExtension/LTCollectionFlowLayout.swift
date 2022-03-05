//
//  LTCollectionFlowLayout.swift
//  LTScrollView_Example
//
//  Created by 高刘通 on 2018/7/30.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    
    private struct LTCollectionViewHandleKey {
        static var key = "glt_collectionViewContentSizeHandle"
    }
    
    public static var glt_sliderHeight: CGFloat? {
        get { return objc_getAssociatedObject(self, &LTCollectionViewHandleKey.key) as? CGFloat }
        set { objc_setAssociatedObject(self, &LTCollectionViewHandleKey.key, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    public class func loadOnce() {
        DispatchQueue.once(token: "LTFlowLayout") {
            let originSelector = #selector(getter: UICollectionViewLayout.collectionViewContentSize)
            let swizzleSelector = #selector(UICollectionViewFlowLayout.glt_collectionViewContentSize)
            glt_swizzleMethod(self, originSelector, swizzleSelector)
        }
    }
    
    @objc dynamic func glt_collectionViewContentSize() -> CGSize {
        
        let contentSize = self.glt_collectionViewContentSize()
        
        guard let collectionView = collectionView else { return contentSize }
        
        guard let glt_sliderHeight = UICollectionViewFlowLayout.glt_sliderHeight, glt_sliderHeight > 0 else { return contentSize }
        
        let collectionViewH = collectionView.bounds.height - glt_sliderHeight
        
        return contentSize.height < collectionViewH ? CGSize(width: contentSize.width, height: collectionViewH) : contentSize
    }
}
