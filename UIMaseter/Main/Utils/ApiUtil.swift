//
//  ApiUtil.swift
//  UIDS
//
//  Created by one2much on 2018/1/19.
//  Copyright © 2018年 one2much. All rights reserved.
//
import Foundation
import UIKit
import SwiftyJSON
import HandyJSON

typealias ApiUtilFinished = (_ status: B_ResponseStatus, _ result: String?, _ tipString: String?) -> ()

class ApiUtil: NSObject {
    
    static let share = ApiUtil()
    
    //MARK: - 搜索项目
    func searchProject(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        params.setValue("project", forKey: "sn")
        params.setValue("searchProject", forKey: "ac")
        
        BRequestHandler.shared.getHaveHostName(hostname: "https://search.uidashi.com/",APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - appinfo
    func getApp(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        params.setValue("project", forKey: "sn")
        params.setValue("getApp", forKey: "ac")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - set config
    func allRestriction(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        params.setValue("uc", forKey: "sn")
        params.setValue("allRestriction", forKey: "ac")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: - pagelist
    func getPageList(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("project", forKey: "sn")
        params.setValue("getPageList", forKey: "ac")
        params.setValue(1 , forKey:"is_adaptive")
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: - 注册
    func userRegist(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("uc", forKey: "sn")
        params.setValue("userRegist", forKey: "ac")
        params.setValue("regist", forKey: "auth_code_type")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
                
                ApiUtil.share.getInfo(params: NSMutableDictionary(), fininsh: nil)
                
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - 登录
    func userLogin(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("uc", forKey: "sn")
        params.setValue("userLogin", forKey: "ac")
        params.setValue("login", forKey: "auth_code_type")
        
        BRequestHandler.shared.get(APIString: "userLogin", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
                
                ApiUtil.share.getInfo(params: NSMutableDictionary(), fininsh: nil)
                
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - phone 登录
    func userLoginByPhone(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("uc", forKey: "sn")
        params.setValue("userLoginByPhone", forKey: "ac")
        params.setValue("login", forKey: "auth_code_type")
        
        BRequestHandler.shared.get(APIString: "userLoginByPhone", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: - 获取页面信息
    func getPage(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("project", forKey: "sn")
        params.setValue("getPage", forKey: "ac")
        params.setValue(1,forKey:"is_adaptive")
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: - 获取所有页面
    func getPageList(fininsh: ApiUtilFinished?) {
        
        let params = NSMutableDictionary()
        params.setValue("project", forKey: "sn")
        params.setValue("getPageKeyList", forKey: "ac")
        params.setValue(1,forKey:"is_adaptive")
        let appinfo = AppInfoData.shared.appModel
        params.setValue(appinfo?.app_id, forKey: "app_id")
        params.setValue(appinfo?.group_id, forKey: "group_id")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - 推荐新闻
    func getInvitationList(params: NSMutableDictionary,fininsh: ApiUtilFinished?)  {
        params.setValue("getInvitationList", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - 话题列表
    func getGroupByModel(params: NSMutableDictionary,fininsh: ApiUtilFinished?)  {
        params.setValue("getGroupByModel", forKey: "ac")
        params.setValue("project", forKey: "sn")
        params.setValue("GroupListTopic", forKey: "model")
        params.setValue(UserUtil.getGroupId(), forKey: "group_id")
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - 创建群组
    func addGroup(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        params.setValue("addGroup", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        params.setValue("4", forKey: "classify_id")
        params.setValue("1", forKey: "has_sign_in")
        params.setValue("1", forKey: "invitation_authority")
        params.setValue("1", forKey: "reply_authority")
        params.setValue("2", forKey: "replay_authority")
        params.setValue("1", forKey: "attachment")
        
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARL:- 发布话题
    func addInvitation(params: NSMutableDictionary,fininsh: ApiUtilFinished?)  {
        params.setValue("addInvitation", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        params.setValue("1", forKey: "can_reply")
        params.setValue("2", forKey: "can_replay")
        params.setValue("1", forKey: "can_store")
        params.setValue("1", forKey: "can_out")
        params.setValue("2", forKey: "can_see_reply")
        params.setValue("1", forKey: "use_signature")
        params.setValue("1", forKey: "attechment")
        params.setValue("1", forKey: "pay_type")
        params.setValue("一几网络_IOS", forKey: "source")
        params.setValue("119", forKey: "x_coord")
        params.setValue("39", forKey: "y_coord")
        
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: - 用户信息
    func getInfo(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        params.setValue("getInfo", forKey: "ac")
        params.setValue("pc", forKey: "sn")
        
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.uid, forKey: "user_id")
        params.setValue(user?.pid, forKey: "user_pid")
        
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                UserUtil.share.saveUser(userInfo: data)
                
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - 获取其他用户的信息
    func getRelationInfo(params: NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("getInfo", forKey: "ac")
        params.setValue("pc", forKey: "sn")
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                //                UserUtil.share.saveUser(userInfo: data)
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - 提交表单
    func saveSubscribe(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        params.setValue("saveSubscribe", forKey: "ac")
        params.setValue("subscribe", forKey: "sn")
        
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.uid, forKey: "from_uid")
        params.setValue(user?.pid, forKey: "from_app_id")
        
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - 表单 待接单
    func getWaitSubscribeList(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("getWaitSubscribeList", forKey: "ac")
        params.setValue("subscribe", forKey: "sn")
        
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                fininsh?(status,data,msg)
            }else {
                
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - 用户发布的订单列表
    func getUserCreateSubscribeList(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("getUserCreateSubscribeList", forKey: "ac")
        params.setValue("subscribe", forKey: "sn")
        params.setValue("0,1", forKey: "status")
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                
                Util.msg(msg: msg!, type: .Error)
            }
        }
        
    }
    //MARK: - 用户承接的订单
    func getUserGrapSubscribeList(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("getUserSubscribeList", forKey: "ac")
        params.setValue("subscribe", forKey: "sn")
        params.setValue("0,1,2", forKey: "status")
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                
                Util.msg(msg: msg!, type: .Error)
            }
        }
        
    }
    //MARK :- 获取发帖列表
    func getCreatedInvitationListByUser(params:NSMutableDictionary,finish:@escaping ApiUtilFinished){
        params.setValue("getCreatedInvitationListByUser", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish(status,data,msg)
            }else {
                
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: - 更新用户信息
    func updateInfo(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("updateInfo", forKey: "ac")
        params.setValue("pc", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                fininsh?(status,data,msg)
            }else {
                
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - 幻灯片数据源
    func getSlideByModel(params: NSMutableDictionary,fininsh: ApiUtilFinished?){
        params.setValue("SwipImgArea", forKey: "model")
        params.setValue("getSlideByModel", forKey: "ac")
        params.setValue("project", forKey: "sn")
        params.setValue(UserUtil.getGroupId(), forKey: "group_id")
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                fininsh?(status,data,msg)
            }else {
                
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - 新闻列表挂在
    func getArticleByModel(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        params.setValue("ArticleList", forKey: "model")
        params.setValue("getArticleByModel", forKey: "ac")
        params.setValue("project", forKey: "sn")
        params.setValue(UserUtil.getGroupId(), forKey: "group_id")
        //        let model = AppInfoData.shared.appModel
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                fininsh?(status,data,msg)
            }else {
                
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - 获取app 版本
    func getProjectVersion(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("getProjectVersion", forKey: "ac")
        params.setValue("project", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                fininsh?(status,data,msg)
            }else {
                fininsh?(status,data,msg)
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: - 获取数据绑定 启动器数据
    func getInitiatorByModel(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("getInitiatorByModel", forKey: "ac")
        params.setValue("project", forKey: "sn")
        params.setValue("Slider", forKey: "model")
        params.setValue(UserUtil.getGroupId(), forKey: "group_id")
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
}


//MARK: - cms
extension ApiUtil{
    //MARK: CMS_detail
    func getInvitation(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        params.setValue("getInvitation", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
            
            fininsh?(status,data,msg)
        }
    }
    //MARK: 获取评论列表
    func getRepliesByInvitation(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        params.setValue("getRepliesByInvitation", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: 举报
    func tipOffInvitation(params: NSMutableDictionary,fininsh: ApiUtilFinished?){
        params.setValue("cms", forKey: "sn")
        params.setValue("tipOffInvitation", forKey: "ac")
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
        
    }
    //MARK: 添加评论
    func addReply(params: NSMutableDictionary,fininsh: ApiUtilFinished?)  {
        params.setValue("addReply", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: 删帖
    func cms_DeleteNews(params: NSMutableDictionary,finish: ApiUtilFinished?){
        params.setValue("delInvitation", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: 点赞
    func cms_zan(params: NSMutableDictionary,finish: ApiUtilFinished?) {
        
        params.setValue("praiseInvitation", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
}

//MARK: - 设置中心
extension ApiUtil{
    
    //MARK: 意见反馈
    func cms_addOpinion(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        
        params.setValue("addOpinion", forKey: "ac")
        params.setValue("cms", forKey: "sn")
        
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                fininsh?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: 关于
    func getAppAbout(finish: ApiUtilFinished?){
        let params = NSMutableDictionary()
        params.setValue("project", forKey: "sn")
        params.setValue("getAppAbout", forKey: "ac")
        BRequestHandler.shared.get(APIString: "mt",parameters: params as? [String : Any]){
            (status,data,msg) in
            if B_ResponseStatus.success == status{
                finish?(status,data,msg)
            }else{
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: 未读消息总数
    func getUnreadNotficationTotal(finish: ApiUtilFinished?){
        let params = NSMutableDictionary()
        params.setValue("getUnreadUserNotifyTotal", forKey: "ac")
        params.setValue("mc", forKey: "sn")
        
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: 消息列表
    func getNotification(params : NSMutableDictionary,finish: ApiUtilFinished?){
        params.setValue("getUserNotifyListByUser", forKey: "ac")
        params.setValue("mc", forKey: "sn")
        
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
}


//MARK: - 个人中心
extension ApiUtil{
    
    // MARK: 好友列表
    func getFriendList(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("getFriendList", forKey: "ac")
        params.setValue("pc", forKey: "sn")
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        params.setValue(user?.uid, forKey: "user_id")
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    // MARK: 获取粉丝列表
    func getFunsList(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("getFanList", forKey: "ac")
        params.setValue("pc", forKey: "sn")
        
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        params.setValue(user?.uid, forKey: "user_id")
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    // MARK: 关注列表
    func getFollowerList(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("getFollowerList", forKey: "ac")
        params.setValue("pc", forKey: "sn")
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        params.setValue(user?.uid, forKey: "user_id")
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: 获取信息流
    func getMessagePool(params:NSMutableDictionary,finish: ApiUtilFinished?){
        params.setValue("getMessagePool", forKey: "ac")
        params.setValue("pc", forKey: "sn")
        
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: 其他人的信息流
    func getOthersMessagePool(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("getMessagePool", forKey: "ac")
        params.setValue("pc", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: 添加好友
    func addFriend(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("addFriend", forKey: "ac")
        params.setValue("pc", forKey: "sn")
        
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    //MARK: 删除好友
    func deleteFriend(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("deleteFriend", forKey: "ac")
        params.setValue("pc", forKey: "sn")
        
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    
    // MARK: 添加关注
    func addFollower(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("addFollower", forKey: "ac")
        params.setValue("pc", forKey: "sn")
        
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    // MARK: 取消关注
    func deleteFollower(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("deleteFollower", forKey: "ac")
        params.setValue("pc", forKey: "sn")
        
        let user = UserUtil.share.appUserInfo
        params.setValue(user?.pid, forKey: "do_pid")
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
}


//MARK: - IM
extension ApiUtil{
    // MARK: im 用户
    func getUser(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("getUser", forKey: "ac")
        params.setValue("jiguang", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            finish?(status,data,msg)
        }
    }
    // MARK: im 项目key
    func getProjectAppKey(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("getProjectAppKey", forKey: "ac")
        params.setValue("jiguang", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            finish?(status,data,msg)
        }
    }
    // MARK: im 群列表
    func getGroups(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("getGroups", forKey: "ac")
        params.setValue("jiguang", forKey: "sn")
        
        params.setValue("1", forKey: "page")
        params.setValue("100", forKey: "page_context")
        
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            finish?(status,data,msg)
        }
    }
    // MARK: im 申请进群
    func applyGroup(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("applyGroup", forKey: "ac")
        params.setValue("jiguang", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters:params as? [String : Any]) { (status, data, msg) in
            
            finish?(status,data,msg)
        }
    }
}


//MARK: - 预约获客
extension ApiUtil{
    //MARK:  获取用户相关的表单
    func getUserFormList(params:NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("getUserFormList", forKey: "ac")
        params.setValue("subscribe",forKey:"sn")
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK:  订单列表
    func getUserSubscribeList(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        params.setValue("getUserSubscribeList", forKey: "ac")
        params.setValue("subscribe", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                fininsh?(status,data,msg)
            }else {
                
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK:  接单
    func orderSubscribe(params: NSMutableDictionary,fininsh: ApiUtilFinished?)  {
        params.setValue("orderSubscribe", forKey: "ac")
        params.setValue("subscribe", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                fininsh?(status,data,msg)
            }else {
                
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: 订单处理
    func confirmSubscribe(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        params.setValue("confirmSubscribe", forKey: "ac")
        params.setValue("subscribe", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                fininsh?(status,data,msg)
            }else {
                
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: 订单取消
    func cancelOrderSubscribe(params: NSMutableDictionary,fininsh: ApiUtilFinished?) {
        params.setValue("cancelOrderSubscribe", forKey: "ac")
        params.setValue("subscribe", forKey: "sn")
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                fininsh?(status,data,msg)
            }else {
                
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
    //MARK: 取消自己发布的订单
    func cancelSubscribe(params: NSMutableDictionary,finish:ApiUtilFinished?){
        params.setValue("subscribe", forKey: "sn")
        params.setValue("cancelSubscribe", forKey: "ac")
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                
                finish?(status,data,msg)
            }else {
                
                Util.msg(msg: msg!, type: .Error)
            }
        }
    }
}
