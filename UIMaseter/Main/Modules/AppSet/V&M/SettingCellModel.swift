//
//  SettingCellModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/25.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit


public enum SettingCellType {
    case normal                                 // 正常
    case rightRecordButton                      // 右侧录音
    case rightSwitch(isOn: Bool)                // 右侧开关
    case rightTextLab                           // 右侧文本
    case outType                                // 退出按钮
}

public struct SettingCellModel {

    var leftIcon: String?
    var title: String?
    var description: String?
    var dotIcon: String?
    var rightIcon: String?
    
    var isHiddenBottomLine: Bool? = false
    var cellType: SettingCellType = .normal
    
    init() {
    }
    
    init(leftIcon: String?, title: String?, description: String?, dotIcon: String?, rightIcon: String?) {
        
        self.leftIcon = leftIcon
        self.title = title
        self.description = description
        self.rightIcon = rightIcon
        self.dotIcon = dotIcon
    }
    
    init(leftIcon: String?, title: String?, description: String?, dotIcon: String?, rightIcon: String?, isHiddenBottomLine: Bool) {
        
        self.leftIcon = leftIcon
        self.title = title
        self.description = description
        self.rightIcon = rightIcon
        self.dotIcon = dotIcon
        
        self.isHiddenBottomLine = isHiddenBottomLine
    }
    
    init(leftIcon: String?, title: String?, description: String?, dotIcon: String?, rightIcon: String?, isHiddenBottomLine: Bool, cellType: SettingCellType) {
        
        self.leftIcon = leftIcon
        self.title = title
        self.description = description
        self.rightIcon = rightIcon
        self.dotIcon = dotIcon
        
        self.isHiddenBottomLine = isHiddenBottomLine
        self.cellType = cellType
    }
}
