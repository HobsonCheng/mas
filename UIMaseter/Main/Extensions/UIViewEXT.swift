//
//  UIViewEXT.swift
//  UIDS
//
//  Created by one2much on 2018/1/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

// MARK: Frame
extension UIView {
    public var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(value) {
            self.frame = CGRect(x: value, y: self.top, width: self.width, height: self.height)
        }
    }
    
    public var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(value) {
            self.frame = CGRect(x: self.left, y: value, width: self.width, height: self.height)
        }
    }
    
    public var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set(value) {
            var frame = self.frame
            frame.origin.x = value - frame.size.width
            self.frame = frame
        }
    }
    
    public var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set(value) {
            var frame = self.frame;
            frame.origin.y = value - frame.size.height;
            self.frame = frame;
        }
    }
    
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: self.left, y: self.top, width: value, height: self.height)
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: self.left, y: self.top, width: self.width, height: value)
        }
    }
    
    public var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center = CGPoint.init(x: value, y: self.center.y)
        }
    }
    
    public var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center = CGPoint.init(x: self.center.x, y: value)
        }
    }
    
    static func loadFromXib_Swift() ->  AnyObject?{
        
        let className =  NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last
        let xibArray = Bundle.main.loadNibNamed(className!, owner: nil, options: nil)
        return xibArray?[0] as AnyObject

    }
    
    
    public func removeAllSubviews() {
        while self.subviews.count != 0 {
            self.subviews.last?.removeFromSuperview()
        }
    }
    
}
// MARK: getOwnerVC
extension UIView{
    /**获取所在的VC*/
    public func getVC() -> UIViewController?{
        var nextResponder: UIResponder? = self
        
        repeat {
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
}
