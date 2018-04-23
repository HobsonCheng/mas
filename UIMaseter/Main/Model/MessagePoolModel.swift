//
//  MessagePoolModel.swift
//  UIDS
//
//  Created by Hobson on 2018/3/7.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class MessagePoolModel: BaseModel {
    var data : [MessagePoolData]!
}
class MessagePoolData : BaseData{
    var pid : Int?
    var feed_type : Int?
    var object : Dictionary<String,Any>?
}
