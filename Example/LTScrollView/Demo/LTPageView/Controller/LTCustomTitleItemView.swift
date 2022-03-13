//
//  LTCustomTitleItemView.swift
//  LTScrollView_Example
//
//  Created by gaoliutong on 2022/3/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class LTCustomTitleItemView: UIButton, LTPageTitleItemType {
    
    var glt_index: Int = 0
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "test")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var badgeView: UIView = {
        let badgeView = UIView()
        badgeView.backgroundColor = .red
        return badgeView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        insertSubview(backgroundImageView, at: 0)
        addSubview(badgeView)
    }
    
    ///MARK: 协议方法
    func glt_layoutSubviews() {
        backgroundImageView.frame = bounds
        addCornerLayer()
    }
    
    ///MARK: 协议方法
    func glt_setSelected(_ isSelected: Bool) {
        
        print("index = \(glt_index)")
        
        /// 修改背景颜色使用示例
        if glt_index % 2 == 0 {
            backgroundColor = isSelected ? .orange : .blue
        }else {
            backgroundColor = isSelected ? .green : .yellow
        }
        
        /// 设置背景图使用示例
        backgroundImageView.isHidden = glt_index != 0
        
        ///选中1的时候隐藏使用示例
        badgeView.isHidden = glt_index != 1 || isSelected;
        
        /// 设置富文本使用示例
        testFullText()
        
        ///设置标题偏移使用示例
        if glt_index == 3 {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LTCustomTitleItemView {
    
    private func testFullText() {
        guard glt_index == 2 else { return }
        let itemTitle = titleLabel?.text ?? ""
        let attr = NSMutableAttributedString(string: itemTitle)
        attr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10)], range: (itemTitle as NSString).range(of: "我是"))
        attr.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.randomColor], range: (itemTitle as NSString).range(of: "富文本"))
        titleLabel?.attributedText = attr
    }
    
    private func addCornerLayer() {
        guard glt_index == 1 else { return }
        badgeView.frame = CGRect(x: glt_width - 15, y: 5, width: 10, height: 10)
        let maskPath = UIBezierPath(roundedRect: badgeView.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 5, height: 5))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = badgeView.bounds
        maskLayer.path = maskPath.cgPath
        badgeView.layer.mask = maskLayer
    }
}
