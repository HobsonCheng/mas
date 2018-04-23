//
//  MessageModel.swift
//  UIDS
//
//  Created by Hobson on 2018/3/3.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class NotifyModel: BaseModel {
    var data:[NotifyData]!
}
class NotifyData: BaseData{
    var add_time : String!
    var target_name : String!
    var sender_name : String!
    var action_name : String!
    var action_object_name : String!
    var sender: Int!
    var target: Int!
}
class UnreadModel:BaseModel{
    var data : Int!
}
