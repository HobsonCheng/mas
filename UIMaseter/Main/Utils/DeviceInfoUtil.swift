//
//  AppInfo.swift
//  UIDS
//
//  Created by Hobson on 2018/3/30.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import CoreLocation

final class DeviceInfo{
    var coordinate:CLLocationCoordinate2D?
    var city:String = "110105"
    var code:String = "北京市"
    static let shared = DeviceInfo()
    private init(){}
    /// 屏幕宽度
    static var screenW:CGFloat{
        return UIScreen.main.bounds.width
    }
    /// 屏幕高度
    static var screenH:CGFloat{
        return UIScreen.main.bounds.height
    }
    /// 设备的bounds
    static var deviceFrame:CGRect{
        return UIScreen.main.bounds
    }
    /// 系统版本
    static var systemVersion:String{
        return UIDevice.current.systemVersion
    }

    /// 应用的scheme
    ///
    /// - Parameter scheme: scheme
    /// - Returns: 拼接好的scheme
    static func appIPhoneSchemeString(scheme:String) -> String{
        return "UIMaster://" + scheme
    }
}
