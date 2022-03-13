//
//  LTPageTitleItemView.swift
//  LTScrollView_Example
//
//  Created by 高刘通 on 2020/8/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

fileprivate enum LTAssociatedKeys {
    static var glt_isSelected = "glt_isSelected"
}
 
@objc public protocol LTPageTitleItemType where Self: UIButton {

    /// 当前选中、取消选中的索引
    @objc var glt_index: Int { get set }
    
    /// 可选实现 - 首次设置frame以后，frame的值, 此方法仅会调用一次
    /// layoutSubviews中的frame会跟随放大效果改变，故此方法为初次设置后的frame
    @objc optional
    func glt_layoutSubviews()
    
    /// 可选实现 - 可在此方法内部进行未选中后的一些处理
    @objc optional
    func glt_unselected()
    
    /// 可选实现 - 可在此方法内部进行选中后的一些处理
    @objc optional
    func glt_selected()
    
    /// 可选实现 - 合并成一个方法，进行选中和未选中的处理
    @objc optional
    func glt_setSelected(_ isSelected: Bool)
}

public extension LTPageTitleItemType {
    
    /// 当前选中以及取消选中
    var glt_isSelected: Bool {
        get {
            return objc_getAssociatedObject(self, &LTAssociatedKeys.glt_isSelected) as? Bool ?? false
        }
        set {
            let _isSelected = newValue
            objc_setAssociatedObject(self, &LTAssociatedKeys.glt_isSelected, _isSelected, .OBJC_ASSOCIATION_ASSIGN)
            _isSelected ? glt_selected?() : glt_unselected?()
            glt_setSelected?(_isSelected)
        }
    }
}
