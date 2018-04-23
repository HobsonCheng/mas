//
//  UploadImageTool.swift
//  UIMaseter
//
//  Created by one2much on 2018/4/18.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Qiniu
import Alamofire
import SwiftyJSON

class UploadImageTool: NSObject {
    typealias UploadSuccess = (_ url: String) -> Void
    typealias UploadFailure = (_ msg: String) -> Void
    typealias AllUploadSuccess = (_ urls: [String]) -> Void
    /// 上传单张图片
    ///
    /// - Parameters:
    ///   - image: 要上传的图片
    ///   - progress: 上传进度
    ///   - success: 成功回调
    ///   - failure: 失败回调
    static func uploadImage(image: UIImage,progress:@escaping QNUpProgressHandler,success:UploadSuccess?,failure:UploadFailure?){
        
        getQiniuUploadToken(success: { (token) in //获取token
            let data = UIImageJPEGRepresentation(image, 0.01)
            guard let safeData = data else{
                if failure != nil{
                    failure!("没有图片数据")
                }
                return
            }
            // 生成图片名
            let dataStr = getDateTimeString()
            let randomStr = randomStringWithLength(len: 8)
            let fileName = "\(dataStr)_\(randomStr).png"
            // 生成七牛管理者和选项
            let qiniuManage = QNUploadManager.sharedInstance(with: nil)
            let qiniuOptions = QNUploadOption.init(mime: nil, progressHandler: progress, params: nil, checkCrc: false, cancellationSignal: nil)
            //上传得到图片url
            qiniuManage?.put(safeData, key: fileName, token: token, complete: { (info, key, resp) in
                if info?.statusCode == 200 && resp != nil{
                    let url = "\(kQiniuBaseUrl)\(key ?? "")"
                    if let safeSuccess = success{
                        safeSuccess(url)
                    }
                }else{
                    if let safeFailure = failure{
                        safeFailure("上传失败")
                    }
                }
            }, option: qiniuOptions)
        }) { (msg) in
            if let safeFailure = failure{
                safeFailure(msg)
            }
        }
    }
    /// 传多张图片,按队列依次上传
    ///
    /// - Parameters:
    ///   - imageArray: 要上传的图片数组
    ///   - progress: 上传进度
    ///   - success: 成功回调
    ///   - failure: 失败回调
    static func uploadImages(imageArray:[UIImage],progress:@escaping QNUpProgressHandler,success:@escaping AllUploadSuccess,failure:@escaping UploadFailure){
        var urlArr = [String]() //上传的图片后，得到的url数组
        var totalProgress = 0.0 // 总进度
        let partProgress = 1.0 / Double(imageArray.count) //每部分进度
        var index = 0 // 第几张图片
        weak var uploadHelper = QiniuUploadHelper()
        uploadHelper?.successCB = { url in
            urlArr.append(url)
            totalProgress += partProgress
            progress("\(index)",Float(totalProgress))
            index += 1
            if urlArr.count == imageArray.count{
                success(urlArr)
            }else{
                if index < imageArray.count{
                    uploadImage(image: imageArray[index], progress: { (str, progress) in
                        
                    }, success: uploadHelper?.successCB, failure: uploadHelper?.failCB)
                }
            }
        }
        uploadHelper?.failCB = { msg in
            failure(msg)
        }
        //上传图片
        uploadImage(image: imageArray[0], progress: { (msg, progress) in
            
        }, success: { (url) in
            uploadHelper?.successCB!(url)
        }, failure: { (msg) in
            uploadHelper?.failCB!(msg)
        })
    }
    // MARK: - 私有函数
    
    /// 获取七牛Token
    ///
    /// - Parameters:
    ///   - success: 成功回调
    ///   - failure: 失败回调
    fileprivate static func getQiniuUploadToken(success: UploadSuccess?,failure: UploadFailure?) {
        let getTokenUrl = kQinuiTokenUrl
        Alamofire.request(getTokenUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let data = response.result.value{
                let json = JSON.init(data)["data"].dictionary
                response.result.ifSuccess {
                    if let safeSuccess = success{
                        safeSuccess((json!["token"]?.string ?? ""))
                    }
                }
                response.result.ifFailure {
                    if let safeFailure = failure{
                        safeFailure(json?.description ?? "")
                    }
                }
            }
            
        }
        
    }
    //获取当前时间的字符串
    fileprivate static func getDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dataStr = formatter.string(from: Date.init())
        return dataStr
    }
    //获取指定长度的随机字符串
    fileprivate static func randomStringWithLength(len:Int) -> String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var newStr = ""
        for _ in 0...len{
            let position = Int(arc4random_uniform(UInt32(letters.count)))
            let index = letters.index(letters.startIndex, offsetBy: position)
            let c = letters[index]
            newStr.append(c)
        }
        return newStr
    }
    
}



typealias Success = (_ : String) -> ()
typealias Failure = (_ : String) -> ()

/// 该类主要用于上传多张图片时，递归调用 成功和失败的回调
class QiniuUploadHelper {
    
    var successCB: Success?
    var failCB: Failure?
    
    private static let singleton = QiniuUploadHelper()
    
    fileprivate init() {
    }
    static func shared() -> QiniuUploadHelper{
        return singleton
    }
    
}

