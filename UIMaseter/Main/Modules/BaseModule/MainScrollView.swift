//
//  MainScrollView.swift
//  UIDS
//
//  Created by one2much on 2018/1/12.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MainScrollView: UIScrollView {

    
    open var showEmpty: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.showEmpty = false
        self.emptyDataSetDelegate = self
        self.emptyDataSetSource = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension MainScrollView: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if !self.showEmpty! {
            return nil
        }
        
        let text = "温馨提示";
        let font = UIFont.systemFont(ofSize: 26)
        let textColor = UIColor.init(hexString: "444444")
        
        let attributes = NSMutableDictionary()
        
        attributes.setObject(textColor, forKey: NSAttributedStringKey.foregroundColor as NSCopying)
        attributes.setObject(font, forKey: NSAttributedStringKey.font as NSCopying)
        
        return NSAttributedString.init(string: text, attributes: attributes as? [NSAttributedStringKey : Any])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        if !self.showEmpty! {
            return nil
        }
        
        let text = "目前数据很干净，或许你需要来点内容，占个沙发休息一下...☕️"
        let textColor = UIColor.init(hexString: "444444")
        let attributes = NSMutableDictionary()
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraph.alignment = NSTextAlignment.center
        paragraph.lineSpacing = 2.0
        
        attributes.setObject(textColor, forKey: NSAttributedStringKey.foregroundColor as NSCopying)
        attributes.setObject(paragraph, forKey: NSAttributedStringKey.paragraphStyle as NSCopying)
        
        
        return NSMutableAttributedString.init(string: text, attributes: attributes as? [NSAttributedStringKey : Any])
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if !self.showEmpty! {
            return nil
        }
        
        return UIImage.init(named: "placeholder_instagram.png")
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        
        
        return nil
        
//        let animation = CABasicAnimation.init(keyPath: "transform")
//        animation.fromValue = NSValue.init(caTransform3D: CATransform3DIdentity)
//        animation.toValue = NSValue.init(caTransform3D: CATransform3DMakeRotation(CGFloat(Double.pi/2), 0.0, 0.0, 1))
//        animation.duration = 0.25
//        animation.isCumulative = true
//        animation.repeatCount = MAXFLOAT;
//        
//        return animation;
        
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        if !self.showEmpty! {
            return nil
        }
        
        let text = ""
        let textColor = UIColor.init(hexString: "444444")
        let attributes = NSMutableDictionary()
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraph.alignment = NSTextAlignment.center
        paragraph.lineSpacing = 2.0
        
        attributes.setObject(textColor, forKey: NSAttributedStringKey.foregroundColor as NSCopying)
        attributes.setObject(paragraph, forKey: NSAttributedStringKey.paragraphStyle as NSCopying)
        
        
        return NSMutableAttributedString.init(string: text, attributes: attributes as? [NSAttributedStringKey : Any])
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        if !self.showEmpty! {
            return nil
        }
        
        return UIColor.white
        
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        
        return 24.0
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        
    }
    
}
