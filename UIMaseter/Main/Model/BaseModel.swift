
//
//  BaseModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import HandyJSON

class BaseModel: HandyJSON {

    var code: String?
    var msg: String?
    
    
    required init() {}
}

class BaseData: HandyJSON {
    
    required init() {}
}

/// 给只需要解析data的json使用
class CommonModel:HandyJSON{
    var data: String?
    var code: String?
    var msg: String?
    
    required init() {}
}
