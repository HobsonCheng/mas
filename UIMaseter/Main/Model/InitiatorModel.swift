//
//  InitiatorModel.swift
//  UIDS
//
//  Created by one2much on 2018/2/12.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class InitiatorModel: BaseModel {
    var data: [InitiatorData]!
}

class InitiatorData: BaseData {
    var ad_down_url : String!
    var ad_icon : String!
    var ad_schema : String!
    var apply_type : Int!
    var descriptionField : String!
    var icon : String!
    var index_num : Int!
    var ios_app_id : String!
    var ios_down_url : String!
    var ios_icon : String!
    var ios_schema : String!
    var name : String!
    var page_info : PageInfo!
    var url : String!
}
