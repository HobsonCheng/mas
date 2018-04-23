//
//  VCControllerPtc.swift
//  UIMaseter
//
//  Created by gongcz on 2018/4/13.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

@objc protocol VCControllerPtc {
    
    /// VC真正被Pop后的回调方法
    @objc optional func vcWillPop()
    
    /**
     *  由于我们自己管理VC Stack的原因，并在iOS6和iOS7上进行全局右滑返回，这个右滑返回是做在App的Window上的，所以对于一些
     *  View如果不希望触发右滑返回，需要实现该方法来进行屏蔽
     *
     *  当触发右滑时，会调用该方法，传入点击的view对象，传入的View也可能是屏蔽右滑的View的子View
     *  该方法需要判断该view是否在不需要右滑的View中，然后进行返回，下面是该方法的一个例子
     *
     *  func viewCanRight(view:UIView) {
     *      if view.isDescendantOfView:listView {
     *          return false
     *      }
     *      else if view.isKindOfClass:InfoButton.class {
     *          return flase
     *      }
     *  }
     *
     */
    ///
    /// - Parameter view: 当触发右滑时，会调用该方法，传入点击的view对象
    /// - Returns: 返回点击的View是否接受右滑返回
    @objc optional func ignoreGesture(_ view: UIView) -> Bool
    
    
    /// 当VC右滑返回或点击返回按钮时，会先调用canGoBack方法来确认VC是否能够返回
    ///
    /// - Returns: 返回当前 VC 是否能进行返回操作
    @objc optional func canGoBack() -> Bool
    
    
    /// 如果canGoBack返回No时，会调用 VC 的 doGoBack 进行处理，通常行为是进行弹框提示
    @objc optional func doGoBack()
}
