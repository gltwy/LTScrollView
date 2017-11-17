//
//  LTHeaderView.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/17.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit

class LTHeaderView: UIView {

    var scrollView: UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 50, width: 100, height: 50)
        addSubview(button)
        button.backgroundColor = UIColor.blue
    }
    
    @objc func buttonClick()  {
        print("buttonClick")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let r = super.hitTest(point, with: event)
        guard let returnView = r  else {
            return r
        }
        guard let returnViewSuperView = returnView.superview else {
            return r
        }
        
        
        for tempView in returnViewSuperView.subviews {
            if tempView.isKind(of: LTPageView.self) {
                for scrollView in tempView.subviews {
                    if scrollView.isKind(of: UIScrollView.self) {
                        return self.scrollView
                    }else{
                        return r
                    }
                }
                return r
            }else{
                return r
            }
        }
        return r
    }
 
    
  
}
