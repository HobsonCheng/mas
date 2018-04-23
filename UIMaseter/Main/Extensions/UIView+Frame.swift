//
//  UIView+Frame.swift
//  UIMaseter
//
//  Created by gongcz on 2018/4/17.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

extension UIView {
    // 设置UIView的X
    
    func setViewX(_ newX: CGFloat) {
        var viewFrame: CGRect = self.frame
        viewFrame.origin.x = newX
        frame = viewFrame
    }
    
    // 设置UIView的Y
    func setViewY(_ newY: CGFloat) {
        var viewFrame: CGRect = self.frame
        viewFrame.origin.y = newY
        frame = viewFrame
    }
    
    // 设置UIView的Origin
    func setViewOrigin(_ newOrigin: CGPoint) {
        var viewFrame: CGRect = self.frame
        viewFrame.origin = newOrigin
        frame = viewFrame
    }
    
    // 设置UIView的width
    func setViewWidth(_ newWidth: CGFloat) {
        var viewFrame: CGRect = self.frame
        viewFrame.size.width = newWidth
        frame = viewFrame
    }
    
    // 设置UIView的height
    func setViewHeight(_ newHeight: CGFloat) {
        var viewFrame: CGRect = self.frame
        viewFrame.size.height = newHeight
        frame = viewFrame
    }
    
    // 设置UIView的Size
    func setViewSize(_ newSize: CGSize) {
        var viewFrame: CGRect = self.frame
        viewFrame.size = newSize
        frame = viewFrame
    }
    
    /*!
     *  获取
     */
    class func  loadFromXib() -> AnyObject {
        let className = "\(self)"
        let xibArray = Bundle.main.loadNibNamed(className, owner: nil, options: nil)
        return xibArray?[0] as AnyObject
    }
    
    class func loadFromXib(_ index: Int) -> AnyObject {
        let className = "\(self)"
        let xibArray = Bundle.main.loadNibNamed(className, owner: nil, options: nil)
        if index < (xibArray?.count ?? 0) {
            return xibArray?[index] as AnyObject
        }
        return xibArray?[0] as AnyObject
    }

}
