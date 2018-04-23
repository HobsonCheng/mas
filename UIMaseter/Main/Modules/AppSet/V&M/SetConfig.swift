//
//  SetConfig.swift
//  UIDS
//
//  Created by one2much on 2018/1/25.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class SetConfig: NSObject {

}

// MARK:- 外部访问方法
extension SetConfig {
    
    // MARK:- 我的
    class func loadMineModels() -> [[SettingCellModel]] {
        
        let userinfo = UserUtil.share.appUserInfo
        
        let model1_1 = SettingCellModel(leftIcon: nil,
                                          title: "头像",
                                          description: nil,
                                          dotIcon: nil,
                                          rightIcon: "meRecord",
                                          isHiddenBottomLine: false,
                                          cellType: .rightRecordButton)
        
        let model1_2 = SettingCellModel(leftIcon: nil,
                                        title: "名字",
                                        description: userinfo?.zh_name,
                                        dotIcon: nil,
                                        rightIcon: "cell_arrow.png",
                                        isHiddenBottomLine: true,
                                        cellType: .rightTextLab)
        
        var models = [[SettingCellModel]]()
        
        // 充当 SectionHeader 数据模型
        let placeModel = SettingCellModel()
        
        models.append([placeModel, model1_1,model1_2])
        

        return models
    }
    
    // MARK:- 设置
    class func loadSettingModels() -> [[SettingCellModel]] {
        
//        let model1_1 = SettingCellModel(leftIcon: "scan_scan.png",
//                                          title: "扫一扫",
//                                          description: nil,
//                                          dotIcon: nil,
//                                          rightIcon: "cell_arrow.png",
//                                          isHiddenBottomLine: true)
        
        
//        let model2_1 = SettingCellModel(leftIcon: nil,
//                                          title: "新消息通知",
//                                          description: nil,
//                                          dotIcon: nil,
//                                          rightIcon: "cell_arrow.png",
//                                          isHiddenBottomLine: false,
//                                          cellType: .rightSwitch(isOn: true))
        let model2_2 = SettingCellModel(leftIcon: nil,
                                        title: "消息列表",
                                        description: nil,
                                        dotIcon: "nil",
                                        rightIcon: "cell_arrow.png",
                                        isHiddenBottomLine: false)
//        let model2_3 = SettingCellModel(leftIcon: nil,
//                                          title: "隐私",
//                                          description: nil,
//                                          dotIcon: nil,
//                                          rightIcon: "cell_arrow.png",
//                                          isHiddenBottomLine: false)
        let model2_4 = SettingCellModel(leftIcon: "me_setting_feedback.png",
                                        title: "帮助与反馈",
                                        description: nil,
                                        dotIcon: nil,
                                        rightIcon: "cell_arrow.png",
                                        isHiddenBottomLine: true)
//        let model3_1 = SettingCellModel(leftIcon: nil,
//                                          title: "推送设置",
//                                          description: "别错过重要信息，去开启",
//                                          dotIcon: nil,
//                                          rightIcon: "cell_arrow.png")
        
        
//        let model4_1 = SettingCellModel(leftIcon: nil,
//                                          title: "清理占用空间",
//                                          description: "0.0M",
//                                          dotIcon: nil,
//                                          rightIcon: "cell_arrow.png",
//                                          isHiddenBottomLine: true,
//                                          cellType: .rightTextLab)
//
//
//        let model5_1 = SettingCellModel(leftIcon: nil,
//                                          title: "特色功能",
//                                          description: "",
//                                          dotIcon: nil,
//                                          rightIcon: "cell_arrow.png")
//        let model5_2 = SettingCellModel(leftIcon: nil,
//                                          title: "新版本介绍",
//                                          description: "",
//                                          dotIcon: "noread_icon.png",
//                                          rightIcon: "cell_arrow.png")
//        let model5_3 = SettingCellModel(leftIcon: nil,
//                                          title: "给个好评",
//                                          description: "",
//                                          dotIcon: nil,
//                                          rightIcon: "cell_arrow.png")
        let model5_4 = SettingCellModel(leftIcon: nil,
                                          title: "关于",
                                          description: "",
                                          dotIcon: nil,
                                          rightIcon: "cell_arrow.png",
                                          isHiddenBottomLine: true)
        
        
        var models = [[SettingCellModel]]()
        
        // 充当 SectionHeader 数据模型
        let placeModel = SettingCellModel()
        
        
        if UserUtil.isValid() {//植入用户信息入口
            
            let model0_1 = SettingCellModel(leftIcon: nil,
                                            title: "我的",
                                            description: nil,
                                            dotIcon: nil,
                                            rightIcon: "cell_arrow.png",
                                            isHiddenBottomLine: true)
            models.append([placeModel, model0_1])
            
        }
        
        
//        models.append([placeModel, model1_1])
        models.append([placeModel, model2_2,model2_4])
//        models.append([placeModel, model3_1])
//        models.append([placeModel, model4_1])
        models.append([placeModel, model5_4])
        
        
        //登出按钮
        if UserUtil.isValid() {
            let model6_1 = SettingCellModel.init(leftIcon: nil, title: "退出登录", description: "", dotIcon: nil, rightIcon: nil, isHiddenBottomLine: true, cellType: .outType)
            
            models.append([placeModel, model6_1])
        }
        
        
        return models
    }
}
