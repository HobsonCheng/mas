//
//  BaseNameVC.swift
//  UIMaseter
//
//  Created by gongcz on 2018/4/12.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class BaseNameVC: UIViewController,VCControllerPtc, LoadBlockPtc, LoadEmptyPtc {

    /// 是否可以右滑
    var canRightPan: Bool? = true
    /// 页面唯一标示
    var tagInt: Int?
    /// 弹窗加载框
    lazy var loadBlockView: LoadBlockView? = {
        // 创建LoadVC
        let loadBlockView = LoadBlockView()
        loadBlockView.delegate = self
        return loadBlockView
    }()
    /// 渐入加载界面
    lazy var loadEmptyView: LoadEmptyView? = {
        // 创建LoadVC
        let loadEmptyView = LoadEmptyView()
        loadEmptyView.delegate = self
        return loadEmptyView
    }()
    /// 名称
    var vcName: String?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // 根据时间生成随机VCName
        let curDate: NSDate = NSDate()
        let dateFormatter: DateFormatter = DateFormatter()
        let gregorianLocale: NSLocale = NSLocale(localeIdentifier: NSCalendar.Identifier.gregorian.rawValue)
        dateFormatter.locale = gregorianLocale as Locale?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let curDateText: String = dateFormatter.string(from: curDate as Date)
        let defaultVCName: String = NSString(format: "VCName:%@ %@",curDateText,NSStringFromClass(type(of: self))) as String
        vcName = defaultVCName
        // 默认是支持右滑
        canRightPan = true
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(name vcNameInit: String) {
        super.init(nibName: nil, bundle: nil)
        if vcNameInit.count != 0 {
            vcName = vcNameInit
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appFrame: CGRect = AppInfo.appFrame()
        self.view.frame = CGRect(x: 0, y: 0, width: appFrame.size.width, height: appFrame.size.height)
        self.view.backgroundColor = UIColor(hex: 0xf2f8fb, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startLoadBlock(content: AnyObject, hintText: String) {
        loadBlockView?.show(in: self.view, forConnect: connect as AnyObject, andHint: hintText, andCancel: false)
    }
    
    func startBlockCancel(connect: AnyObject, hintText: String) {
        loadBlockView?.show(in: self.view, forConnect: connect, andHint: hintText, andCancel: true)
    }
    
    func stopLoadBlock() {
        loadBlockView?.dismiss()
        loadBlockView = nil
    }
    
    func startLoadEmpty(content: AnyObject) {
        loadEmptyView?.show(in: self.view, forContext: content)
    }
    
    func loadEmptyError() {
        loadEmptyView?.loadError()
        if loadEmptyView?.isDescendant(of: self.view) == false {
            loadEmptyView?.show(in: self.view, forContext: (loadEmptyView?.context)!)
        }
    }
    
    func stopLoadEmpty() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak loadEmptyView] in
//            self?.loadEmptyView
            loadEmptyView?.dismiss()
        }
    }
    
    func justifyEmptyView(loadEmptyView: LoadEmptyView, inView viewParent: UIView) {
        loadEmptyView.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height)
    }

    func childViewControllerForStatusBarHidden() -> UIViewController? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if appDelegate?.window?.rootViewController == nil {
            return self
        }
        if appDelegate?.window?.rootViewController == self {
            return VCController.getTopVC()
        }
        return nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        if appDelegate?.window?.rootViewController == nil {
            return true
        }
        return false
    }
    
    // MARK: - VCControllerPtc
    // VC即将pop的事件通知
    func vcWillPop() {
    }
    func canGoBack() -> Bool {
        return true
    }
    func doGoBack() {
    }
    func ignoreGesture(_ view: UIView) -> Bool {
        return false
    }
}

// MARK: - 协议
extension BaseNameVC {
    func justifyEmptyView(_ loadEmptyView: LoadEmptyView!, in viewParent: UIView!) {
        
    }
}
