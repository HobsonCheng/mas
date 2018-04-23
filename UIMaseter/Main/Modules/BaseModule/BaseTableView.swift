//
//  BaseTableView.swift
//  UIDS
//
//  Created by one2much on 2018/1/26.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import DZNEmptyDataSet


class BaseTableView: UITableView {

    open func config() {
        
        self.emptyDataSetSource = self
        self.emptyDataSetDelegate = self
        
    }

}



extension BaseTableView: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "暂无数据...😶"
        let font = UIFont.systemFont(ofSize: 26)
        let textColor = UIColor.init(hexString: "444444")
        let attributes = NSMutableDictionary()
        
        attributes.setObject(textColor, forKey: NSAttributedStringKey.foregroundColor as NSCopying)
        attributes.setObject(font, forKey: NSAttributedStringKey.font as NSCopying)
        
        return NSAttributedString.init(string: text, attributes: attributes  as? [NSAttributedStringKey : Any])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
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
        
        return UIImage.init(named: "empty_placeholder.png")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        return nil
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 0
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
}
