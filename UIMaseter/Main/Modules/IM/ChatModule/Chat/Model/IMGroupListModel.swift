//
//  IMGroupListModel.swift
//  UIDS
//
//  Created by one2much on 2018/3/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class IMGroupListModel: BaseModel {
    var data: IMGroupItem!
}

class IMGroupItem: BaseData {
    
    var count : Int!
    var groups : [IMGroupData]!
    var start : Int!
    var total : Int!
}

class IMGroupData: BaseData {
    
    var MaxMemberCount : String!
    var appkey : String!
    var avatar : String!
    var ctime : String!
    var desc : String!
    var flag : Int!
    var gid : Int!
    var members_username : AnyObject!
    var mtime : String!
    var name : String!
    var owner_username : String!
    
}
