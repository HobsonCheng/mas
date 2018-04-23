//
//  UserInfoModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/16.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class UserInfoModel: BaseModel {
    var data: UserInfoData?
}

class UserInfoData: BaseData {
    
    var birthday : String!
    var explanation : String!
    var gender : Int!
    var head_portrait : String!
    var id : Int!
    var interests : String!
    var labels : String!
    var nick_name : String!
    var pid : Int!
    var signature : String!
    var uid : Int!
    var appkey : String!
    var add_time : String!
    var header : String!
    var status : Int!
    var update_time : String!
    var user_code : String!
    var user_code_code : Int!
    var user_name : String!
    var username_code : Int!
    var zh_name : String!
    
    
    var black_num : Int!
    var browse_num : Int!
    var company_id : Int!
    var email : String!
    var faculty_id : Int!
    var fan_num : Int!
    var follow_num : Int!
    var friend_num : Int!
    var follow_status : Int!
    var is_friend : Int!
    
    var state_last_update : String!
    var trade_id : Int!
    
    
    var relations : [Relation]!
    
    
    var Authorization: String!
    
}
class UserListModel:BaseModel{
    var data: [UserInfoData]?
}
class Relation: BaseData {
    
    var add_time : String!
    var color : String!
    var icon : String!
    var id : Int!
    var num : Int!
    var order_number : Int!
    var pid : Int!
    var relation_name : String!
    var relation_type : Int!
    var relation_url : String!
    var status : Int!
    var uid : Int!
    
}
