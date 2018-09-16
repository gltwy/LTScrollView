//
//  LTCustomTitleView.swift
//  LTScrollView_Example
//
//  Created by 高刘通 on 2018/9/7.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class LTCustomTitleView: LTPageTitleView {
    
    override init(frame: CGRect, titles: [String], layout: LTLayout) {
        super.init(frame: frame, titles: titles, layout: layout)
        backgroundColor = UIColor.yellow
        customViewTest()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func glt_contentScrollViewDidScroll(_ scrollView: UIScrollView) {
        print("自定义headerView -- ", scrollView.contentOffset.x)
    }
    
    override func glt_contentScrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    override func glt_contentScrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    override func glt_contentScrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    override func glt_contentScrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    override func glt_contentScrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
}


extension LTCustomTitleView {
    
    func customViewTest()  {
        //此处写布局
        print("自定义headerView， 此处写布局")
    }
    
}
