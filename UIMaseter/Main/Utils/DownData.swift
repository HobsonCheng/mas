//
//  SandboxData.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

/// 该类主要用于从沙盒中寻找文件数据
class SandboxData {
    //MARK: - 获取文件路径
    
    static func appInfoPath() -> String{
        let libPath = libraryPath()
        let FileName = "\(libPath)/UIAppInfo.json"
        print("===\(FileName)")
        return FileName
    }
    static func pageListInfoPath()-> String{
        let libPath = libraryPath()
        let FileName = "\(libPath)/UIPageList.json"
        
        return FileName
    }
    static func tabbarIconPath() -> String {
        return libraryPath()
    }
    static func resoursePathUCSetInfo()-> String{
        let libPath = libraryPath()
        let FileName = "\(libPath)/UCSetInfo.json"
        return FileName
    }
    
    //检测文件是否存在
    static func isExistAppInfo()-> Bool{
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: self.appInfoPath()){
            return true
        }
        return false
    }
    static func isExistPageListInfo()-> Bool{
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: self.pageListInfoPath()){
            return true
        }
        
        return false
    }
    
    static func isExistUCSetInfo()-> Bool{
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: self.resoursePathUCSetInfo()){
            return true
        }
        
        return false
    }
    static func isExistTabbarIcons()-> Bool{
        
        let fileManager = FileManager.default
        let path = "\((self.tabbarIconPath()))/tabBar_icon_1@2x.png"
        if fileManager.fileExists(atPath: path){
            return true
        }
        
        return false
    }
    
    
    static func findConfigData(name: String,model_id: String?,config_key: String) -> NSDictionary{
        let configData = JSON.init(parseJSON: config_key)
        
        for item in configData {//数据拆分
            let configName: String? = String(describing: item.0)
            if ((configName?.range(of: name)) != nil){
                if model_id != nil {
                    if ((configName?.range(of: model_id!)) != nil){
                        return item.1.rawValue as! NSDictionary
                    }
                }else{
                    return item.1.rawValue as! NSDictionary
                }
            }
        }
        
        return NSDictionary()
    }
    static func findCSSData(model_id:String?,css_key:String) -> NSDictionary?{
        let CSSData = JSON.init(parseJSON: css_key)
        for item in CSSData{
            if item.0 == model_id{
                return item.1.rawValue as! NSDictionary
            }
        }
        return nil
    }
}
extension SandboxData{
    //获取沙盒路径
    static func homePath() -> String {
        return NSHomeDirectory()
    }

    //获取document路径
    static func documentPath() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        
    }
    //获取library路径
    static func libraryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    }
    //获取tmp文件路径
    static func tmpPath() -> String {
        return NSTemporaryDirectory()
        
    }
    //获取caches文件路径
    static func cachesPath() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
    }
    //获取preferences文件路径
    static func perferencesPath() -> String {
        let lib = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        return lib + "/Preferences"
        
    }
    //获取bundlePath
    static func bundlePath() -> String {
        return Bundle.main.bundlePath
    }
    ///获取bundle中的文件路径
    static func getBundleFilePath(with fileName: String) -> String?{
        return Bundle.main.path(forResource: fileName, ofType: nil)
    }
}
