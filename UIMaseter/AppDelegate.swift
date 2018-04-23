//
//  AppDelegate.swift
//  UIMaseter
//
//  Created by one2much on 2018/4/9.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import JMessage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var app_launchOptions: [UIApplicationLaunchOptionsKey: Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        app_launchOptions = launchOptions
        
        window = UIWindow()
        let rootVc = ViewController()
        window?.rootViewController = rootVc
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JMessage.registerDeviceToken(deviceToken)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        resetBadge(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        resetBadge(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        //        if url.scheme == WECHAT_APPID {
        //            return WXApi.handleOpen(url, delegate: BQLAuthEngine.single)
        //        }
        //        else if url.scheme == "tencent" + QQ_APPID {
        //            return TencentOAuth.handleOpen(url)
        //        }
        //        else if url.scheme == "wb" + SINA_APPKEY {
        //            return WeiboSDK.handleOpen(url, delegate: BQLAuthEngine.single)
        //        }
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        //        if url.scheme == WECHAT_APPID {
        //            return WXApi.handleOpen(url, delegate: BQLAuthEngine.single)
        //        }
        //        else if url.scheme == "tencent" + QQ_APPID {
        //            return TencentOAuth.handleOpen(url)
        //        }
        //        else if url.scheme == "wb" + SINA_APPKEY {
        //            return WeiboSDK.handleOpen(url, delegate: BQLAuthEngine.single)
        //        }
        return true
    }
    private func resetBadge(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        //        application.cancelAllLocalNotifications()
        JMessage.resetBadge()
    }

}

//MARK: - JMessage Delegate
extension AppDelegate: JMessageDelegate {
    func onDBMigrateStart() {
        MBMasterHUD.showInfo(title: "数据库升级中")
    }
    
    func onDBMigrateFinishedWithError(_ error: Error!) {
        MBMasterHUD.hide {}
        MBMasterHUD.showInfo(title: "数据库升级完成")
    }
    
    func onReceive(_ event: JMSGNotificationEvent!) {
        switch event.eventType {
        case .receiveFriendInvitation, .acceptedFriendInvitation, .declinedFriendInvitation:
            cacheInvitation(event: event)
        case .loginKicked, .serverAlterPassword, .userLoginStatusUnexpected:
            _logout()
        case .deletedFriend, .receiveServerFriendUpdate:
            NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateFriendList), object: nil)
        default:
            break
        }
    }
    
    private func cacheInvitation(event: JMSGNotificationEvent) {
        let friendEvent =  event as! JMSGFriendNotificationEvent
        _ = friendEvent.getFromUser()
        _ = friendEvent.getReason()
        
        if UserDefaults.standard.object(forKey: kUnreadInvitationCount) != nil {
            let count = UserDefaults.standard.object(forKey: kUnreadInvitationCount) as! Int
            UserDefaults.standard.set(count + 1, forKey: kUnreadInvitationCount)
        } else {
            UserDefaults.standard.set(1, forKey: kUnreadInvitationCount)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateVerification), object: nil)
    }
    
    func _logout() {
        
    }
}
