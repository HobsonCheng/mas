//
//  MsgUtil.swift
//  UIDS
//
//  Created by one2much on 2018/3/13.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import JMessage

class AppKeyModel: BaseModel {
    var data: String!
}

private let MsgUtilShared = MsgUtil()

class MsgUtil: NSObject {
    
    static var shared : MsgUtil {
        return MsgUtilShared
    }
    
    func showUtil() {
        
        let suspen = BSuspensionView(frame: .zero)
        suspen.leanType = BSuspensionViewLeanType.Horizontal
        suspen.initBt(frame: .zero, delegate: self)
        suspen.frame = CGRect(x: kScreenW - 50, y: kScreenH - 150, width: 50, height: 50)
        let appwindow = UIApplication.shared.delegate?.window
        appwindow??.addSubview(suspen)
        
        MsgUtil.msg_IMInit()
    }
    
    
    // MARK: - private func
    static func _setupJMessage() {
        
        JMessage.setDebugMode()
        
        // iOS 8 以前 categories 必须为nil
        JMessage.register(
            forRemoteNotificationTypes: UIRemoteNotificationType.badge.rawValue |
                UIRemoteNotificationType.sound.rawValue |
                UIRemoteNotificationType.alert.rawValue,
            categories: nil)
    }
    
    static func msg_IMInit(){
        
        
        ApiUtil.share.getProjectAppKey(params: NSMutableDictionary()) { (status, data, msg) in
            
            
            let dataKey = AppKeyModel.deserialize(from: data)?.data
            
            if dataKey == nil {
                return
            }
            
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            
            JMessage.setupJMessage(appdelegate.app_launchOptions, appKey: dataKey, channel: nil, apsForProduction: true, category: nil, messageRoaming: true)
            _setupJMessage()
            
        }
        
    }
    
}


extension MsgUtil:BSuspensionViewDelegate{
    
    
    func suspensionViewClick(view: BSuspensionView) {
        
        if Util.get_defult(key: kCurrentUserName) == nil {
            MBMasterHUD.showLoading(title: "登录中...")
            //获取用户im 登录信息
            ApiUtil.share.getUser(params: NSMutableDictionary(), finish: {[weak self] (status, data, tips) in
                MBMasterHUD.hide {}
                if B_ResponseStatus.success == status {
                    
                    let imuser = IMUserModel.deserialize(from: data)?.data
                    
                    self?.loginIM(username: (imuser?.user_name)!, password: (imuser?.password)!)
                    if let tip = tips{
                        MBMasterHUD.showInfo(title: tip)
                    }
                }
            })
            
        } else {
            
            self.gotoChatlist()
            
        }
        
    }
    
    
    
    private func loginIM(username: String, password: String){
        MBMasterHUD.showLoading(title: "授权中...")
        JMSGUser.login(withUsername: username, password: password) {[weak self] (result, error) in
            MBMasterHUD.hide {}
            if error == nil {
                Util.save_defult(key: kLastUserName, value: username)
                JMSGUser.myInfo().thumbAvatarData({ (data, id, error) in
                    if let data = data {
                        let imageData = NSKeyedArchiver.archivedData(withRootObject: data)
                        Util.save_defult(key: kLastUserAvator, value: imageData)
                    } else {
                        Util.removeObject(key: kLastUserAvator)
                    }
                })
                Util.save_defult(key: kCurrentUserName, value: username)
                Util.save_defult(key: kCurrentUserPassword, value: password)
                
                self?.gotoChatlist()
            } else {
                MBMasterHUD.showFail(title: "\(String.errorAlert(error! as NSError))")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+4) {
            MBMasterHUD.hide {}
        }
    }
    
    private func gotoChatlist(){
        
        let navivc = UINavigationController(rootViewController: JCConversationListViewController(name: "JCConversationListViewController"))
        let topvc = VCController.getTopVC()
        topvc?.present(navivc, animated: true, completion: {
            
        })
    }
    
}

//MARK - 生成视图

protocol BSuspensionViewDelegate {
    
    //点击按钮
    func suspensionViewClick(view: BSuspensionView)
    
}

enum BSuspensionViewLeanType {
    case Horizontal//左右
    case EachSide//全局
}


class BSuspensionView: UIButton {
    
    private var delegate: BSuspensionViewDelegate?
    
    var leanType: BSuspensionViewLeanType!
    
    
    func initBt(frame: CGRect, delegate: BSuspensionViewDelegate){
        self.delegate = delegate
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.alpha = 0.8
        
        self.setImage(UIImage.init(named: "2.png"), for: UIControlState.normal)
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(changeLocation(p:)))
        pan.delaysTouchesBegan = true
        self.addGestureRecognizer(pan)
        self.addTarget(self, action: #selector(click), for: UIControlEvents.touchUpInside)
    }
    
    
    
    
    @objc func changeLocation(p:UIPanGestureRecognizer){
        
        let appwindow = UIApplication.shared.delegate?.window
        let panPoint = p.location(in: appwindow!)
        
        if (p.state == UIGestureRecognizerState.began){
            
            self.alpha = 1
        }else if (p.state == UIGestureRecognizerState.changed){
            self.center = CGPoint(x: panPoint.x, y: panPoint.y)
        }else if (p.state == UIGestureRecognizerState.ended || p.state == UIGestureRecognizerState.cancelled) {
            
            self.alpha = 0.8
            let touchWidth = self.width
            let touchHeight = self.height
            let screenWith = kScreenW
            let screenHeight = kScreenH
            
            let left:Float = Float(fabs(panPoint.x))
            let right:Float = fabs(Float(screenWith) - left)
            let top:Float = Float(fabs(panPoint.y))
            let bottom:Float = fabs(Float(screenHeight) - top)
            
            var minSpace: Float = 0.0
            
            if self.leanType == BSuspensionViewLeanType.Horizontal {
                minSpace = Float(min(left, right))
            }else {
                minSpace = Float(min(Float(min(Float(min(top, left)), bottom)), right))
            }
            
            var newCenter: CGPoint! = CGPoint(x: 0, y: 0)
            let targetY:CGFloat!
            
            //校正Y
            if panPoint.y < 15 + touchHeight/2.0{
                targetY = 15 + touchHeight/2.0
            }else if panPoint.y > (screenHeight - touchHeight / 2.0 - 15) {
                targetY = screenHeight - touchHeight / 2.0 - 15
            }else{
                targetY = panPoint.y
            }
            
            if minSpace == left {
                newCenter = CGPoint(x: touchHeight/3, y: targetY)
            }else if minSpace == right {
                newCenter = CGPoint(x: screenWith - touchHeight / 3, y: targetY)
            }else if minSpace == top {
                newCenter = CGPoint(x: panPoint.x, y: touchWidth / 3)
            }else if minSpace == bottom {
                newCenter = CGPoint(x: panPoint.x, y: screenHeight - touchWidth / 3)
                
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                self.center = newCenter
            })
        }
    }
    
    @objc func click(){
        self.delegate?.suspensionViewClick(view: self)
    }
    
}
