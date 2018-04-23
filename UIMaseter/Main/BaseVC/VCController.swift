//
//  VCController.swift
//  UIMaseter
//
//  Created by gongcz on 2018/4/16.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

// MARK: -
fileprivate struct VCStyle {
    static let maxRightGuestureTouchWidth: CGFloat          = 44
    static let maxValidGuestureMoveWidth: CGFloat           = 20
}

// MARK: -
class VCController: NSObject, UIGestureRecognizerDelegate {
    /// VC堆栈
    fileprivate var arrayVCSubs: Array<UIViewController>?
    /// 根ViewdeController
    var rootBaseVController: BaseNameVC?
    /// 根View
    var rootBaseView: UIView?
    
    /// 视野宽度
    var spotWidth: CGFloat?
    /// 是否在滑动中
    var isPaning: Bool? = false
    /// 上一次滑动的坐标
    var lastGuestPoint: CGPoint?
    /// 向右滑动的距离
    var rightMoveLenght: CGFloat?
    /// 遮罩
    var maskView: UIView?
    
    private static let globalVCController: VCController = VCController()
    class func mainVCC() -> VCController {
        return globalVCController
    }
    
    override init() {
        super.init()
        let rootBaseVCController = BaseNameVC()
        rootBaseVCController.view.frame = CGRect(x: 0, y: 0, width: AppInfo.appFrame().size.width, height: AppInfo.appFrame().size.height)
        rootBaseVCController.view.backgroundColor = .white
        self.rootBaseVController = rootBaseVCController
        self.rootBaseView = rootBaseVCController.view
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let window = appDelegate.window
        window?.addSubview(rootBaseView!)
        window?.rootViewController = rootBaseVCController
        
        let maskView = UIView(frame: AppInfo.appFrame())
        maskView.backgroundColor = .clear
        self.maskView = maskView
        /// 视野范围默认设置为屏幕size(!!!所有的VCSize的宽度必须保持和spotWidth保持一致，否者无法处理动画效果)
        self.spotWidth = AppInfo.appFrame().size.width
    }
    
    /// 还原
    func goOriginal() {
        let frontVC = VCController.mainVCC().arrayVCSubs?.last
        var backVC: BaseNameVC? = nil
        let vcCount = VCController.mainVCC().arrayVCSubs?.count ?? 0
        if vcCount >= 2 {
            backVC = VCController.mainVCC().arrayVCSubs?[vcCount-2] as? BaseNameVC
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            backVC?.view.setViewX(-VCController.mainVCC().spotWidth!/3)
            frontVC?.view.setViewX(0)
        }) { (finished) in
            backVC?.view.setViewX(0)
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    /// 注意需要横划操作的控件需要在这里添加例外
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let translatedPoint: CGPoint = touch.location(in: gestureRecognizer.view)
        if translatedPoint.x > VCStyle.maxRightGuestureTouchWidth {
            return false
        }
//        guard let _ = touch.view else {
//            return false
//        }
//        let topVC: BaseNameVC? = VCController.getTopVC()
        // TODO: 没用到的类
//        if ((touch.view!).isKind(of: NSClassFromString("Switch")!)) {
//            return false
//        }
//        else if (touch.view!.superview?.isKind(of: NSClassFromString("FilterCheckSlider")) ) {
//            return false
//        } else if (touch.view?.superview is NSClassFromString("FilterRedioSlider")) {
//            return false
//        } else
//        if topVC != nil && (topVC?.responds(to: NSSelectorFromString("ignoreGesture:")))! {
////            return topVC!.ignoreGesture(touch.view)
//        }
        return true
    }
    
    @objc func handlePan(from recognizer: UIPanGestureRecognizer?) {
        let vcCount: Int = VCController.mainVCC().arrayVCSubs?.count ?? 0
        if vcCount < 2 {
            // 只有2个或以下的VC时不允许进行右滑操作,因为有emptyVC所以加一个
            return
        }
        
        let frontVC: BaseNameVC? = VCController.mainVCC().arrayVCSubs?.last as? BaseNameVC
        if !(frontVC?.canRightPan ?? true) {
            return
        }
        
        let backVC: BaseNameVC? = VCController.mainVCC().arrayVCSubs?[vcCount-2] as? BaseNameVC
//        if !isPaning! {
//            // 初始化backVC的状态
//        }
        spotWidth = backVC?.view.frame.size.width
        lastGuestPoint = CGPoint(x: 0, y: 0)
        rightMoveLenght = 0
        backVC?.view.setViewX(-(spotWidth!/3))
        VCController.globalVCController.maskView?.removeFromSuperview()
        backVC?.view.addSubview(VCController.globalVCController.maskView!)
        //        [[[VCController mainVCC] rootBaseView] insertSubview:[backVC view] belowSubview:[frontVC view]];
        
        // 手势进行中
        if recognizer?.state == .began || recognizer?.state == .changed {
            if recognizer?.state == .began {
                isPaning = true
            }
            var translatedPoint: CGPoint = (recognizer?.translation(in: recognizer?.view))!
            if translatedPoint.x < 0 {
                translatedPoint.x = 0
            } else if translatedPoint.x > spotWidth! {
                translatedPoint.x = spotWidth ?? 0
            }
            
            if translatedPoint.x >= lastGuestPoint!.x { // 向右滑动
                if translatedPoint.x >= lastGuestPoint!.x { // 相同方向
                    rightMoveLenght! += translatedPoint.x-lastGuestPoint!.x
                }
                else { // 不同方向
                    rightMoveLenght! = translatedPoint.x - lastGuestPoint!.x
                }
            }
            else { // 向左滑动
                if rightMoveLenght! <= 0 { // 相同方向
                    rightMoveLenght! += translatedPoint.x - lastGuestPoint!.x
                }
                else { // 不同方向
                    rightMoveLenght = translatedPoint.x - lastGuestPoint!.x
                }
            }
            
            lastGuestPoint = translatedPoint
            
            // 调整frontVC和BackVC的位置
            let frontPosNew: CGFloat = translatedPoint.x
            let backPosNew: CGFloat = (-spotWidth!+translatedPoint.x)/3
            backVC?.view.setViewX(backPosNew)
            frontVC?.view.setViewX(frontPosNew)
        }
        
        if recognizer?.state == .ended || recognizer?.state == .cancelled || recognizer?.state == .failed {
            isPaning = false
            self.maskView?.removeFromSuperview()
            // 当向左滑动超过一定距离的时候
            if rightMoveLenght! < -VCStyle.maxValidGuestureMoveWidth {
                // 归位
                self.goOriginal()
            }
            else if frontVC!.view.left > spotWidth!/2 { // 滑动超过一半
                if (frontVC?.conforms(to: VCControllerPtc.self))! { // 是否额外控制了返回
                    let frontVCTmp: BaseNameVC = frontVC!
                    var isDoNormal: Bool = true
                    // 是否走普通返回模式
                    if frontVCTmp.responds(to: NSSelectorFromString("canGoBack")) {
                        let canGoBack: Bool = frontVCTmp.canGoBack()
                        if !canGoBack {
                            isDoNormal = false
                            self.goOriginal()
                            // 是否
                            if frontVCTmp.responds(to: NSSelectorFromString("doGoBack")) {
                                frontVCTmp.doGoBack()
                            }
                        }
                    }
                    
                    // 如果是走普通模式
                    if isDoNormal {
                        // 动画
                        UIApplication.shared.beginIgnoringInteractionEvents()
                        VCController.mainVCC().removeVC(frontVC)
                        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {() -> Void in
                            frontVC?.view.setViewX(self.spotWidth!)
                            backVC?.view.setViewX(0)
                        }, completion: {(_ finished: Bool) -> Void in
                            frontVC?.view.removeFromSuperview()
                            backVC?.viewWillAppear(true)
                            backVC?.viewDidAppear(true)
                            
                            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                            // 恢复VC的可用性
                            UIApplication.shared.endIgnoringInteractionEvents()
                        })
                        // 处理额外的事情
                        frontVCTmp.doGoBack()
                    }

                }
                else {
                    // 动画
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    self.removeVC(frontVC)
                    UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {() -> Void in
                        frontVC?.view.setViewX(self.spotWidth!)
                        backVC?.view.setViewX(0)
                    }, completion: {(_ finished: Bool) -> Void in
                        frontVC?.view.removeFromSuperview()
                        backVC?.viewWillAppear(true)
                        backVC?.viewDidAppear(true)
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                        // 恢复VC的可用性
                        UIApplication.shared.endIgnoringInteractionEvents()
                    })
                }
            }
            else {
                self.goOriginal() // 归为
            }
            rightMoveLenght = 0
            lastGuestPoint = .zero
        }
    }
    
    // 通知VC事件并从栈里删除VC
    func removeVC(_ removeVC: BaseNameVC?) {
        if removeVC != nil {
            removeVC?.vcWillPop()
            if let aVC = removeVC {
                while let elementIndex = self.arrayVCSubs!.index(of: aVC) { self.arrayVCSubs!.remove(at: elementIndex) }
            }
        }
    }
    
    // 获取节点
    class func getVC(_ vcName: String?) -> BaseNameVC? {
        // 获取window的子VC
        if VCController.mainVCC().arrayVCSubs != nil {
            let subsCount: Int = VCController.mainVCC().arrayVCSubs!.count
            // 从上往下逐个遍历
            for i in 0..<subsCount {
                let viewController = VCController.mainVCC().arrayVCSubs![subsCount - i - 1]
                // 只有BaseNameVC才支持此功能
                if (viewController is BaseNameVC) == true {
                    let baseNameVC = viewController as? BaseNameVC
                    // 名称相同
                    if baseNameVC?.vcName == vcName {
                        return baseNameVC
                    }
                }
            }
        }
        return nil
    }
    
    // 获取最下层的
    class func getTopVC() -> BaseNameVC? {
        // 获取window的子VC
        if VCController.mainVCC().arrayVCSubs != nil {
            let subsCount: Int = VCController.mainVCC().arrayVCSubs!.count
            if subsCount > 0 {
                let baseNameVC = VCController.mainVCC().arrayVCSubs![subsCount - 1] as? BaseNameVC
                return baseNameVC
            }
        }
        return nil
    }
    
    // 获取节点的下一层节点
    class func getPreviousWith(_ baseNameVC: BaseNameVC?) -> BaseNameVC? {
        if baseNameVC == nil {
            return nil
        }
        // 获取window的子VC
        if VCController.mainVCC().arrayVCSubs != nil {
            let subsCount: Int = VCController.mainVCC().arrayVCSubs!.count
            // 从上往下逐个遍历
            for i in 0..<subsCount {
                let viewController = VCController.mainVCC().arrayVCSubs![subsCount - i - 1]
                // 只有BaseNameVC才支持此功能
                if (viewController is BaseNameVC) == true {
                    let nameVC = viewController as? BaseNameVC
                    // 名称相同
                    if nameVC == baseNameVC {
                        if i + 1 < subsCount {
                            return VCController.mainVCC().arrayVCSubs![subsCount - i - 2] as? BaseNameVC
                        }
                    }
                }
            }
        }
        return nil
    }
    // 获取最下层的
    class func getHomeVC() -> BaseNameVC? {
        // 获取window的子VC
        if VCController.mainVCC().arrayVCSubs != nil {
            let subsCount: Int = VCController.mainVCC().arrayVCSubs!.count
            if subsCount > 0 {
                let baseNameVC = VCController.mainVCC().arrayVCSubs![0] as? BaseNameVC
                return baseNameVC
            }
        }
        return nil
    }
    
    // 压入节点
    class func push(_ baseNameVC: BaseNameVC?, with animation: VCAnimationPtc?) {
//        let getname = baseNameVC?.vcName
//        let gettopname = VCController.getTopVC()?.vcName
//            if ([getname isEqualToString:gettopname]) {
//                return;
//            }
        // 加载View
//        if baseNameVC?.isViewLoaded == false {
//            let _ = baseNameVC?.view
//        }
        // 注册手势
        if (baseNameVC?.canRightPan)! {
            let gesture = UIPanGestureRecognizer(target: VCController.mainVCC(), action: #selector(handlePan(from:)))
            gesture.delegate = VCController.mainVCC()
            gesture.maximumNumberOfTouches = 1
            baseNameVC?.view.addGestureRecognizer(gesture)
        }
        // 往window中添加子VC
        if VCController.mainVCC().arrayVCSubs != nil {
            let subsCount: Int = VCController.mainVCC().arrayVCSubs!.count
            if subsCount > 0 {
                // 当前最前面的VC
                let baseNameVCTop = VCController.mainVCC().arrayVCSubs![subsCount - 1] as? BaseNameVC
                if animation != nil {
                    baseNameVCTop?.viewWillDisappear(true)
                    if baseNameVC != nil {
                        if let aVC = baseNameVC {
                            VCController.mainVCC().arrayVCSubs!.append(aVC)
                        }
                    }
                    // 设置新的根节点
                    if let aView = baseNameVC?.view {
                        VCController.mainVCC().rootBaseView?.addSubview(aView)
                    }
                    let originFrame: CGRect? = baseNameVCTop?.view.frame
                    // 动画
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    animation?.push(fromTopVC: baseNameVCTop!, toArrive: baseNameVC!, with: {(_ finished: Bool) -> Void in
                        baseNameVCTop?.view.frame = originFrame!
                        //                                       [[baseNameVCTop view] removeFromSuperview];
                        baseNameVCTop?.viewDidDisappear(true)
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                        // 恢复VC的可用性
                        UIApplication.shared.endIgnoringInteractionEvents()
                    })
                } else {
                    baseNameVCTop?.viewWillDisappear(false)
                    if let aVC = baseNameVC {
                        VCController.mainVCC().arrayVCSubs!.append(aVC)
                    }
                    // 设置新的根节点
                    baseNameVC?.view.setViewX(0)
                    if let aView = baseNameVC?.view {
                        VCController.mainVCC().rootBaseView?.addSubview(aView)
                    }
                    // 移除上一个VC
                    //                [[baseNameVCTop view] removeFromSuperview];
                    baseNameVCTop?.viewDidDisappear(false)
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                }
            }
        } else {
            // 添加到队列中
            let arrayVCSubsNew = [UIViewController]()
            VCController.mainVCC().arrayVCSubs = arrayVCSubsNew
            if let aVC = baseNameVC {
                VCController.mainVCC().arrayVCSubs?.append(aVC)
            }
            // 设置根VC
            baseNameVC?.view.setViewX(0)
            if let aView = baseNameVC?.view {
                VCController.mainVCC().rootBaseView?.addSubview(aView)
            }
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // 弹出节点
    class func pop(with animation: VCAnimationPtc?) -> Bool {
        if VCController.mainVCC().arrayVCSubs != nil {
            let subsCount: Int = VCController.mainVCC().arrayVCSubs!.count
            if subsCount > 1 {
                // 获取顶层的VC
                let baseNameVCTop = VCController.mainVCC().arrayVCSubs![subsCount - 1] as? BaseNameVC
                // 下一个VC
                let baseNameVCTopNew = VCController.mainVCC().arrayVCSubs![subsCount - 2] as? BaseNameVC
                if animation != nil {
                    VCController.mainVCC().removeVC(baseNameVCTop)
                    //                [[[VCController mainVCC] rootBaseView] addSubview:[baseNameVCTopNew view]];
                    // 动画
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    animation?.pop(fromTopVC: baseNameVCTop!, toArrive: baseNameVCTopNew!, with: {(_ finished: Bool) -> Void in
                        baseNameVCTop?.view.removeFromSuperview()
                        baseNameVCTopNew?.viewWillAppear(true)
                        baseNameVCTopNew?.viewDidAppear(true)
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                        // 恢复VC的可用性
                        UIApplication.shared.endIgnoringInteractionEvents()
                    })
                } else {
                    // 获取顶层的VC
                    let baseNameVCTop = VCController.mainVCC().arrayVCSubs![subsCount - 1] as? BaseNameVC
                    // 从逻辑数组中删除VC
                    VCController.mainVCC().removeVC(baseNameVCTop)
                    baseNameVCTop?.view.removeFromSuperview()
                    // 下一个VC
                    let baseNameVCTopNew = VCController.mainVCC().arrayVCSubs![subsCount - 2] as? BaseNameVC
                    baseNameVCTopNew?.view.setViewX(0)
                    //                [[[VCController mainVCC] rootBaseView] addSubview:[baseNameVCTopNew view]];
                    baseNameVCTopNew?.viewDidAppear(false)
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                }
                return true
            }
        }
        return false
    }
    
    // 弹出节点
    class func pop(toVC vcName: String?, with animation: VCAnimationPtc?) -> Bool {
        if VCController.mainVCC().arrayVCSubs != nil {
            let subsCount: Int = VCController.mainVCC().arrayVCSubs!.count
            // 从上往下逐个遍历
            var i = subsCount - 1
            while i >= 0 {
                let baseNameVCTopNew = VCController.mainVCC().arrayVCSubs![i] as? BaseNameVC
                if (baseNameVCTopNew?.vcName == vcName) == true {
                    // pop到当前VC，不做任何动作
                    if i == subsCount - 1 {
                        return true
                    }
                    // 获取顶层的VC
//                    let baseNameVCTop = VCController.mainVCC().arrayVCSubs![subsCount - 1] as? BaseNameVC
                    if animation != nil {
                        // 最上层节点
                        let baseNameVCTop = VCController.mainVCC().arrayVCSubs![subsCount - 1] as? BaseNameVC
                        // 从逻辑数据中删除目标节点之前的节点和其对应的maskView
                        var j = subsCount - 2
                        while j > i {
                            let baseNameVCTmp = VCController.mainVCC().arrayVCSubs![j] as? BaseNameVC
                            VCController.mainVCC().removeVC(baseNameVCTmp)
                            baseNameVCTmp?.view.removeFromSuperview()
                            j -= 1
                        }
                        // 添加VC
                        VCController.mainVCC().removeVC(baseNameVCTop)
                        //                    [[[VCController mainVCC] rootBaseView] addSubview:[baseNameVCTopNew view]];
                        baseNameVCTopNew?.viewWillAppear(true)
                        // 动画
                        UIApplication.shared.beginIgnoringInteractionEvents()
                        animation?.pop(fromTopVC: baseNameVCTop!, toArrive: baseNameVCTopNew!, with: {(_ finished: Bool) -> Void in
                            baseNameVCTop?.view.removeFromSuperview()
                            baseNameVCTopNew?.viewDidAppear(true)
                            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                            // 恢复VC的可用性
                            UIApplication.shared.endIgnoringInteractionEvents()
                        })
                    } else {
                        baseNameVCTopNew?.viewWillAppear(false)
                        // 循环删除目标节点之前的节点
                        var j = subsCount - 1
                        while j > i {
                            let baseNameVCTmp = VCController.mainVCC().arrayVCSubs![j] as? BaseNameVC
                            // 从逻辑数据中删除
                            VCController.mainVCC().removeVC(baseNameVCTmp)
                            // 当前的根节点
                            baseNameVCTmp?.view.removeFromSuperview()
                            j -= 1
                        }
                        // 设置新的根节点
                        baseNameVCTopNew?.view.setViewX(0)
                        //                    [[[VCController mainVCC] rootBaseView] addSubview:[baseNameVCTopNew view]];
                        baseNameVCTopNew?.viewDidAppear(false)
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                    }
                    return true
                }
                i -= 1
            }
        }
        return false
    }
    
    // 弹出节点然后压入节点
    class func popThenPush(_ baseNameVC: BaseNameVC?, with animation: VCAnimationPtc?) -> Bool {
        // 加载View
//        if baseNameVC?.isViewLoaded == false {
//            let _ = baseNameVC?.view
//        }
        // 注册手势
        if (baseNameVC?.canRightPan)! {
            let gesture = UIPanGestureRecognizer(target: VCController.mainVCC(), action: #selector(handlePan(from:)))
            gesture.delegate = VCController.mainVCC()
            gesture.maximumNumberOfTouches = 1
            baseNameVC?.view.addGestureRecognizer(gesture)
        }
        if VCController.mainVCC().arrayVCSubs != nil {
            let subsCount: Int = VCController.mainVCC().arrayVCSubs!.count
            if subsCount > 1 {
                // 获取顶层的VC
                let baseNameVCTop = VCController.mainVCC().arrayVCSubs![subsCount - 1] as? BaseNameVC
                if animation != nil {
                    VCController.mainVCC().removeVC(baseNameVCTop)
                    // 设置新的根节点
                    if let aVC = baseNameVC {
                        VCController.mainVCC().arrayVCSubs?.append(aVC)
                    }
                    if let aView = baseNameVC?.view {
                        VCController.mainVCC().rootBaseView?.addSubview(aView)
                    }
                    // 动画
                    UIApplication.shared.beginIgnoringInteractionEvents()
                    animation?.push(fromTopVC: baseNameVCTop!, toArrive: baseNameVC!, with: {(_ finished: Bool) -> Void in
                        baseNameVCTop?.view.removeFromSuperview()
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                        // 恢复VC的可用性
                        UIApplication.shared.endIgnoringInteractionEvents()
                    })
                } else {
                    // 从逻辑数据中删除
                    VCController.mainVCC().removeVC(baseNameVCTop)
                    // 设置新的根节点
                    if let aVC = baseNameVC {
                        VCController.mainVCC().arrayVCSubs?.append(aVC)
                    }
                    if let aView = baseNameVC?.view {
                        VCController.mainVCC().rootBaseView?.addSubview(aView)
                    }
                    baseNameVCTop?.view.removeFromSuperview()
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                }
                return true
            } else if subsCount == 1 {
                VCController.push(baseNameVC, with: animation)
            } else {
                if let aVC = baseNameVC {
                    VCController.mainVCC().arrayVCSubs?.append(aVC)
                }
                if let aView = baseNameVC?.view {
                    VCController.mainVCC().rootBaseView?.addSubview(aView)
                }
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            // 添加到队列中
            let arrayVCSubsNew = [UIViewController]()
            VCController.mainVCC().arrayVCSubs = arrayVCSubsNew
            if let aVC = baseNameVC {
                VCController.mainVCC().arrayVCSubs?.append(aVC)
            }
            // 设置根VC
            baseNameVC?.view.setViewX(0)
            if let aView = baseNameVC?.view {
                VCController.mainVCC().rootBaseView?.addSubview(aView)
            }
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
        return false
    }
    
    // 弹出节点然后压入节点
    class func pop(toVC vcName: String?, thenPush baseNameVC: BaseNameVC?, with animation: VCAnimationPtc?) -> Bool {
        // 加载View
//        if baseNameVC?.isViewLoaded == false {
//            let _ = baseNameVC?.view
//        }
        // 注册手势
        if baseNameVC!.canRightPan! {
            let gesture = UIPanGestureRecognizer(target: VCController.mainVCC(), action: #selector(handlePan(from:)))
            gesture.delegate = VCController.mainVCC()
            gesture.maximumNumberOfTouches = 1
            baseNameVC?.view.addGestureRecognizer(gesture)
        }
        if VCController.mainVCC().arrayVCSubs != nil {
            let subsCount: Int = VCController.mainVCC().arrayVCSubs!.count
            // 从上往下逐个遍历
            var i = subsCount - 1
            while i >= 0 {
                let baseNameVCBackNew = VCController.mainVCC().arrayVCSubs![i] as? BaseNameVC
                // 名称相同
                if baseNameVCBackNew?.vcName == vcName {
                    if i == subsCount - 1 {
                        // 跳转到当前VC，则直接Push即可
                        self.push(baseNameVC, with: animation)
                        return true
                    }
                    // 最上层节点
                    let baseNameVCTop = VCController.mainVCC().arrayVCSubs![subsCount - 1] as? BaseNameVC
                    if animation != nil {
                        // 从逻辑数据中删除目标节点之前的节点
                        var j = subsCount - 2
                        while j > i {
                            let baseNameVCTmp = VCController.mainVCC().arrayVCSubs![j] as? BaseNameVC
                            VCController.mainVCC().removeVC(baseNameVCTmp)
                            baseNameVCTmp?.view.removeFromSuperview()
                            j -= 1
                        }
                        VCController.mainVCC().removeVC(baseNameVCTop)
                        // 将新界面入栈
                        if let aVC = baseNameVC {
                            VCController.mainVCC().arrayVCSubs?.append(aVC)
                        }
                        if let aView = baseNameVC?.view {
                            VCController.mainVCC().rootBaseView?.addSubview(aView)
                        }
                        // 动画
                        UIApplication.shared.beginIgnoringInteractionEvents()
                        animation?.push(fromTopVC: baseNameVCTop!, toArrive: baseNameVC!, with: {(_ finished: Bool) -> Void in
                            baseNameVCTop?.view.removeFromSuperview()
                            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                            // 恢复VC的可用性
                            UIApplication.shared.endIgnoringInteractionEvents()
                        })
                    } else {
                        // 循环删除目标节点之前的节点
                        var j = subsCount - 1
                        while j > i {
                            let baseNameVCTmp = VCController.mainVCC().arrayVCSubs![j] as? BaseNameVC
                            VCController.mainVCC().removeVC(baseNameVCTmp)
                            baseNameVCTmp?.view.removeFromSuperview()
                            j -= 1
                        }
                        // 删除当前首节点
                        VCController.mainVCC().removeVC(baseNameVCTop)
                        baseNameVCTop?.view.removeFromSuperview()
                        // 将Push进来的VC Add到view上
                        baseNameVC?.view.setViewX(0)
                        if let aVC = baseNameVC {
                            VCController.mainVCC().arrayVCSubs?.append(aVC)
                        }
                        if let aView = baseNameVC?.view {
                            VCController.mainVCC().rootBaseView?.addSubview(aView)
                        }
                        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
                    }
                    // 已完成，跳出循环
                    return true
                }
                i -= 1
            }
        } else {
            // 添加到队列中
            let arrayVCSubsNew = [UIViewController]()
            VCController.mainVCC().arrayVCSubs = arrayVCSubsNew
            if let aVC = baseNameVC {
                VCController.mainVCC().arrayVCSubs?.append(aVC)
            }
            // 设置根VC
            baseNameVC?.view.setViewX(0)
            if let aView = baseNameVC?.view {
                VCController.mainVCC().rootBaseView?.addSubview(aView)
            }
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
        return false
    }
    
    // 弹出到最下层的VC然后压入节点
    class func popToHomeVC(with animation: VCAnimationPtc?) -> Bool {
        return VCController.pop(toVC: VCController.getHomeVC()?.vcName, with: animation)
    }
    // 弹出到最下层的VC然后压入节点
    class func pop(toHomeVCThenPush baseNameVC: BaseNameVC?, with animation: VCAnimationPtc?) -> Bool {
        return VCController.pop(toVC: VCController.getHomeVC()?.vcName, thenPush: baseNameVC, with: animation)
    }
    
}
