//
//  CellStyleable.swift
//  UIDS
//
//  Created by one2much on 2018/1/25.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Then
import SnapKit


// MARK:- 常量
fileprivate struct MetricAble {
    
    static let lineHeight: CGFloat = 0.5    // 细线高度
}

public enum BottomLineStyle : Int {
    case none                   // 无横线
    case full                   // 充满
    case margin                 // 有左边距
}

protocol CellStyleable {
    
}


extension CellStyleable where Self : UITableViewCell {
    
    // MARK:- 横线
    func bottomLine(style: BottomLineStyle) -> UIView {
        
        // 创建组件
        let bottomLine = UIView().then {
            $0.backgroundColor = kThemeLightGreyColor
        }
        
        // 添加组件
        self.addSubview(bottomLine)
        
        // 添加约束
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(MetricAble.lineHeight)
            make.left.equalTo(MetricGlobal.margin * 2)
            make.right.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-MetricAble.lineHeight)
        }
        
        // 调整样式
        switch style {
        case .none:
            bottomLine.isHidden = true
            break
            
        case .margin:
            bottomLine.isHidden = false
            bottomLine.snp.updateConstraints({ (make) in
                make.left.equalTo(MetricGlobal.margin * 2)
            })
            break
            
        case .full:
            bottomLine.isHidden = false
            bottomLine.snp.updateConstraints({ (make) in
                make.left.equalTo(0)
            })
            break
        }
        
        return bottomLine
    }
}


extension CellStyleable where Self : UICollectionViewCell {
    
    // MARK:- 横线
    func topLine(style: BottomLineStyle) -> UIView {
        
        // 创建组件
        let topLine = UIView().then {
            $0.backgroundColor = kThemeLightGreyColor
        }
        
        // 添加组件
        self.addSubview(topLine)
        
        // 添加约束
        topLine.snp.makeConstraints { (make) in
            make.height.equalTo(MetricAble.lineHeight)
            make.left.equalTo(MetricGlobal.margin * 2)
            make.right.equalTo(self)
            make.top.equalTo(self.snp.top).offset(MetricAble.lineHeight)
        }
        
        // 调整样式
        switch style {
        case .none:
            topLine.isHidden = true
            break
            
        case .margin:
            topLine.isHidden = false
            topLine.snp.updateConstraints({ (make) in
                make.left.equalTo(MetricGlobal.margin * 2)
            })
            break
            
        case .full:
            topLine.isHidden = false
            topLine.snp.updateConstraints({ (make) in
                make.left.equalTo(0)
            })
            break
        }
        
        return topLine
    }
    
    // MARK:- 横线
    func bottomLine(style: BottomLineStyle) -> UIView {
        
        // 创建组件
        let bottomLine = UIView().then {
            $0.backgroundColor = kThemeLightGreyColor
        }
        
        // 添加组件
        self.addSubview(bottomLine)
        
        // 添加约束
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(MetricAble.lineHeight)
            make.left.equalTo(MetricGlobal.margin * 2)
            make.right.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-MetricAble.lineHeight)
        }
        
        // 调整样式
        switch style {
        case .none:
            bottomLine.isHidden = true
            break
            
        case .margin:
            bottomLine.isHidden = false
            bottomLine.snp.updateConstraints({ (make) in
                make.left.equalTo(MetricGlobal.margin * 2)
            })
            break
            
        case .full:
            bottomLine.isHidden = false
            bottomLine.snp.updateConstraints({ (make) in
                make.left.equalTo(0)
            })
            break
        }
        
        return bottomLine
    }
}
