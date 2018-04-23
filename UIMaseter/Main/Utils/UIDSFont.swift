//
//  YJFont.swift
//  YJ
//
//  Created by Hobson on 2018/3/13.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
import UIKit

public extension UITextField {
    
    public func setRightViewYJIcon(icon: YJType, rightViewMode: UITextFieldViewMode = .always, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = .black, backgroundColor: UIColor = .clear, size: CGSize? = nil) {
        FontLoader.loadFontIfNeeded()
        
        let image = UIImage(icon: icon, size: size ?? CGSize(width: 30, height: 30), orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
        let imageView = UIImageView.init(image: image)
        
        self.rightView = imageView
        self.rightViewMode = rightViewMode
    }
    
    public func setLeftViewYJIcon(icon: YJType, leftViewMode: UITextFieldViewMode = .always, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = .black, backgroundColor: UIColor = .clear, size: CGSize? = nil) {
        FontLoader.loadFontIfNeeded()
        let image = UIImage(icon: icon, size: size ?? CGSize(width: 30, height: 30), orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
        let imageView = UIImageView.init(image: image)
        self.leftView = imageView
        self.leftViewMode = leftViewMode
    }
}

public extension UIBarButtonItem {
    
    /**
     To set an icon, use i.e. `barName.YJIcon = YJType.YJGithub`
     */
    func setYJIcon(icon: YJType, iconSize: CGFloat) {
        FontLoader.loadFontIfNeeded()
        let font = UIFont(name: YJStruct.FontName, size: iconSize)
        assert(font != nil, YJStruct.ErrorAnnounce)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .selected)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .highlighted)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .disabled)
        title = icon.text
    }
    
    /**
     To set an icon, use i.e. `barName.setYJIcon(YJType.YJGithub, iconSize: 35)`
     */
    var YJIcon: YJType? {
        set {
            FontLoader.loadFontIfNeeded()
            let font = UIFont(name: YJStruct.FontName, size: 23)
            assert(font != nil,YJStruct.ErrorAnnounce)
            setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
            setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .selected)
            setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .highlighted)
            setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .disabled)
            title = newValue?.text
        }
        get {
            guard let title = title, let index = YJIcons.index(of: title) else { return nil }
            return YJType(rawValue: index)
        }
    }
    
    func setYJText(prefixText: String, icon: YJType?, postfixText: String, size: CGFloat) {
        FontLoader.loadFontIfNeeded()
        let font = UIFont(name: YJStruct.FontName, size: size)
        assert(font != nil, YJStruct.ErrorAnnounce)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .selected)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .highlighted)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .disabled)
        
        var text = prefixText
        if let iconText = icon?.text {
            text += iconText
        }
        text += postfixText
        title = text
    }
}


public extension UIButton {
    
    /**
     To set an icon, use i.e. `buttonName.setYJIcon(YJType.YJGithub, forState: .Normal)`
     */
    func setYJIcon(icon: YJType, forState state: UIControlState) {
        FontLoader.loadFontIfNeeded()
        guard let titleLabel = titleLabel else { return }
        setAttributedTitle(nil, for: state)
        let font = UIFont(name: YJStruct.FontName, size: titleLabel.font.pointSize)
        assert(font != nil, YJStruct.ErrorAnnounce)
        titleLabel.font = font!
        setTitle(icon.text, for: state)
    }
    func setYJIconWithCode(iconCode: String, forState state: UIControlState) {
        FontLoader.loadFontIfNeeded()
        guard let titleLabel = titleLabel else { return }
        setAttributedTitle(nil, for: state)
        let font = UIFont(name: YJStruct.FontName, size: titleLabel.font.pointSize)
        assert(font != nil, YJStruct.ErrorAnnounce)
        titleLabel.font = font!
        let index = iconCode.index(iconCode.startIndex, offsetBy: 2)
        let endIndex = iconCode.index(of: ";") ?? iconCode.endIndex
        let subString = iconCode[index..<endIndex]
        let str = String(subString)
        guard let num = Int(str,radix:16) else{
            return
        }
        if let s = UnicodeScalar(num){
            let value = String(s)
            setTitle(value, for: state)
        }
    }
    /**
     To set an icon, use i.e. `buttonName.setYJIcon(YJType.YJGithub, iconSize: 35, forState: .Normal)`
     */
    func setYJIcon(icon: YJType, iconSize: CGFloat, forState state: UIControlState) {
        setYJIcon(icon: icon, forState: state)
        guard let fontName = titleLabel?.font.fontName else { return }
        titleLabel?.font = UIFont(name: fontName, size: iconSize)
    }
    
    func setYJText(prefixText: String, icon: YJType?, postfixText: String, size: CGFloat?, forState state: UIControlState, iconSize: CGFloat? = nil) {
        setTitle(nil, for: state)
        FontLoader.loadFontIfNeeded()
        guard let titleLabel = titleLabel else { return }
        let attributedText = attributedTitle(for: .normal) ?? NSAttributedString()
        let  startFont =  attributedText.length == 0 ? nil : attributedText.attribute(NSAttributedStringKey.font, at: 0, effectiveRange: nil) as? UIFont
        let endFont = attributedText.length == 0 ? nil : attributedText.attribute(NSAttributedStringKey.font, at: attributedText.length - 1, effectiveRange: nil) as? UIFont
        var textFont = titleLabel.font
        if let f = startFont , f.fontName != YJStruct.FontName  {
            textFont = f
        } else if let f = endFont , f.fontName != YJStruct.FontName  {
            textFont = f
        }
        if let fontSize = size {
            textFont = textFont?.withSize(fontSize)
        }
        var textColor: UIColor = .black
        attributedText.enumerateAttribute(NSAttributedStringKey.foregroundColor, in:NSMakeRange(0,attributedText.length), options:.longestEffectiveRangeNotRequired) {
            value, range, stop in
            if value != nil {
                textColor = value as! UIColor
            }
        }
        
        let textAttributes = [NSAttributedStringKey.font: textFont!, NSAttributedStringKey.foregroundColor: textColor] as [NSAttributedStringKey : Any]
        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttributes)
        
        if let iconText = icon?.text {
            let iconFont = UIFont(name: YJStruct.FontName, size: iconSize ?? size ?? titleLabel.font.pointSize)!
            let iconAttributes = [NSAttributedStringKey.font: iconFont, NSAttributedStringKey.foregroundColor: textColor] as [NSAttributedStringKey : Any]
            
            let iconString = NSAttributedString(string: iconText, attributes: iconAttributes)
            prefixTextAttribured.append(iconString)
        }
        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttributes)
        prefixTextAttribured.append(postfixTextAttributed)
        
        setAttributedTitle(prefixTextAttribured, for: state)
    }
    
    func setYJTitleColor(color: UIColor, forState state: UIControlState = .normal) {
        FontLoader.loadFontIfNeeded()
        
        let attributedString = NSMutableAttributedString(attributedString: attributedTitle(for: state) ?? NSAttributedString())
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSMakeRange(0, attributedString.length))
        
        setAttributedTitle(attributedString, for: state)
        setTitleColor(color, for: state)
    }
}


public extension UILabel {
    
    /**
     To set an icon, use i.e. `labelName.YJIcon = YJType.YJGithub`
     */
    var YJIcon: YJType? {
        set {
            guard let newValue = newValue else { return }
            FontLoader.loadFontIfNeeded()
            let fontAwesome = UIFont(name: YJStruct.FontName, size: self.font.pointSize)
            assert(font != nil, YJStruct.ErrorAnnounce)
            font = fontAwesome!
            text = newValue.text
        }
        get {
            guard let text = text, let index = YJIcons.index(of: text) else { return nil }
            return YJType(rawValue: index)
        }
    }
    
    /**
     To set an icon, use i.e. `labelName.setYJIcon(YJType.YJGithub, iconSize: 35)`
     */
    func setYJIcon(icon: YJType, iconSize: CGFloat) {
        YJIcon = icon
        font = UIFont(name: font.fontName, size: iconSize)
    }
    
    func setYJColor(color: UIColor) {
        FontLoader.loadFontIfNeeded()
        let attributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString())
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: NSMakeRange(0, attributedText!.length))
        textColor = color
    }
    
    func setYJText(prefixText: String, icon: YJType?, postfixText: String, size: CGFloat?, iconSize: CGFloat? = nil) {
        text = nil
        FontLoader.loadFontIfNeeded()
        
        let attrText = attributedText ?? NSAttributedString()
        let startFont = attrText.length == 0 ? nil : attrText.attribute(NSAttributedStringKey.font, at: 0, effectiveRange: nil) as? UIFont
        let endFont = attrText.length == 0 ? nil : attrText.attribute(NSAttributedStringKey.font, at: attrText.length - 1, effectiveRange: nil) as? UIFont
        var textFont = font
        if let f = startFont , f.fontName != YJStruct.FontName  {
            textFont = f
        } else if let f = endFont , f.fontName != YJStruct.FontName  {
            textFont = f
        }
        let textAttribute = [NSAttributedStringKey.font : textFont!]
        let prefixTextAttribured = NSMutableAttributedString(string: prefixText, attributes: textAttribute)
        
        if let iconText = icon?.text {
            let iconFont = UIFont(name: YJStruct.FontName, size: iconSize ?? size ?? font.pointSize)!
            let iconAttribute = [NSAttributedStringKey.font : iconFont]
            
            let iconString = NSAttributedString(string: iconText, attributes: iconAttribute)
            prefixTextAttribured.append(iconString)
        }
        let postfixTextAttributed = NSAttributedString(string: postfixText, attributes: textAttribute)
        prefixTextAttribured.append(postfixTextAttributed)
        
        attributedText = prefixTextAttribured
    }
}


// Original idea from https://github.com/thii/FontAwesome.swift/blob/master/FontAwesome/FontAwesome.swift
public extension UIImageView {
    
    /**
     Create UIImage from YJType
     */
    public func setYJIconWithName(icon: YJType, textColor: UIColor, orientation: UIImageOrientation = UIImageOrientation.down, backgroundColor: UIColor = UIColor.clear, size: CGSize? = nil) {
        FontLoader.loadFontIfNeeded()
        self.image = UIImage(icon: icon, size: size ?? frame.size, orientation: orientation, textColor: textColor, backgroundColor: backgroundColor)
    }
}


public extension UITabBarItem {
    
    public func setYJIcon(icon: YJType, size: CGSize? = nil, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear, selectedTextColor: UIColor = UIColor.black, selectedBackgroundColor: UIColor = UIColor.clear) {
        FontLoader.loadFontIfNeeded()
        let tabBarItemImageSize = size ?? CGSize(width: 30, height: 30)
        
        image = UIImage(icon: icon, size: tabBarItemImageSize, orientation: orientation, textColor: textColor, backgroundColor: backgroundColor).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        selectedImage = UIImage(icon: icon, size: tabBarItemImageSize, orientation: orientation, textColor: selectedTextColor, backgroundColor: selectedBackgroundColor).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        setTitleTextAttributes([NSAttributedStringKey.foregroundColor: textColor], for: .normal)
        setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedTextColor], for: .selected)
    }
}


public extension UISegmentedControl {
    
    public func setYJIcon(icon: YJType, forSegmentAtIndex segment: Int) {
        FontLoader.loadFontIfNeeded()
        let font = UIFont(name: YJStruct.FontName, size: 23)
        assert(font != nil, YJStruct.ErrorAnnounce)
        setTitleTextAttributes([NSAttributedStringKey.font: font!], for: .normal)
        setTitle(icon.text, forSegmentAt: segment)
    }
}


public extension UIStepper {
    
    public func setYJBackgroundImage(icon: YJType, forState state: UIControlState) {
        FontLoader.loadFontIfNeeded()
        let backgroundSize = CGSize(width: 47, height: 29)
        let image = UIImage(icon: icon, size: backgroundSize)
        setBackgroundImage(image, for: state)
    }
    
    public func setYJIncrementImage(icon: YJType, forState state: UIControlState) {
        FontLoader.loadFontIfNeeded()
        let incrementSize = CGSize(width: 16, height: 16)
        let image = UIImage(icon: icon, size: incrementSize)
        setIncrementImage(image, for: state)
    }
    
    public func setYJDecrementImage(icon: YJType, forState state: UIControlState) {
        FontLoader.loadFontIfNeeded()
        let decrementSize = CGSize(width: 16, height: 16)
        let image = UIImage(icon: icon, size: decrementSize)
        setDecrementImage(image, for: state)
    }
}


public extension UIImage {
    
    public convenience init(icon: YJType, size: CGSize, orientation: UIImageOrientation = UIImageOrientation.down, textColor: UIColor = UIColor.black, backgroundColor: UIColor = UIColor.clear) {
        FontLoader.loadFontIfNeeded()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        
        let fontAspectRatio: CGFloat = 1.28571429
        let fontSize = min(size.width / fontAspectRatio, size.height)
        let font = UIFont(name: YJStruct.FontName, size: fontSize)
        assert(font != nil, YJStruct.ErrorAnnounce)
        let attributes = [NSAttributedStringKey.font: font!, NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.backgroundColor: backgroundColor, NSAttributedStringKey.paragraphStyle: paragraph]
        
        let attributedString = NSAttributedString(string: icon.text!, attributes: attributes)
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.draw(in: CGRect(x: 0, y: (size.height - fontSize) * 0.5, width: size.width, height: fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        if let image = image {
            var imageOrientation = image.imageOrientation
            
            if(orientation != UIImageOrientation.down){
                imageOrientation = orientation
            }
            
            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: imageOrientation)
        } else {
            self.init()
        }
    }
    
    public convenience init(bgIcon: YJType, orientation: UIImageOrientation = UIImageOrientation.down, bgTextColor: UIColor = .black, bgBackgroundColor: UIColor = .clear, topIcon: YJType, topTextColor: UIColor = .black, bgLarge: Bool? = true, size: CGSize? = nil) {
        
        let bgSize: CGSize!
        let topSize: CGSize!
        let bgRect: CGRect!
        let topRect: CGRect!
        
        if bgLarge! {
            topSize = size ?? CGSize(width: 30, height: 30)
            bgSize = CGSize(width: 2 * topSize.width, height: 2 * topSize.height)
        } else {
            bgSize = size ?? CGSize(width: 30, height: 30)
            topSize = CGSize(width: 2 * bgSize.width, height: 2 * bgSize.height)
        }
        
        let bgImage = UIImage.init(icon: bgIcon, size: bgSize, orientation: orientation, textColor: bgTextColor)
        let topImage = UIImage.init(icon: topIcon, size: topSize, orientation: orientation, textColor: topTextColor)
        
        if bgLarge! {
            bgRect = CGRect(x: 0, y: 0, width: bgSize.width, height: bgSize.height)
            topRect = CGRect(x: topSize.width/2, y: topSize.height/2, width: topSize.width, height: topSize.height)
            UIGraphicsBeginImageContextWithOptions(bgImage.size, false, 0.0)
        } else {
            topRect = CGRect(x: 0, y: 0, width: topSize.width, height: topSize.height)
            bgRect = CGRect(x: bgSize.width/2, y: bgSize.height/2, width: bgSize.width, height: bgSize.height)
            UIGraphicsBeginImageContextWithOptions(topImage.size, false, 0.0)
            
        }
        
        bgImage.draw(in: bgRect)
        topImage.draw(in: topRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = image {
            var imageOrientation = image.imageOrientation
            
            if(orientation != UIImageOrientation.down){
                imageOrientation = orientation
            }
            
            self.init(cgImage: image.cgImage!, scale: image.scale, orientation: imageOrientation)
        } else {
            self.init()
        }
    }
}

public extension UIViewController {
    var YJTitle: YJType? {
        set {
            FontLoader.loadFontIfNeeded()
            let font = UIFont(name: YJStruct.FontName, size: 23)
            assert(font != nil,YJStruct.ErrorAnnounce)
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: font!]
            title = newValue?.text
        }
        get {
            guard let title = title, let index = YJIcons.index(of: title) else { return nil }
            return YJType(rawValue: index)
        }
    }
}
public extension UISlider {
    
    func setYJMaximumValueImage(icon: YJType, orientation: UIImageOrientation = UIImageOrientation.down, customSize: CGSize? = nil) {
        maximumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25,height: 25), orientation: orientation)
    }
    
    func setYJMinimumValueImage(icon: YJType, orientation: UIImageOrientation = UIImageOrientation.down, customSize: CGSize? = nil) {
        minimumValueImage = UIImage(icon: icon, size: customSize ?? CGSize(width: 25,height: 25), orientation: orientation)
    }
}

private class FontLoader {
    static func loadFontIfNeeded(){
        if (UIFont.fontNames(forFamilyName: YJStruct.FontName).count == 0) {
            
            let bundle = Bundle.main
            let path = bundle.url(forResource: "YJ", withExtension: ".ttf")
            let data = try! Data(contentsOf: path!)
            let provider = CGDataProvider(data: data as CFData)
            let font = CGFont(provider!)
            
            var error: Unmanaged<CFError>?
            
            if CTFontManagerRegisterGraphicsFont(font!, &error) == false {
                let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
                let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
                NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
            }
        }
    }
    
}
private struct YJStruct {
    static let FontName = "iconfont"
    static let ErrorAnnounce = "******  font not found in the bundle or not associated with Info.plist when manual installation was performed. ******"
}
public enum YJType : Int{
    
    static var count : Int{
        return YJIcons.count
    }
    static func getIconText(iconCode:String) -> String{
        let index = iconCode.index(iconCode.startIndex, offsetBy: 2)
        let endIndex = iconCode.index(of: ";") ?? iconCode.endIndex
        let subString = iconCode[index..<endIndex]
        let str = String(subString)
        guard let num = Int(str,radix:16) else{
            return ""
        }
        if let s = UnicodeScalar(num){
            let value = String(s)
            return value
        }
        return ""
    }
    public var text:String?{
        return YJIcons[rawValue]
    }
    
    case forwarBox,//转发
    flower0Pot,//花盆
    volume0,//消息
    home0,//首页
    account,//account
    template,//模板
    personalCenter,//个人中心
    wifi,//信号
    Line3across,//三横
    emoj,//表情2
    guid,//其它_引导
    circle0,//圆
    selected0,//单选选中
    follow,//关注
    message0,//消息
    articles,//文章列表
    work0bench,//工作台
    users,//群组
    bluetooth,//蓝牙
    album,//相册
    appointment,//预约
    settingFundation,//基本设置
    funs2,//粉丝
    edit,//评论
    password2,//密码
    comment,//评论
    users0,//用户群
    home,//首页
    QQ0,//qq
    managePage,//管理页面
    forward,//前进
    page0Manage,//页面管理
    downArrow,//箭头
    grabOrder,//抢单icon
    release,//发布
    grabOrder2,//抢单
    circle0_2,//引导页滑动圆圈
    at,//艾特
    profile0,//基本信息
    weibo0,//微博
    profile,//基本信息
    signal,//信号
    delete,//删除
    news,//资讯
    at3,//艾特
    praise,//点赞
    checked0,//选中
    release0,//发布
    nineBox,//九宫格
    cart,//cart
    settingMenu,//菜单设置
    news2,//资讯
    locate,//定位
    add,//添加
    generateAlbum,//生成相册
    choose0,//单选
    choose0No,//单选_不可选
    charege,//充电
    project0Mange,//项目管理
    menuOff0,//左
    work0Order,//工单
    follow2,//关注
    comment2,//评论 copy
    uploadImage,//上传图片
    box0,//方块
    project0Manage,//项目管理
    YJvor,//粉丝
    home0_2,//home_fill_
    market,//商店
    praised,//点赞
    profile0_2,//基本信息
    users2,//用户组
    edit2,//编辑
    wechat0,//微信
    projectManage,//项目管理
    lauch,//启动
    follow3,//关注
    module,//模板
    funs,//粉丝
    nextArrow,//箭头
    authCode,//验证码
    delete0,//删除
    battery0,//电池1
    settingGloble,//全局设置
    projects0,//项目
    follow4,//关注
    at2,//艾特
    users0_2,//群组
    praise2,//点赞
    slideShow,//轮播图
    weibo,//微博-登录
    password,//password
    setting0SideBar,//侧栏_全局设置
    forwardBox,//转发
    module0Manage,//模块管理
    searchEarth,//地球
    down0,//下
    users3,//群组
    project0,//项目管理
    forward2,//转发
    publish,//发布
    QRCode,//二维码
    comment3,//评论
    QQ,//qq登录
    wechat,//微信登录
    eGrab0Order,//e抢单
    generate,//生成
    appointment2,//预约
    user,//用户名
    setting0,//设置
    appointment3,//预约
    close0,//关闭
    user0,//用户组
    menuSideBar,//侧边栏菜单
    pageManage,//页面管理
    users4,//群组
    searchBar,//搜索框
    topic,//话题
    menu0Show,//不用
    launchPage,//APP启动页
    home2,//首页
    nine0Box,//九宫格
    menuOn,//菜单展开
    menuOff,//菜单收起
    back0forward,//后退撤销
    praised0,//点赞
    person,//观演人
    notebook,//笔记本_1
    release2,//发布
    LinesVertical,//三横
    checkedNo,//未勾选40
    checkedBox,//已勾选40
    grab0Order,//抢单
    grabOrder3,//抢单 (2)
    clear,//清除
    search,//搜索
    quto,//问号
    report,//举报
    authPic,//图片验证码
    authCode2,//验证码2
    back,//返回
    upArrow//上
}

private let YJIcons = ["\u{e634}",
                       "\u{e62d}",
                       "\u{e61a}",
                       "\u{e68d}",
                       "\u{e6b8}",
                       "\u{e68e}",
                       "\u{e60b}",
                       "\u{e695}",
                       "\u{e623}",
                       "\u{e627}",
                       "\u{ea21}",
                       "\u{e626}",
                       "\u{e651}",
                       "\u{e643}",
                       "\u{e681}",
                       "\u{e605}",
                       "\u{e60d}",
                       "\u{e644}",
                       "\u{e6ae}",
                       "\u{e64c}",
                       "\u{e645}",
                       "\u{e61e}",
                       "\u{e646}",
                       "\u{e638}",
                       "\u{e606}",
                       "\u{e63e}",
                       "\u{e618}",
                       "\u{e617}",
                       "\u{e629}",
                       "\u{e62b}",
                       "\u{e608}",
                       "\u{e61d}",
                       "\u{e631}",
                       "\u{e6cb}",
                       "\u{e647}",
                       "\u{e661}",
                       "\u{e6ce}",
                       "\u{e633}",
                       "\u{e603}",
                       "\u{e637}",
                       "\u{e703}",
                       "\u{e614}",
                       "\u{e600}",
                       "\u{e648}",
                       "\u{e650}",
                       "\u{e64a}",
                       "\u{e7eb}",
                       "\u{e64b}",
                       "\u{e6f5}",
                       "\u{e68f}",
                       "\u{e613}",
                       "\u{e64d}",
                       "\u{e7dc}",
                       "\u{e65d}",
                       "\u{e625}",
                       "\u{e62c}",
                       "\u{e62f}",
                       "\u{e60a}",
                       "\u{e639}",
                       "\u{e616}",
                       "\u{e60e}",
                       "\u{e6ee}",
                       "\u{e640}",
                       "\u{e63b}",
                       "\u{e620}",
                       "\u{e658}",
                       "\u{e675}",
                       "\u{e7d8}",
                       "\u{e61f}",
                       "\u{e64e}",
                       "\u{e7ac}",
                       "\u{e619}",
                       "\u{e607}",
                       "\u{e659}",
                       "\u{e604}",
                       "\u{e612}",
                       "\u{e64f}",
                       "\u{e641}",
                       "\u{e652}",
                       "\u{e632}",
                       "\u{e660}",
                       "\u{e68a}",
                       "\u{e615}",
                       "\u{e65c}",
                       "\u{e662}",
                       "\u{e653}",
                       "\u{e69b}",
                       "\u{e654}",
                       "\u{e683}",
                       "\u{e699}",
                       "\u{e67c}",
                       "\u{e82b}",
                       "\u{e663}",
                       "\u{e636}",
                       "\u{e73e}",
                       "\u{e655}",
                       "\u{e7a8}",
                       "\u{e8d7}",
                       "\u{e624}",
                       "\u{e673}",
                       "\u{e656}",
                       "\u{e609}",
                       "\u{e642}",
                       "\u{e61b}",
                       "\u{e62a}",
                       "\u{e630}",
                       "\u{e601}",
                       "\u{e65e}",
                       "\u{e621}",
                       "\u{e649}",
                       "\u{e657}",
                       "\u{e63d}",
                       "\u{e61c}",
                       "\u{e622}",
                       "\u{e60c}",
                       "\u{e65a}",
                       "\u{e67b}",
                       "\u{e635}",
                       "\u{e628}",
                       "\u{e63a}",
                       "\u{e62e}",
                       "\u{e63c}",
                       "\u{e60f}",
                       "\u{e610}",
                       "\u{e602}",
                       "\u{e65b}",
                       "\u{e63f}",
                       "\u{e685}",
                       "\u{e65f}",
                       "\u{e611}",
                       "\u{e666}",
                       "\u{e667}",
                       "\u{e664}",
                       "\u{e665}",
                       "\u{ea22}",
                       "\u{e6c6}",
                       "\u{e72d}",
                       "\u{e668}",
                       "\u{e755}",
                       "\u{e669}",
                       "\u{e679}",
                       "\u{e66a}"
                       ]
