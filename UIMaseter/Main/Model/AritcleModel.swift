//
//  AritcleModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/16.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class AritcleModel: BaseModel {
    
    var data: [TopicData]?
    
}

class ArticleCSSModel :BaseModel{
    var value_info: ArticleCSSData!
    var child_value: ArticleSonCSSData!
}
class ArticleCSSData{
    var border: String!
}
class ArticleSonCSSData{
    
}
