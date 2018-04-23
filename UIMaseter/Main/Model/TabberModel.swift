
//
//  TabberModel.swift
//  UIDS
//
//  Created by one2much on 2018/1/16.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class TabberModel: ConfigModel {

    var footer_icon: Bool!
    var footer_title: Bool!
    var bigShow: Bool!
    var bg: Tabbar_bg?
}

class Tabbar_style: ConfigModel{
    var fontStyle : Font_style?
}
class Footer_style : ConfigModel{
    var bgcolor : String!
}

class Tabbar_bg: ConfigModel{
    var bgColor : String!
}
class Font_style: BaseData{
    var sel_color : String!
    var nor_color : String!
}
