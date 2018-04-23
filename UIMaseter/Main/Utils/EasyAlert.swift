//
//  EasyAlert.swift
//  UIDS
//
//  Created by Hobson on 2018/3/30.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

/** EasyAlert的action信息类 */
class AlertActionInfo{
    /** action的title */
    var title:String?
    /** action的style */
    var style:UIAlertActionStyle?
    /** action的回调 */
    var actionClosure:((UIAlertAction)->())?
    init(title:String?,style:UIAlertActionStyle?,actionClosure:((UIAlertAction)->())?) {
        self.title = title
        self.style = style
        self.actionClosure = actionClosure
    }
}

class EasyAlert {
    fileprivate var alertVC : UIAlertController?
    
    /// 创建和展示UIAlertController和Action
    ///
    /// - Parameters:
    ///   - title: alertVc的title
    ///   - message: alertVc的message
    ///   - style: alertVc的样式
    ///   - actionInfos: alertVc中action的信息
    static func showAlertVC(title:String?,message:String?,style:UIAlertControllerStyle,actionInfos:[AlertActionInfo]){
        let vc = UIAlertController(title:title, message: message, preferredStyle: style)
        
        for actionInfo in actionInfos{
            let action = UIAlertAction.init(title: actionInfo.title ?? "title", style: actionInfo.style ?? .cancel, handler: actionInfo.actionClosure)
            vc.addAction(action)
        }
        VCController.getTopVC()?.present(vc, animated: true, completion: nil)
    }
}
