//
//  GroupModel.swift
//  UIDS
//
//  Created by bai on 2018/1/20.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class GroupModel: BaseModel {
    var data: [GroupData]?
}

class GroupData: BaseData {
    
    var add_time : String!
    var add_type : Int!
    var address : String!
    var area_id : Int!
    var attachment : Int!
    var block_id : Int!
    var build_uid : Int!
    var can_out : Int!
    var can_share : Int!
    var can_subscribe : Int!
    var city_id : Int!
    var classify_id : Int!
    var country_id : Int!
    var current_top : Int!
    var group_stencil : Int!
    var group_type : Int!
    var hasSign_in : Int!
    var id : Int!
    var identify : Int!
    var index_id : String!
    var index_pic : String!
    var introduction : String!
    var invitation_authority : Int!
    var invitation_num : Int?
    var invitation_types : String!
    var labels : String!
    var max_bm : Int!
    var max_top : Int!
    var max_user : Int!
    var name : String!
    var name_code : Int!
    var payPerpetual_money : Int!
    var payTemporary_money : String!
    var pay_type : Int!
    var pid : Int!
    var pro_id : Int!
    var replay_authority : Int!
    var reply_authority : Int!
    var score_rule : String!
    var status : Int!
    var update_time : String!
    var use_jurisdiction : Int!
    var user_authority : Int!
    var user_num : Int!
    var x_coord : Int!
    var y_coord : Int!
    
}
