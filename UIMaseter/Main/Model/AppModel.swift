//
//  AppModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

private let SingAppInfo = AppInfoData()

class AppInfoData: NSObject {
    
    public var appModel: AppData?
    
    static var shared: AppInfoData {
        return SingAppInfo
    }
    
    fileprivate override init() {
        super.init()
        
        self.initData()
    }
    
    func readInfo(){
        
        let file = FileHandle.init(forReadingAtPath: SandboxData.appInfoPath())
        guard let safeFile = file else {
            return
        }
        let tmpData = safeFile.readDataToEndOfFile()
        let jsonStr = String(data: tmpData , encoding: String.Encoding.utf8)
        
        self.appModel = AppModel.deserialize(from: jsonStr)?.data
    }
    func initData(){
        
        
        if !SandboxData.isExistAppInfo() {
            
            if Util.isAlone() {
                
                let path = Bundle.main.path(forResource: "UIAppInfo", ofType: "json")
                let file = FileHandle(forReadingAtPath: path!)
                let dataAlone = file?.readDataToEndOfFile()
                
                let tmpData: NSMutableData? = NSMutableData()
                tmpData?.append((dataAlone)!)
                tmpData?.write(toFile: SandboxData.appInfoPath(), atomically: true)
            }
            
            readInfo()
            
            return
        }
        
        readInfo()
        
    }}


class AppAlone: BaseData{
    var alone: Int!
}
class AppVersion: BaseModel {
    var data: Int!
}

class AppModel: BaseModel {
    var data: AppData?
}

class AppData: BaseData {
    
    var app_id: Int?
    var uid: Int?
    var name: String?
    var icon: String?
    var des: String?
    var content: String?
    var start_pic: String?
    var welcome_pic: [WCItem]?
    var welcome_pic_is_open: Bool?
    var css_key: String?
    var group_id: Int?
    var app_group_info: [AdvInfo]?
    var add_time: String?
    var update_time: String?
    var identify: Int?
    var status: Int?
    var client_type: Int?
    var config_key: String?
    
}

class WCItem: BaseData {
    
    var id: Int?
    var app_id: Int?
    var group_id: Int?
    var pic: String?

}

class AdvInfo: BaseData {
    
    var app_id: Int?
    var group_id: Int?
    var group_type: Int?
    var app_name: String?
    var icon: String?
    
}




