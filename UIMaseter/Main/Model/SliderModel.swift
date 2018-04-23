//
//  SliderModel.swift
//  UIDS
//
//  Created by one2much on 2018/2/9.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import HandyJSON

class SliderModel: BaseModel {

    var data: SliderData!
    
}

class SliderData: BaseData {
    
    var mark : String!
    var pics : [Pic]!
    var pid : Int!
    var show_type : Int!
}

class Pic: HandyJSON {
    
    var add_time : String!
    var descriptionField : String!
    var id : Int!
    var index_num : Int!
    var open_type : Int!
    var open_url : String!
    var pic : String!
    var slide_id : Int!
    var status : Int!
    var update_time : String!
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &descriptionField, name: "description")
    }
}
