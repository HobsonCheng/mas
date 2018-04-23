//
//  IMUserModel.swift
//  UIDS
//
//  Created by one2much on 2018/3/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class IMUserModel: BaseModel {
    var data: IMUserData!
}

class IMUserData: BaseData {
    var add_time : String!
    var admin : Int!
    var header : String!
    var id : Int!
    var name_code : Int!
    var nick_name : String!
    var password : String!
    var pid : Int!
    var status : Int!
    var uid : Int!
    var user_name : String!
    var ji_name: String!
}
