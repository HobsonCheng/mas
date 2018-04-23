//
//  Util.swift
//  UIDS
//
//  Created by one2much on 2018/1/8.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import MBProgressHUD

struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                                options: [],
                                                range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        else {
            return false
        }
    }
}


private let singleUtil = Util()

final class Util: NSObject{
    
    var mainVC: UIViewController?
    var upLoadImgToken: String?
    
    static var shared: Util {
        return singleUtil
    }
    
    fileprivate override init() {
        super.init();
        //初始化 配置信息
        self.setup()
    }
    func setup(){
//        iRate.sharedInstance().delegate = self
//        // 初始化Appstore id
//        iRate.sharedInstance().applicationBundleID = "com.charcoaldesign.rainbowblocks"
//        // 启动或者回到前台就尝试提醒
//        iRate.sharedInstance().promptAtLaunch = false
//        // 每个版本都弹
//        iRate.sharedInstance().promptForNewVersionIfUserRated = true
//        // 使用几次后开始弹出
//        iRate.sharedInstance().usesUntilPrompt = 2
//        // 多少天后开始弹出，默认10次
//        iRate.sharedInstance().daysUntilPrompt = 3
//        // 选择“稍后提醒我”后的再提醒时间间隔，默认是1天
//        iRate.sharedInstance().remindPeriod = 3
//        iRate.sharedInstance().declinedThisVersion = false
    }
    func setAlertContent(){
//        let rateTitle: String = "给我评价"
//        let rateText: String = "觉得这个app怎么样，喜欢就来评价一下唄"
//
//        iRate.sharedInstance().messageTitle = rateTitle
//        iRate.sharedInstance().message = rateText
//        iRate.sharedInstance().updateMessage = rateText
//        iRate.sharedInstance().rateButtonLabel? = "喜欢，支持一下"
//        iRate.sharedInstance().remindButtonLabel? = "不喜欢，去吐槽"
//        iRate.sharedInstance().cancelButtonLabel? = "以后再说"
    }
    
    
    public func checkAndRateWithController(vc :UIViewController){
//        self.mainVC = vc
//        if iRate.sharedInstance().shouldPromptForRating(){
//            iRate.sharedInstance().promptForRating();
//        }
    }
    
    //TODO: irateDelegate
//    func iRateUserDidRequestReminderToRateApp() {
//
//    }
//    func iRateUserDidDeclineToRateApp() {
//
//    }
//    func shouldPromptForRating() -> Bool {
//        return false
//    }
    
    //MARK: 存储 user set 信息
    static func save_defult(key: String,value: Any?){
        
        let userd = UserDefaults.standard
        
        userd.set(value, forKey: key)
        userd.synchronize()
    }
    static func get_defult(key: String) -> Any?{
        let userd = UserDefaults.standard
        return userd.object(forKey: key)
    }
    static func removeObject(key: String) {
        let userd = UserDefaults.standard
        userd.removeObject(forKey: key)
        userd.synchronize()
    }
    
    //MARK: 获取验证码
    static func getImgCode(type: String,callback: @escaping (_ Url: String?,_ codekey: String?)->()) {
        
        var codeUrl: String?
        
        BRequestHandler.shared.get(APIString: "authCodeKey", parameters: nil) { (status, data, msg) in
            
            if B_ResponseStatus.success == status {
                let codedata = CodeMode.deserialize(from: data)?.data
                
                let temp = Int(arc4random()%10000)+1
                
                codeUrl = String.init(format: "%@/authCode?%zd&sn=uc&ac=getAuthCode&auth_type=%@&code_key=%@",BRequestHandler.shared.appHostName!,temp,type,(codedata?.code_key)!)
                
                callback(codeUrl,codedata?.code_key)
            }
        }
    }
    static func getCodeUrl(type: String,codeKey: String) -> String {
        let temp = Int(arc4random()%10000)+1
        
        let codeUrl = String.init(format: "%@/authCode?%zd&sn=uc&ac=getAuthCode&auth_type=%@&code_key=%@",BRequestHandler.shared.appHostName!,temp,type,(codeKey))
        
        return codeUrl
    }
    
    static func getSMSCode(type: String,phone: String,codekey: String,auth_code: String,callback: @escaping (_ code: String?) -> ()) {
        
        let params = NSMutableDictionary()
        params.setValue("getPhoneEmailAuthCode", forKey: "ac")
        params.setValue("uc", forKey: "sn")
        params.setValue(type, forKey: "auth_type")
        params.setValue(codekey, forKey: "code_key")
        params.setValue(phone, forKey: "phone_Email_num")
        params.setValue(auth_code, forKey: "auth_code")
        
        
        
        BRequestHandler.shared.get(APIString: "mt", parameters: params as? [String : Any]) { (status, data, msg) in
            if B_ResponseStatus.success == status {
                callback("1111")
            }else{
                callback(nil)
            }
        }
        
    }
    
    //MARK:  1: 普通 2：成功 3： 失败
    static func msg(msg: String,type: MBProgressType) {
        
        DispatchQueue.main.async {
            switch type {
            case .Successful:
                MBMasterHUD.showSuccess(title: msg)
            case .Error:
                MBMasterHUD.showFail(title: msg)
            case .Warning,.Info:
                MBMasterHUD.showInfo(title: msg)
            }
//            let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
//            hud.label.text = msg
//            hud.bezelView.color = .black
//            hud.mode = .customView
//            hud.removeFromSuperViewOnHide = true
//            hud.label.textColor = UIColor(white: 1, alpha: 0.7)
//            hud.hide(animated: true, afterDelay: 2)
            
            
        }
        
    }
    

    
    static func UpLoadProgres(progressNum: CGFloat,hud: MBProgressHUD) {
        print(progressNum)
        if progressNum >= 1 {
            MBMasterHUD.hide {
                MBMasterHUD.showSuccess(title: "上传成功")
            }
            return
        }
            hud.progress = Float(progressNum)
    }

    
    static func loadingHUD(title: String) {
        
        MBMasterHUD.showLoading(title: title)
    }
    
    static func stopLoadingHUD(ok: Bool,callback: @escaping ()-> (),hint:String){
        
        if ok {
            MBMasterHUD.showSuccess(title: hint)
        }else {
            MBMasterHUD.showFail(title: hint)
        }
        MBMasterHUD.hide {
            callback()
        }
    }
    
    /**
     正则表达式获取目的值
     - parameter pattern: 一个字符串类型的正则表达式
     - parameter str: 需要比较判断的对象
     - imports: 这里子串的获取先转话为NSString的[以后处理结果含NS的还是可以转换为NS前缀的方便]
     - returns: 返回目的字符串结果值数组(目前将String转换为NSString获得子串方法较为容易)
     - warning: 注意匹配到结果的话就会返回true，没有匹配到结果就会返回false
     */
    static func regexGetSub(pattern:String, str:String) -> [String] {
        var subStr = [String]()
        let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let results = regex?.matches(in: str, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSMakeRange(0, str.count))
    
        //解析出子串
        for  rst in results! {
            let nsStr = str as  NSString  //可以方便通过range获取子串
            subStr.append(nsStr.substring(with: rst.range))
            //str.substring(with: Range<String.Index>) //本应该用这个的，可以无法直接获得参数，必须自己手动获取starIndex 和 endIndex作为区间
        }
        return subStr
    }
    static func strToByte(str: String) -> [Character]{
        var bytes: [Character] = [Character]()
        for ch in str {
            bytes.append(ch)
        }
        return bytes
    }
    
    //MARK: - 检测是否包含数字
    static func checkHaveNumber(str: String) -> Bool {
        
        let pattern = "[0-9]+"
        let matcher = MyRegex(pattern)
        if matcher.match(input: str) {
            return true
        }
        else{
            return false
        }
    }
    //MARK: - 检测大写字母 包含
    static func checkHaveCapital(str: String) -> Bool {
        
        let pattern = "[A-Z]+"
        let matcher = MyRegex(pattern)
        if matcher.match(input: str) {
            return true
        }
        else{
            return false
        }
    }
    //MARK: - 检测小写字母 包含
    static func checkHaveMinuscule(str: String) -> Bool {
        let pattern = "[a-z]+"
        let matcher = MyRegex(pattern)
        if matcher.match(input: str) {
            return true
        }
        else{
            return false
        }
    }
    //MARK: -  检测是否包含特殊符号
    static func checkHaveSymbol(str: String) -> Bool {
        let pattern = "[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]+"
        let matcher = MyRegex(pattern)
        if matcher.match(input: str) {
            return true
        }
        else{
            return false
        }
    }
    
    /// 根据App.json,返回是不是独立端
    ///
    /// - Returns: 当前是不是独立端
    static func isAlone() -> Bool{
        
        let documentPaths = Bundle.main.bundlePath
        let FileName = String.init(format: "%@/%@", documentPaths,"App.json")
        
        let file = FileHandle.init(forReadingAtPath: FileName)
        let tmpData = file?.readDataToEndOfFile()
        let jsonStr = String(data: tmpData!, encoding: String.Encoding.utf8)
        
        let isAlone = AppAlone.deserialize(from: jsonStr)?.alone
        
        return isAlone == 1 ? true : false
    }
}


// MARK:- 常用按钮颜色
/** 白色*/
let kThemeWhiteColor = UIColor.init(hexString: "0xFFFFFF")
/** 白烟色*/
let kThemeWhiteSmokeColor = UIColor.init(hexString: "0xF5F5F5")
/** 亮灰色*/
let kThemeGainsboroColor = UIColor.init(hexString: "0xF3F4F5")
/**  橙红色*/
let kThemeOrangeRedColor = UIColor.init(hexString: "0xFF4500")
/** 雪白色*/
let kThemeSnowColor = UIColor.init(hexString: "0xFFFAFA")
/** 浅灰色*/
let kThemeLightGreyColor = UIColor.init(hexString: "0xD3D3D3")
/** 深灰色*/
let kThemeGreyColor = UIColor.init(hexString: "0xA9A9A9")
/** 联合国蓝*/
let kThemeTomatoColor = UIColor.init(hexString: "0x5c92e0")
/** 暗灰色*/
let kThemeDimGrayColor = UIColor.init(hexString: "0x696969")
/** 黑色*/
let kThemeBlackColor = UIColor.init(hexString: "0x000000")
/** 沙漠白*/
let kThemeBackgroundColor = UIColor.init(hexString: "0xF4F4F4")
/** 星空灰*/
let kThemeTitielColor = UIColor.init(hexString: "0x9E9E9E")
/** 导航栏默认背景色*/
//let kNaviBarBackGroundColor = UIColor.init(hexString: "#0094f3")

// 屏幕宽度
let kScreenH = UIScreen.main.bounds.height
// 屏幕高度
let kScreenW = UIScreen.main.bounds.width


// MARK:- 常量
struct MetricGlobal {
    static let padding: CGFloat = 10.0
    static let margin: CGFloat = 10.0
}


//适配iPhoneX
let is_iPhoneX = (kScreenW == 375.0 && kScreenH == 812.0 ?true:false)
let kNavibarH: CGFloat = is_iPhoneX ? 88.0 : 64.0
let kTabbarH: CGFloat = is_iPhoneX ? 49.0+34.0 : 49.0
let kStatusbarH: CGFloat = is_iPhoneX ? 44.0 : 20.0
let iPhoneXBottomH: CGFloat = 34.0
let iPhoneXTopH: CGFloat = 24.0



