//
//  SettingCell.swift
//  UIDS
//
//  Created by one2much on 2018/1/25.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Then
import SnapKit

// MARK:- 常量
fileprivate struct MetricCell {
    
    static let titleFontSize: CGFloat = 15.0
    static let descFontSize: CGFloat = 13.0
    static let lineHeight: CGFloat = 0.5
}

class SettingCell: UITableViewCell {

    // 下划线
    fileprivate var bottomLine: UIView?
    
    // 正常
    fileprivate var leftIcon: UIImageView?
    fileprivate var titleLab: UILabel?
    fileprivate var descriptionLab: UILabel?
    fileprivate var rightIcon: UIImageView?
    fileprivate var dotIcon: UIImageView?
    
    // 右侧
    fileprivate var rightRecordButton: UIButton?
    fileprivate var centerVerticalLine: UIView?
    
    // 右侧开关
    fileprivate var rightSwitch: UISwitch?
    
    // 右侧文本
    fileprivate var rightTextLab: UILabel?
    
    fileprivate var outBtton: UIButton?
    
    
    var model: SettingCellModel? { didSet { setModel() } }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initCellUI()
        initEnableMudule()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SettingCell {
    
    // MARK:- 自定义组件
    func initCellUI() {
        
        // 创建组件
        let view = UIView().then {
            $0.backgroundColor = .white
        }
        let leftIcon = UIImageView().then {
            $0.contentMode = .scaleAspectFit
        }
        let titleLab = UILabel().then {
            $0.textColor = kThemeBlackColor
            $0.font = UIFont.systemFont(ofSize: MetricCell.titleFontSize)
        }
        let descriptionLab = UILabel().then {
            $0.textColor = kThemeOrangeRedColor
            $0.font = UIFont.systemFont(ofSize: MetricCell.descFontSize)
        }
        let rightIcon = UIImageView().then {
            $0.contentMode = .scaleAspectFit
        }
        let dotIcon = UIImageView().then {
            $0.contentMode = .scaleAspectFit
        }
        
        // 录音
        let centerVerticalLine = UIView().then {
            $0.backgroundColor = kThemeLightGreyColor
        }
        let rightRecordButton = UIButton().then {
            $0.contentMode = .scaleAspectFit
        }
        
        // 开关
        let rightSwitch = UISwitch().then {
            $0.isOn = false
        }
        
        // 文本
        let rightTextLab = UILabel().then {
            $0.textColor = kThemeLightGreyColor
            $0.font = UIFont.systemFont(ofSize: MetricCell.descFontSize)
        }

        let outBtton = UIButton().then {
            $0.setTitleColor(UIColor.white, for: UIControlState.normal)
            $0.layer.cornerRadius = 6
            $0.layer.masksToBounds = true
            $0.isUserInteractionEnabled = false
        }
        
        
        // 添加组件
        view.addSubview(leftIcon)
        view.addSubview(titleLab)
        view.addSubview(descriptionLab)
        view.addSubview(rightIcon)
        view.addSubview(dotIcon)
        
        view.addSubview(centerVerticalLine)
        view.addSubview(rightRecordButton)
        view.addSubview(rightSwitch)
        view.addSubview(rightTextLab)
        view.addSubview(outBtton)
        
        
        self.addSubview(view)
        
        // 赋值
        self.leftIcon = leftIcon
        self.titleLab = titleLab
        self.descriptionLab = descriptionLab
        self.rightIcon = rightIcon
        self.dotIcon = dotIcon
        
        self.centerVerticalLine = centerVerticalLine
        self.rightRecordButton = rightRecordButton
        self.rightSwitch = rightSwitch
        self.rightTextLab = rightTextLab
        
        self.outBtton = outBtton
        
        // 左边
        leftIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(MetricGlobal.margin)
            make.centerY.equalToSuperview()
        }
        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(leftIcon.snp.right).offset(MetricGlobal.padding)
            make.centerY.equalToSuperview()
        }
        
        // 右边
        rightIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-MetricGlobal.margin)
            make.centerY.equalToSuperview()
        }
        dotIcon.snp.makeConstraints { (make) in
            make.right.equalTo(rightIcon.snp.left).offset(-MetricGlobal.padding / 2)
            make.centerY.equalToSuperview()
        }
        descriptionLab.snp.makeConstraints { (make) in
            make.right.equalTo(rightIcon.snp.left).offset(-MetricGlobal.padding / 2)
            make.centerY.equalToSuperview()
        }
        
        view.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        // 中间竖线
        centerVerticalLine.snp.makeConstraints { (make) in
            make.width.equalTo(MetricCell.lineHeight)
            make.top.equalToSuperview().offset(MetricGlobal.margin)
            make.bottom.equalToSuperview().offset(-MetricGlobal.margin)
            make.centerX.equalToSuperview()
        }
        // 录音按钮
        rightRecordButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-MetricGlobal.margin)
            make.centerY.equalToSuperview()
        }
        // 开关
        rightSwitch.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-MetricGlobal.margin)
            make.centerY.equalToSuperview()
        }
        // 文本
        rightTextLab.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-MetricGlobal.margin)
            make.centerY.equalToSuperview()
        }
        //退出按钮
        outBtton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(MetricGlobal.margin/2)
            make.left.equalToSuperview().offset(MetricGlobal.margin)
            make.right.equalToSuperview().offset(-MetricGlobal.margin)
            make.bottom.equalToSuperview().offset(-MetricGlobal.margin/2)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK:- Setter
    func setModel() {
        
        // 样式调整部分
        let cellType = model?.cellType ?? .normal
        switch cellType {
        case .normal:
            self.rightIcon?.isHidden = false
            self.descriptionLab?.isHidden = false
            
            self.rightSwitch?.isHidden = true
            self.rightTextLab?.isHidden = true
            self.rightRecordButton?.isHidden = true
            
            self.outBtton?.isHidden = true
            break
        case .rightRecordButton:
            self.rightIcon?.isHidden = true
            self.descriptionLab?.isHidden = true
            
            self.rightSwitch?.isHidden = true
            self.rightTextLab?.isHidden = true
            self.rightRecordButton?.isHidden = false
            
            self.outBtton?.isHidden = true
            break
        case .rightSwitch:
            
            // 设置开关
            if case let SettingCellType.rightSwitch(isOn) = cellType {
                self.rightSwitch?.isOn = isOn
            }
            
            self.rightIcon?.isHidden = true
            self.descriptionLab?.isHidden = true
            
            self.rightSwitch?.isHidden = false
            self.rightTextLab?.isHidden = true
            self.rightRecordButton?.isHidden = true
            
            self.outBtton?.isHidden = true
            break
        case .rightTextLab:
            self.rightIcon?.isHidden = true
            self.descriptionLab?.isHidden = true
            
            self.rightSwitch?.isHidden = true
            self.rightTextLab?.isHidden = false
            self.rightRecordButton?.isHidden = true
            
            self.outBtton?.isHidden = true
            break
        case .outType:
            self.rightIcon?.isHidden = true
            self.descriptionLab?.isHidden = true
            self.rightSwitch?.isHidden = true
            self.rightTextLab?.isHidden = true
            self.rightRecordButton?.isHidden = true
            self.outBtton?.isHidden = false
            self.backgroundColor = UIColor.clear
            self.titleLab?.isHidden = true
            self.outBtton?.superview?.backgroundColor = UIColor.clear
            break
        }
        
        self.centerVerticalLine?.isHidden = self.rightRecordButton?.isHidden ?? true
        
        // 显示部分
        if let leftIcon = model?.leftIcon {
            self.leftIcon?.image = UIImage(named: leftIcon)
        }
        if let title = model?.title {
            self.titleLab?.text = title
        }
        
        if let title = model?.title {
            self.outBtton?.setTitle(title, for: UIControlState.normal)
        }

        if let description = model?.description {
            self.descriptionLab?.text = description
        }
        if self.rightIcon?.isHidden == false, let rightIcon = model?.rightIcon {
            self.rightIcon?.image = UIImage(named: rightIcon)
        }
        if let dotIcon = model?.dotIcon {
            self.dotIcon?.image = UIImage(named: dotIcon)
        }
        
        if let isHiddenBottomLine = model?.isHiddenBottomLine {
            self.bottomLine?.isHidden = isHiddenBottomLine
        }
        
        if self.rightRecordButton?.isHidden == false, let rightIcon = model?.rightIcon {
            self.rightRecordButton?.setBackgroundImage(UIImage(named: rightIcon), for: .normal)
        }
        
        if self.rightTextLab?.isHidden == false, let description = model?.description {
            self.rightTextLab?.text = description
        }
    }
}

extension SettingCell: CellStyleable {
    
    // MARK:- 协议组件
    fileprivate func initEnableMudule() {
        
        // 横线
        bottomLine = bottomLine(style: .margin)
    }
}
