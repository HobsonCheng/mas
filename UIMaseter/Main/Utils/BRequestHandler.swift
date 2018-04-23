//
//  BRequestHandler.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Reachability
/// 请求响应状态
///
/// - success: 响应成功  - 就是成功
/// - unusual: 响应异常  - 例如 手机已被注册
/// - notLogin: 未登录   - 例如 token到期
/// - failure: 请求错误  - 例如 比如网络错误
enum B_ResponseStatus: Int{
    case success  = 0
    case unusual  = 1
    case notLogin = 2
    case failure  = 3
}

/// 网络请求回调
typealias NetworkFinished = (_ status: B_ResponseStatus, _ result: String?, _ tipString: String?) -> ()
typealias CallBackHostName = (_ apiName: String?) -> ()



class BRequestHandler: NSObject {
    
    fileprivate var afManager: SessionManager!
    static fileprivate let shareHandler = BRequestHandler()
    public var appHostName: String? {
        didSet {
            if appHostName?.hasPrefix("https") != true  {
                appHostName = "https://\(appHostName!)"
            }
        }
    }
    ///单例
    static var shared: BRequestHandler {
        return shareHandler
    }
    fileprivate override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 8
        afManager = SessionManager(
            configuration: configuration
        )
        self.getAppHostName(callback: nil)
    }

    public func getAppHostName(callback: CallBackHostName?){
        
        if self.appHostName != nil {
            if callback != nil {
                callback?(self.appHostName)
            }
            return
        }
        
        guard let appinfo = AppInfoData.shared.appModel else{
            return
        }
        
        let hostUrl = String.init(format: "https://rgpro.uidashi.com/registProject?add_pid=%zd&key=801004222a98d5c3a2acb6aa72c49e9e", (appinfo.app_id)!)
        
        let headerparams = self.getHTTPHeaders(parameters: nil)
        
        Alamofire.request(hostUrl, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: headerparams).responseString { (response) in
            
            let result = String.init(data: response.data!, encoding: String.Encoding.utf8)
            
            self.appHostName = result
            
            if callback != nil {
                callback?(self.appHostName)
            }
        }
    }
    
    /// 获取请求头
    ///
    /// - Returns: 请求头
    fileprivate func getHTTPHeaders(parameters: [String : Any]?) -> [String : String] {
        
        // api版本
        var headers = [
            "X-API-VERSION" : "1.0",
            
            ]
        
        
        //添加m3token
        let Authorization = UserUtil.share.appUserInfo?.Authorization
        if Authorization != nil {
            headers["Authorization-M3"] = Authorization
            print("请求头加入了token", Authorization as Any)
        }
        
        // uuid
        //        if let uuid = JFObjcTools.uuidString() {
        //            headers["X-DEVICE-ID"] = uuid
        //            print("请求头加入了device", uuid)
        //        }
        
        // 请求签名
        // 字典key排序
        var keys = [String]()
        if let parameters = parameters {
            for key in parameters.keys {
                keys.append(key)
            }
        }
        for key in headers.keys {
            keys.append(key)
        }
        keys = keys.sorted(by: {$0 < $1})
        
        // 拼接排序后的参数
        var jointParameters = ""
        for key in keys {
            if headers.keys.contains(key) {
                jointParameters += key
                jointParameters += "\(headers[key]!)"
            }
            if let parameters = parameters {
                if parameters.keys.contains(key) {
                    jointParameters += key
                    jointParameters += "\(parameters[key]!)"
                }
            }
            
        }
        
        //        let md5Hex =  jointParameters.md5Data()!.map { String(format: "%02hhx", $0) }.joined().uppercased()
        
        // 算法 hex(md5(headers + parameters + secret))
        //        headers["X-SIGNATURE"] = md5Hex
        //        print("请求头加入了signature", md5Hex)
        
        return headers
    }
}
// MARK: - 普通get/post请求方法
extension BRequestHandler {
    
    /*
     获取请求的 url
     */
    func getApiUrl(apiName: String?,callback: @escaping CallBackHostName){
        
        self.getAppHostName { (hostname) in
            if self.appHostName != nil {
                let apiname =  String(format: "%@/%@", self.appHostName!,apiName!)
                callback(apiname)
            }
        }
    }
    
    /**
     GET请求
     
     - parameter APIString:  urlString
     - parameter parameters: 参数
     - parameter finished:   完成回调
     */
    func getHaveHostName(hostname: String,APIString: String, parameters: [String : Any]?, finished: @escaping NetworkFinished) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let apiurl = hostname + APIString
        
        self.afManager.request(apiurl, parameters: parameters, headers: self.getHTTPHeaders(parameters: parameters)).responseJSON { (response) in
            self.handle(response: response, finished: finished)
        }
    }
    
    func getAppHostNEW(app_id: Int,callback: CallBackHostName?) {
        
        let hostUrl = String.init(format: "https://rgpro.uidashi.com/registProject?add_pid=%zd&key=801004222a98d5c3a2acb6aa72c49e9e", (app_id))
        
        let headerparams = self.getHTTPHeaders(parameters: nil)
        
        Alamofire.request(hostUrl, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: headerparams).responseString { (response) in
            
            let result = String.init(data: response.data!, encoding: String.Encoding.utf8)
            
            self.appHostName = result
            
            
            if callback != nil {
                callback?(self.appHostName)
            }
        }
    }
    
    
    /**
     GET请求
     
     - parameter APIString:  urlString
     - parameter parameters: 参数
     - parameter finished:   完成回调
     */
    func get(APIString: String, parameters: [String : Any]?, finished: @escaping NetworkFinished) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.getApiUrl(apiName: APIString) { (apiurl) in
            
            self.afManager.request(apiurl!, parameters: parameters, headers: self.getHTTPHeaders(parameters: parameters)).responseJSON { (response) in
                self.handle(response: response, finished: finished)
            }
        }
    }
    
    /**
     POST请求
     
     - parameter APIString:  urlString
     - parameter parameters: 参数
     - parameter finished:   完成回调
     */
    func post(APIString: String, parameters: [String : Any]?, finished: @escaping NetworkFinished) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        afManager.request(APIString, method: .post,parameters: parameters, headers: getHTTPHeaders(parameters: parameters)).responseJSON { (response) in
            self.handle(response: response, finished: finished)
        }
    }
    
    /// 处理响应结果
    ///
    /// - Parameters:
    ///   - response: 响应对象
    ///   - finished: 完成回调
    fileprivate func handle(response: DataResponse<Any>, finished: @escaping NetworkFinished) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        switch response.result {
        case .success(let value):
            
            print(response.request?.url ?? "", JSON.init(value))
            let json = JSON(value)
            if json["code"].intValue == 0 {
                finished(.success, json.description, nil)
            } else if json["code"].intValue == 0203 {
                //自动进入登录
                if (VCController.getTopVC()?.isKind(of: LoginView.self))! {
                    finished(.notLogin, nil, nil)
                    return
                }
                let gotoLogin = LoginView.init(name: "LoginView")
                VCController.push(gotoLogin, with: VCAnimationBottom.defaultAnimation())
                
                finished(.notLogin, nil, nil)
            } else {
                finished(.unusual, nil, json["msg"].stringValue + "(\(json["code"].intValue))")
            }
            
        case .failure(let error):
            finished(.failure, nil, error.localizedDescription)
        }
    }
}

// MARK: - 简单json缓存
extension BRequestHandler {
    
    /**
     缓存json数据为指定json文件
     
     - parameter json:     JSON对象
     - parameter jsonPath: json文件路径
     */
    func saveJson(_ json: JSON, jsonPath: String) {
        do {
            if let json = json.rawString() {
                try json.write(toFile: jsonPath, atomically: true, encoding: String.Encoding.utf8)
                print("缓存数据成功", jsonPath)
            }
        } catch {
            print("缓存数据失败", jsonPath)
        }
    }
    
    /**
     删除指定文件
     
     - parameter jsonPath: 要删除的json文件路径
     */
    func removeJson(_ jsonPath: String) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: jsonPath) {
            do {
                try fileManager.removeItem(atPath: jsonPath)
                print("删除成功", jsonPath)
            } catch {
                print("删除失败", jsonPath)
            }
        }
    }
    
    /**
     获取缓存的json数据
     
     - parameter jsonPath: json文件路径
     
     - returns: JSON对象
     */
    func getJson(_ jsonPath: String) -> JSON? {
        if let data = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) {
            print("获取缓存数据成功", jsonPath)
            let json = try?JSON.init(data: data)
            return json
        }
        print("获取缓存数据失败", jsonPath)
        return nil
    }
}

// MARK: - 公共业务封装
extension BRequestHandler {
    // 可以封装一些公用的业务接口.........
}

// MARK: - 网络工具方法
extension BRequestHandler {
    
    /**
     获取当前网络状态
     
     - returns: 0未知 1WiFi 2WAN
     */
    func getCurrentNetworkState() -> Int {
        return Reachability.forInternetConnection().currentReachabilityStatus().rawValue
    }
    
}

