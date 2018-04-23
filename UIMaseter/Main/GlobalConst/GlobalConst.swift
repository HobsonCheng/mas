//
//  GlobalConst.swift
//  UIMaseter
//
//  Created by gongcz on 2018/4/12.
//  Copyright © 2018年 one2much. All rights reserved.
//
/*
 放一些常量
 */
import UIKit

// =======================================================================
// 布局参数
// =======================================================================
// 状态栏高度
let kStatusBarHeight: CGFloat = is_iPhoneX ? 44.0 : 20.0
// 导航栏高度
let kNavigationBarHeight: CGFloat = is_iPhoneX ? 88.0 : 64.0
// tabBar高度
let kTabBarHeight: CGFloat = is_iPhoneX ? 49.0+34.0 : 49.0
// home indicator
let kHomeIndicatorHeight: CGFloat = is_iPhoneX ? 34.0 : 0.0


// 字体


// =======================================================================
// 通知
// =======================================================================



// =======================================================================
// URL
// =======================================================================
let kQiniuBaseUrl = "http://omzvdb61q.bkt.clouddn.com/"
let kQinuiTokenUrl = "http://121.42.154.36:11124/getuptoken"
let kQiniuHostName = "http://omzvdb61q.bkt.clouddn.com/"
let kIsNeedGotoApp = "KEY_ISNEED_GOTOAPP"
let kAppVersion = "KEY_APP_VERSION"
