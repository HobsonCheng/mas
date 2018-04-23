//
//  BaseModuleView.swift
//  UIDS
//
//  Created by one2much on 2018/1/22.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class BaseModuleView: UIView {
    
    open var pageData: PageInfo!
    open var model_code: String!
    open var refreshCB: VCRefreshCallBack?
    open var refreshES: VCRefreshCallBack?
    
    //MARK: - 下拉刷新
    open func reloadViewData()-> Bool { return false }
    

}
