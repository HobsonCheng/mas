//
//  InputValidator.swift
//  UIDS
//
//  Created by one2much on 2018/1/17.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

//验证规则总入口

class InputValidator: NSObject {
    
    
    class func isCheckUsername(username: String) -> Bool {
        
        var ischeck = true
        let regustList = AllRestrictionHandler.share.ucSetCofig.regist_qualified
        if (regustList != nil) &&  (Int((regustList?.count)!)) > 0 {
            
            for itemObj in regustList! {
                //限定位置（0邮箱后缀，1开头内容，2包含内容，3结尾内容）
                if itemObj.status == 0 {
                    let qualified_place = itemObj.qualified_place
                    let contenlist = itemObj.qualified_content?.components(separatedBy: ",") ?? [String]()
        
                    for contentItem in contenlist {
                        
                        if qualified_place == 1 {
                            
                            //^
                            let pattern = "^\(contentItem)"
                            let matcher = MyRegex(pattern)
                            if matcher.match(input: username) {
                                return true
                            }
                            
                        }else if qualified_place == 2 || qualified_place == 0  {
                            
                            //包含
                            let pattern = "\(contentItem)"
                            let matcher = MyRegex(pattern)
                            if matcher.match(input: username) {
                                return true
                            }
                            
                        }else if qualified_place == 3 {
                            
                            //$
                            let pattern = "\(contentItem)$"
                            let matcher = MyRegex(pattern)
                            if matcher.match(input: username) {
                                return true
                            }
                        }
                    }
                }
            }
            
            ischeck = false
        }
        
        return ischeck
    }
    
    class func isValidPhone(phoneNum: String) -> Bool {
        
        if self.isCheckUsername(username: phoneNum) {
            let re = try? NSRegularExpression(pattern: "^[1][3,4,5,6,7,8][0-9]{9}$", options: .caseInsensitive)
            if let re = re{
                let range = NSMakeRange(0, phoneNum.lengthOfBytes(using: String.Encoding.utf8))
                let result = re.matches(in: phoneNum, options: .reportProgress, range: range)
                return result.count > 0
            }
        }
        
        return false
    }
    class func isValidEmail(email: String) -> Bool {
        
        if self.isCheckUsername(username: email) {
        
            let re = try? NSRegularExpression(pattern: "^\\S+@\\S+\\.\\S+$", options: .caseInsensitive)
            
            if let re = re {
                let range = NSMakeRange(0, email.lengthOfBytes(using: String.Encoding.utf8))
                let result = re.matches(in: email, options: .reportProgress, range: range)
                return result.count > 0
            }
            
        }
    
        return false
    }
    
    class func isvalidationPassword(password: String) -> Bool {
        
        //检测密码
        let pwdType = AllRestrictionHandler.share.ucSetCofig.project_set?.pwd_condition
        if pwdType == nil || pwdType == ""{
            return false
        }
        let pwdTypeBeytes = Util.strToByte(str: pwdType!)
        
        let pwd_combination: Int! = AllRestrictionHandler.share.ucSetCofig.project_set?.pwd_combination
        
        
        let Capital = Util.checkHaveCapital(str: password)//包含大写字母
        let Minuscule = Util.checkHaveMinuscule(str: password)//包含小写字母
        let Number = Util.checkHaveNumber(str: password)//包含数字
        let Symbol = Util.checkHaveSymbol(str: password)//包含特殊符号
        
        let pwdLength: Int! = AllRestrictionHandler.share.ucSetCofig.project_set?.pwd_min_bit
        
        
        var pwdOK: Int! = 0
        var allPwdOK: Int! = 0
        
        if pwdTypeBeytes[0] == "1" {//大写字母
            if Capital {
                pwdOK = pwdOK + 1
            }
        }
        if pwdTypeBeytes[1] == "1" {//小写字母
            if Minuscule {
                pwdOK = pwdOK + 1
            }
        }
        if pwdTypeBeytes[2] == "1" {//数字
            if Number {
                pwdOK = pwdOK + 1
            }
        }
        if pwdTypeBeytes[3] == "1" {//特殊符号
            if Symbol {
                pwdOK = pwdOK + 1
            }
        }
    
        
        if Capital {
           allPwdOK = allPwdOK + 1
        }
        if Minuscule {
            allPwdOK = allPwdOK + 1
        }
        if Number {
            allPwdOK = allPwdOK + 1
        }
        if Symbol {
            allPwdOK = allPwdOK + 1
        }
        if allPwdOK >= pwd_combination{
            if (Int(pwd_combination) <= Int(pwdOK)) {
                if (Int(password.count) >= pwdLength) {
                    return true
                }
            }
        }
  
    
        return false
    }
    //MARK: - 是否包含
    class func isValidHave(username: String) -> Bool {
        
        
        
        
        return false
    }
    
}
