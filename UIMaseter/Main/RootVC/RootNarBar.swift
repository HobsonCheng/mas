//
//  RootNarBar.swift
//  UIDS
//
//  Created by one2much on 2018/1/22.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
//import Font_Awesome_Swift

enum NAV_BAR_TYPE: Int {
    case NAV_BAR_TYPE_ADD_GROUP = 10000
    case NAV_BAR_TYPE_ADD_TOPOC
}

//拓展 导航按钮信息
extension RootVC {
    
    func gender_extension_Right_navbar(type: NAV_BAR_TYPE) {
        
        //导航右部信息
        let tmpRightList = self.naviBar()?.getRightBarItems()
        
        for barView in tmpRightList! {
            if (barView as AnyObject).tag == type.rawValue {
                return;
            }
        }
        
        switch type {
        case  .NAV_BAR_TYPE_ADD_GROUP:
            self.genderAdd_group()
            break
        case  .NAV_BAR_TYPE_ADD_TOPOC:
            self.genderAdd_topoc()
            break
        }
    }
    
    private func genderAdd_group(){
        
        let right =  NaviBarItem.init(imageSize: CGSize.init(width: 44, height: 22), target: self, action: #selector(RootVC.touchAddGroup))
        right.tag = NAV_BAR_TYPE.NAV_BAR_TYPE_ADD_GROUP.rawValue
        right.button?.setYJIcon(icon: .add, iconSize: 20, forState: UIControlState.normal)
        
        self.naviBar()?.setRightBarItems(with: right)
    }
    private func genderAdd_topoc(){
        
        let right = NaviBarItem.init(imageSize: CGSize.init(width: 44, height: 22), target: self, action: #selector(RootVC.touchAddTopice))
        right.tag = NAV_BAR_TYPE.NAV_BAR_TYPE_ADD_TOPOC.rawValue
        right.button?.setYJIcon(icon: .publish, iconSize: 20, forState: UIControlState.normal)
        
        self.naviBar()?.setRightBarItems(with: right)
    }
    
}
//MARK: - action
extension RootVC {
    
    @objc func touchAddGroup() {
        
        let alert = LSXAlertInputView.init(title: "创建群组", placeholderText: "请输入创建群组名", withKeybordType: LSXKeyboardType.default) {(contents) in
            let params = NSMutableDictionary()
            params.setValue(contents, forKey: "name")
            ApiUtil.share.addGroup(params: params, fininsh: { (status, data, msg) in
                
                Util.msg(msg: "提交成功", type: .Successful)
                
            })
        }
        alert.show()
    }
    
    @objc func touchAddTopice() {
        
        let topiceSend = GroupTopicSendVC.init(name: "GroupTopicSendVC")
        topiceSend.pageData = self.pageData
        VCController.push(topiceSend, with: VCAnimationBottom.defaultAnimation())
        
    }
    
}
