//
//  CodeMode.swift
//  UIDS
//
//  Created by one2much on 2018/1/18.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import HandyJSON

class CodeMode: BaseModel {
    var data: CodeData?
}

class CodeData: HandyJSON {
    
    var code_key: String?
    
    required init() {}
}
