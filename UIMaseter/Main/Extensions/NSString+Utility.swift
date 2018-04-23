//
//  NSString+Utility.swift
//  UIMaseter
//
//  Created by gongcz on 2018/4/17.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

extension NSString {
    
    // MARK: Encoding
    func getSHA1() -> String? {
        //UnsafeRawPointer
        let data = self.data(using: String.Encoding.utf8.rawValue)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        
        let newData = NSData.init(data: data)
        CC_SHA1(newData.bytes, CC_LONG(data.count), &digest)
        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
    
    func getMD5() -> String? {
        let cStr = self.cString(using: String.Encoding.utf8.rawValue);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    // MARK: Valid
    func isRangeValid(from index: Int, withSize rangeSize: Int) -> Bool {
        let stringLength: Int = self.length
        if (stringLength - index) < rangeSize {
            return false
        } else {
            return true
        }
    }
    // MARK: -- get Random String
    func getRandomString(byLength len: Int) -> String? {
        if len <= 0 {
            return nil
        }
        var data = [UInt8](repeating: 0, count: len)
        var x = 0
        while x < len {
            let i: Int = Int(arc4random_uniform(3))
            if i % 3 == 0 {
                data[x] = UInt8("A".utf8CString.first! + Int8(arc4random_uniform(26)))
                x += 1
            } else if i % 3 == 1 {
                data[x] = UInt8("a".utf8CString.first! + Int8(arc4random_uniform(26)))
                x += 1
            } else {
                data[x] = UInt8("0".utf8CString.first! + Int8(arc4random_uniform(10)))
                x += 1
            }

        }
        return String(bytes: data, encoding: .utf8)
//        return String(bytes: data, encoding: .utf8)
    }
    
    class func getAppGroupID() -> String? {
        //获取Bundle identifier
        let dic = Bundle.main.infoDictionary
        let appName = dic?["CFBundleIdentifier"] as? String
        // 查找第一个点
        let range: NSRange? = (appName as NSString?)?.range(of: ".")
        // 取第一个点及后面的内容
        let subString = (appName as NSString?)?.substring(with: NSRange(location: Int(range?.location ?? 0), length: (appName?.count ?? 0) - Int(range?.location ?? 0)))
        // 连接字符串
        let appGroupName = "group" + (subString ?? "")
        return appGroupName
    }
    
    // TODO:字符串哈希值
    class func hashString(_ data: String?, withSalt salt: String?) -> String? {
        if !(data?.isStringSafe() ?? false) || !(salt?.isStringSafe() ?? false) {
            return nil
        }
        let cKey = salt!.cString(using: .utf8)
        let cData = data!.cString(using: .utf8)
        var cHMAC = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        // 用的OC的库CommonCrypto
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), cKey, strlen(cKey), cData, strlen(cData), &cHMAC)
        var hash: String
        var output = "" /* TODO: .reserveCapacity(CC_SHA256_DIGEST_LENGTH * 2) */
        for i in 0..<CC_SHA256_DIGEST_LENGTH {
//            if let char: UInt8 = cHMAC[Int(i)] {
                output += String(format: "%02x", cHMAC[Int(i)])
//            }
        }
        hash = output
        return hash
    }
    // MARK: String2Date
    func getYYMMDDFWW() -> String? {
        let dateFormatter = DateFormatter()
        let gregorianLocale = NSLocale(localeIdentifier: NSCalendar.Identifier.gregorian.rawValue)
        dateFormatter.locale = gregorianLocale as Locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let searchDate: Date? = dateFormatter.date(from: self as String)
        let gregorianCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var weekday: Int? = nil
        if let aDate = searchDate {
            weekday = gregorianCalendar.ordinality(of: .day, in: .weekday, for: aDate)
        }
        var weekdayText: String? = nil
        switch weekday {
        case 1:
            weekdayText = "星期日"
        case 2:
            weekdayText = "星期一"
        case 3:
            weekdayText = "星期二"
        case 4:
            weekdayText = "星期三"
        case 5:
            weekdayText = "星期四"
        case 6:
            weekdayText = "星期五"
        case 7:
            weekdayText = "星期六"
        default:
            break
        }
        let defaultDateText = "\(self) \(weekdayText ?? "")"
        return defaultDateText
    }
    //隐藏替换部分
    func getHidenPartString() -> String? {
        let range = NSRange(location: 3, length: 4)
        if length < (range.location + range.length) {
            return self as String
        } else {
            return replacingCharacters(in: range, with: "****")
        }
    }
    func isStringSafe() -> Bool {
        return length > 0
    }
    
    // MARK: Trim Space
    func trimSpaceString() -> String? {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
    // MARK: 适配函数
    func size(withFontCompatible font: UIFont?) -> CGSize {
        if responds(to: #selector(size(withAttributes:))) == true && font != nil {
            let dictionaryAttributes = [NSAttributedStringKey.font: font] as [NSAttributedStringKey: AnyObject]
            let stringSize: CGSize = size(withAttributes: dictionaryAttributes)
            return CGSize(width: ceil(stringSize.width), height: ceil(stringSize.height))
        } else {
            return size(withFontCompatible: font, constrainedTo: CGSize(width: CGFloat.greatestFiniteMagnitude, height: (font?.pointSize)!))
        }
    }
    
    func size(withFontCompatible font: UIFont?, forWidth width: CGFloat, lineBreakMode: NSLineBreakMode) -> CGSize {
        if responds(to: #selector(boundingRect(with:options:attributes:context:))) == true && font != nil {
            let dictionaryAttributes = [NSAttributedStringKey.font: font] as [NSAttributedStringKey: AnyObject]
            let stringRect: CGRect = boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .truncatesLastVisibleLine, attributes: dictionaryAttributes, context: nil)
            var widthResult: CGFloat = stringRect.size.width
            if widthResult - width >= 0.0000001 {
                widthResult = width
            }
            return CGSize(width: widthResult, height: ceil(stringRect.size.height))
        } else {
            return size(withFontCompatible: font, constrainedTo: CGSize(width: width, height: .greatestFiniteMagnitude))
        }
    }
    
    func size(withFontCompatible font: UIFont?, constrainedTo size: CGSize) -> CGSize {
        if responds(to: #selector(NSString.boundingRect(with:options:attributes:context:))) == true && font != nil {
            let dictionaryAttributes = [NSAttributedStringKey.font: font] as [NSAttributedStringKey: AnyObject]
            let stringRect: CGRect = boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dictionaryAttributes, context: nil)
            return CGSize(width: ceil(stringRect.size.width), height: ceil(stringRect.size.height))
        } else {
            return .zero
//            return self.size(with: font, constrainedTo: size)
        }
    }
    
    func size(withFontCompatible font: UIFont?, constrainedTo size: CGSize, lineBreakMode: NSLineBreakMode) -> CGSize {
        if responds(to: #selector(NSString.boundingRect(with:options:attributes:context:))) == true && font != nil {
            let dictionaryAttributes = [NSAttributedStringKey.font: font] as [NSAttributedStringKey: AnyObject]
            let stringRect: CGRect = boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dictionaryAttributes, context: nil)
            return CGSize(width: ceil(stringRect.size.width), height: ceil(stringRect.size.height))
        } else {
            return .zero
//            return self.size(with: font, constrainedTo: size, lineBreakMode: lineBreakMode)
        }
    }
    
    func draw(atPointCompatible point: CGPoint, with font: UIFont?) {
        if responds(to: #selector(NSString.draw(at:withAttributes:))) == true && font != nil {
            let dictionaryAttributes = [NSAttributedStringKey.font: font] as [NSAttributedStringKey: AnyObject]
            draw(at: point, withAttributes: dictionaryAttributes)
        } else {
            if let aFont = font {
                draw(at: point, withAttributes: [NSAttributedStringKey.font: aFont])
            }
        }
    }
    func draw(inRectCompatible rect: CGRect, with font: UIFont?) {
        if responds(to: #selector(NSString.draw(with:options:attributes:context:))) == true && font != nil {
            let dictionaryAttributes = [NSAttributedStringKey.font: font] as [NSAttributedStringKey: AnyObject]
            draw(with: rect, options: .usesLineFragmentOrigin, attributes: dictionaryAttributes, context: nil)
        } else {
            if let aFont = font {
                draw(in: rect, withAttributes: [NSAttributedStringKey.font: aFont])
            }
        }
    }
    
    func draw(inRectCompatible rect: CGRect, with font: UIFont?, lineBreakMode: NSLineBreakMode, alignment: NSTextAlignment) {
        if responds(to: #selector(NSString.draw(with:options:attributes:context:))) == true && font != nil {
            let paragraphStyle: NSMutableParagraphStyle? = NSParagraphStyle.default as? NSMutableParagraphStyle
            paragraphStyle?.alignment = alignment
            let dictionaryAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.paragraphStyle: paragraphStyle] as [NSAttributedStringKey: AnyObject]
            draw(with: rect, options: .usesLineFragmentOrigin, attributes: dictionaryAttributes, context: nil)
        } else {
            if let aFont = font {
                draw(in: rect, withAttributes: [NSAttributedStringKey.font : aFont])
            }
        }
    }
    
    // 十六进制转换为普通字符串的
    func string(fromHexString hexString: String?) -> String? {
        let myBuffer = malloc((hexString?.count ?? 0) / 2 + 1) as UnsafeMutableRawPointer
        let bytes = myBuffer.bindMemory(to: CChar.self, capacity: (hexString?.count)!-1)
        bzero(myBuffer, (hexString?.count ?? 0) / 2 + 1)
        var i = 0
        while i < (hexString?.count ?? 0) - 1 {
//            var anInt: UnsafeMutablePointer<UInt32>?
            var anInt: UInt32 = 0
            let hexCharStr = (hexString as NSString?)?.substring(with: NSRange(location: i, length: 2))
            let scanner = Scanner(string: hexCharStr ?? "")
            scanner.scanHexInt32(&anInt)
//            let bufferData = Unmanaged<AnyObject>.fromOpaque(myBuffer).takeRetainedValue()
            bytes[i / 2] = CChar(anInt)
            i += 2
        }
        let utf8String = String(cString: bytes, encoding: .utf8)
        free(myBuffer)
        return utf8String
    }
    //普通字符串转换为十六进制的
    func hexString(from string: String?) -> String? {
        var myD: Data? = string?.data(using: .utf8)
//        var bytes = myD?.bytes as? Byte
        let bytes = myD?.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: myD?.count ?? 0))
        }
        //下面是Byte 转换为16进制。
        var hexStr = ""
        for i in 0..<(myD?.count ?? 0) {
            ///16进制数
            let newHexStr = String(format: "%X", UInt8(bytes![i]) & 0xff)
            if newHexStr.count == 1 {
                hexStr += "0\(newHexStr)"
            } else {
                hexStr += "\(newHexStr)"
            }
        }
        return hexStr
    }
    
    /**
     *  @brief 计算文字的高度
     *
     *  @param font  字体(默认为系统字体)
     *  @param width 约束宽度
     */
    func height(with font: UIFont?, constrainedToWidth width: CGFloat) -> CGFloat {
        let textFont: UIFont? = font != nil ? font : UIFont.systemFont(ofSize: UIFont.systemFontSize)
        var textSize: CGSize
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedStringKey.font: textFont, NSAttributedStringKey.paragraphStyle: paragraph] as [NSAttributedStringKey: AnyObject]
        textSize = boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: attributes, context: nil).size
        return ceil(textSize.height)
    }
    
    /**
     *  @brief 计算文字的宽度
     *
     *  @param font   字体(默认为系统字体)
     *  @param height 约束高度
     */
    func width(with font: UIFont?, constrainedToHeight height: CGFloat) -> CGFloat {
        let textFont: UIFont? = font != nil ? font : UIFont.systemFont(ofSize: UIFont.systemFontSize)
        var textSize: CGSize
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedStringKey.font: textFont, NSAttributedStringKey.paragraphStyle: paragraph] as [NSAttributedStringKey: AnyObject]
        textSize = boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height), options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: attributes, context: nil).size
        return ceil(textSize.width)
    }
    
    /**
     *  @brief 计算文字的大小
     *
     *  @param font  字体(默认为系统字体)
     *  @param width 约束宽度
     */
    func size(with font: UIFont?, constrainedToWidth width: CGFloat) -> CGSize {
        let textFont: UIFont? = font != nil ? font : UIFont.systemFont(ofSize: UIFont.systemFontSize)
        var textSize: CGSize
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedStringKey.font: textFont, NSAttributedStringKey.paragraphStyle: paragraph] as [NSAttributedStringKey: AnyObject]
        textSize = boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: attributes, context: nil).size
        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
    }
    /**
     *  @brief 计算文字的大小
     *
     *  @param font   字体(默认为系统字体)
     *  @param height 约束高度
     */
    func size(with font: UIFont?, constrainedToHeight height: CGFloat) -> CGSize {
        let textFont: UIFont? = font != nil ? font : UIFont.systemFont(ofSize: UIFont.systemFontSize)
        var textSize: CGSize
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedStringKey.font: textFont, NSAttributedStringKey.paragraphStyle: paragraph] as [NSAttributedStringKey: AnyObject]
        textSize = boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height), options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: attributes, context: nil).size
        return CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
    }
    
    
    /**
     *  @brief  反转字符串
     *
     *  @param strSrc 被反转字符串
     *
     *  @return 反转后字符串
     */
    class func reverse(_ strSrc: String?) -> String? {
        var reverseString = String()
        var charIndex: Int = strSrc?.count ?? 0
        while charIndex > 0 {
            charIndex -= 1
            let subStrRange = NSRange(location: charIndex, length: 1)
            reverseString += (strSrc as NSString?)?.substring(with: subStrRange) ?? ""
        }
        return reverseString
    }
    
}
