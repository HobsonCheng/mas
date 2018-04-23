//
//  AllRestrictionHandler.swift
//  UIDS
//
//  Created by one2much on 2018/2/7.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

private let shareAHandler = AllRestrictionHandler()

class AllRestrictionHandler: NSObject {

    public var ucSetCofig: AllRestrictionData!
    
    static var share: AllRestrictionHandler {
        return shareAHandler
    }
    
    fileprivate override init() {
        super.init()
        init_ucSetConfig()
    }
    
    func init_ucSetConfig() {
        
        if !SandboxData.isExistUCSetInfo() {
            
            return
        };
        
        let file = FileHandle.init(forReadingAtPath: SandboxData.resoursePathUCSetInfo())
        let tmpData = file?.readDataToEndOfFile()
        let jsonStr = String(data: tmpData!, encoding: String.Encoding.utf8)
        
        self.ucSetCofig = AllRestrictionModel.deserialize(from: jsonStr)?.data
        
    }
    
}


//MARK: - model
class AllRestrictionModel: BaseData {
    
    var code : String!
    var data : AllRestrictionData!
    var key : String!
    var msg : String!
    
}
class AllRestrictionData: BaseData {
    
    var project_set : ProjectSet?
    var regist_qualified : [RegistQualified]?
    var register_agreement : String?

}

class RegistQualified: BaseData {
    
    var add_time : String?
    var id : Int?
    var pid : Int?
    var qualified_content : String?
    var qualified_place : Int?
    var qualified_type : Int?
    var status : Int?
    var update_time : String?
}

class ProjectSet: BaseData {
    
    var auth_code_login : Int?
    var can_login : String?
    var change_password_long : Int?
    var encrypted_set_num : Int?
    var login_auth_code : Int?
    var login_auth_code_before : Int?
    var login_auth_code_type : Int?
    var login_err : String?
    var old_password_num : Int?
    var only_phone : Int?
    var pid : Int?
    var pwd_combination : Int?
    var pwd_condition : String?
    var pwd_min_bit : Int?
    var regist_auth_code : Int?
    var regist_auth_code_before : Int?
    var regist_auth_code_type : Int?
    var regist_condition : String?
    var regist_invite : Int?
    var regist_type : Int?
    var retrieve_password_code : Int?
    var retrieve_password_encrypted_num : Int?
    var retrieve_password_way : String?
    var security_pwd_type : Int?
    
}





