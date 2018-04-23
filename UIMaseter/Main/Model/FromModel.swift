//
//  FromModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/26.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class FromModel: BaseModel {
    var FormTitles: [FromData]?
    var FormTitle: String?
}

class FromData: BaseData {
    var name: String?
}
