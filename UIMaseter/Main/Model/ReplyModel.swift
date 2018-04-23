//
//  ReplyModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/24.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class ReplyModel: BaseModel {
    var data: ReplyData?
}
class ReplyListModel: BaseModel {
    var data: [ReplyData]!
}

class ReplyData: BaseData {
    
    var add_time : String!
    var address : String!
    var area_id : Int!
    var block_id : Int!
    var build_uid : Int!
    var city_id : Int!
    var content : String!
    var country_id : Int!
    var group_id : Int!
    var id : Int!
    var index_id : String!
    var invitation_id : Int!
    var last_version : Int!
    var parent_id : Int!
    var pid : Int!
    var praise_num : Int!
    var pro_id : Int!
    var reply : String!
    var reply_id : Int!
    var reply_num : Int!
    var status : Int!
    var topic_id : Int!
    var use_signature : Int!
    var user_authority : Int!
    var user_info : UserInfoData!
    var x_coord : Int!
    var y_coord : Int!

    
    
    /// 缓存行高
    var rowHeight: CGFloat = 0
    
}
