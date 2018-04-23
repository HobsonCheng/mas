//
//  UserUtil.swift
//  UIDS
//
//  Created by one2much on 2018/1/19.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

private let MY_APP_USER_INFO = "MY_APP_USER_INFO"


class UserUtil: NSObject {

    var appUserInfo: UserInfoData?
    
    //存储登录信息
    static let share =  UserUtil()
    
    override init() {
        super.init()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.getUserInfo()
        }
    }
    
    //MARK: 是否登录
    static func isValid() -> Bool {
        
        if (UserUtil.share.appUserInfo != nil) {
            return true
        }
        return false
    }
    static func getGroupId() -> Int{
        //todo:
        let appInfo = AppInfoData.shared.appModel
        if isValid(){
            return appInfo?.app_group_info?[1].group_id ?? 0
        }else{
            return appInfo?.app_group_info?[0].group_id ?? 0
        }
    }
    //MARK: 存储登录用户信息
    func saveUser(userInfo: String?) {
        if (userInfo?.isEmpty)! {
            return
        }
        
        let tmpData = UserInfoModel.deserialize(from: userInfo)?.data
        if tmpData?.Authorization != nil {
            self.appUserInfo = tmpData
        }else {
            tmpData?.Authorization = self.appUserInfo?.Authorization
            
            self.appUserInfo = tmpData
        }
        
        let newInfo = UserInfoModel.deserialize(from: userInfo)
        newInfo?.data?.Authorization = tmpData?.Authorization
        
        let newUserInfo = newInfo?.toJSONString()
        
        ZZDiskCacheHelper.saveObj(MY_APP_USER_INFO, value: newUserInfo)
    }
    
    func getUserInfo(){
        ZZDiskCacheHelper.getObj(MY_APP_USER_INFO) { [weak self] (obj) in
            if (obj != nil){
                let tmpData = UserInfoModel.deserialize(from: String.init(format: "%@", obj as! CVarArg))?.data
                if tmpData?.Authorization != nil {
                    self?.appUserInfo = tmpData
                }else {
                    tmpData?.Authorization = self?.appUserInfo?.Authorization
                    
                    self?.appUserInfo = tmpData
                }
            }else {
                self?.appUserInfo = nil
            }
        }
    }
    
    func removerUser(){
        self.appUserInfo = nil
        ZZDiskCacheHelper.saveObj(MY_APP_USER_INFO, value: nil)
    }
    
}
