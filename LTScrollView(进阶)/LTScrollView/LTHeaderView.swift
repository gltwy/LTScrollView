//
//  LTHeaderView.swift
//  LTScrollView
//
//  Created by 高刘通 on 2017/11/17.
//  Copyright © 2017年 LT. All rights reserved.
//

import UIKit

class LTHeaderView: UIView {

    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 50, width: 100, height: 50)
        button.backgroundColor = UIColor.blue
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
    }
    
    @objc func buttonClick()  {
        print("buttonClick")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for tempView in self.subviews {
            if tempView.isKind(of: UIButton.self) {
                let button = tempView as! UIButton
                let newPoint = self.convert(point, to: button)
                if button.bounds.contains(newPoint) {
                    return true
                }
            }
        }
        return false
    }
}
