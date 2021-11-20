//
//  UIView+LTExtension.swift
//  LTScrollView_Example
//
//  Created by 高刘通 on 2020/8/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

extension UIView {
    
    public var glt_left:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newLeft) {
            var frame = self.frame
            frame.origin.x = newLeft
            self.frame = frame
        }
    }
    
    public var glt_top:CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(newTop) {
            var frame = self.frame
            frame.origin.y = newTop
            self.frame = frame
        }
    }
    
    public var glt_width:CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    public var glt_height:CGFloat {
        get {
            return self.frame.size.height
        }
        
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    public var glt_right:CGFloat {
        get {
            return self.glt_left + self.glt_width
        }
        set (newRight) {
            var frame = self.frame
            frame.origin.x = newRight-self.glt_width
            self.frame = frame
        }
    }
    
    public var glt_bottom:CGFloat {
        get {
            return self.glt_top + self.glt_height
        }
        set(newBottom){
            var frame = self.frame
            frame.origin.y = newBottom-self.glt_height
            self.frame = frame
        }
    }
    
    public var glt_centerX:CGFloat {
        get {
            return self.center.x
        }
        
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }
    
    public var glt_centerY:CGFloat {
        get {
            return self.center.y
        }
        
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }
    
    public var glt_size:CGSize {
        get {
            return self.bounds.size
        }
        set(newSize){
            var frame = self.frame
            frame.size = newSize
            self.frame = frame
        }
    }
}

extension UIColor {
    
    public convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    //返回随机颜色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}
