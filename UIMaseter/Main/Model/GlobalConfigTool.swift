//
//  GlobleStyle.swift
//  UIMaseter
//
//  Created by one2much on 2018/4/23.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
class GlobalConfigTool{
    fileprivate let globalData: GlobalData?
    
    /// 全局
    let global: GlobalConfig?
    /// 导航栏
    let naviBar: NavibarGlobalConfig?
    /// 状态栏
    let stateBar: StateBarStyle?
    fileprivate static let singleton = GlobalConfigTool()
    
    fileprivate init() {
        let path = SandboxData.getBundleFilePath(with: "getApp.json")
        let file = FileHandle.init(forReadingAtPath: path ?? "")
        let tmpData = file?.readDataToEndOfFile()
        let jsonStr = String(data: tmpData!, encoding: String.Encoding.utf8)
        let data = GlobalModel.deserialize(from: jsonStr)?.data
        self.globalData = data
        self.naviBar = data?.naviBar
        self.global = data?.global
        self.stateBar = data?.stateBar
    }
    static var shared: GlobalConfigTool{
        return singleton
    }
    
}

///全局模型
class GlobalModel: BaseModel{
    var data: GlobalData?
}
class GlobalData: BaseData{
    var global: GlobalConfig?
    var naviBar: NavibarGlobalConfig?
    var stateBar: StateBarStyle?
}
class StateBarStyle: BaseData{
    var color: Int?
}
//MARK: - 全局
class GlobalConfig: BaseData{
    var fields: GlobalFields?
    var styles: GlobalStyles?
}
class GlobalFields: BaseData{
    var hudStyle: String?
    var networkTimeout: Int?
}
class GlobalStyles: BaseData{
    var fontFamily: String?
    var fontSize: Int?
}
//MARK: - Navibar
class NavibarGlobalConfig: BaseData {
    var fields: NavibarGlobalFields?
    var styles: NaviBarGlobalStyle?
    var events: AnyObject?
    var items: AnyObject?
    
}
class NavibarGlobalFields: BaseData {
    var title: String?
}
class NaviBarGlobalStyle: BaseData{
    var titleColor: String?
    var bgColor: String?
    var bgImg: String?
    var bgImgMode: String?
    var itemColor: String?
    var itemSize: Int?
}
