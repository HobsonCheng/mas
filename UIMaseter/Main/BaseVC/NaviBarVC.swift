//
//  NaviBarVC.swift
//  UIMaseter
//
//  Created by gongcz on 2018/4/12.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

typealias Touchevetion = (_ objct:AnyObject,_ eventType:Int)->()
class NaviBarVC: BaseNameVC {
    
    var naviBarHead: NaviBar?
    var touchleft: Touchevetion?
    var touchright: Touchevetion?
    
    override init() {
        super.init()
        naviBarHead = NaviBar.init(frame: .zero)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        naviBarHead = NaviBar.init(frame: .zero)
    }
//    override init() {
//        super.init()
//        naviBarHead = NaviBar.init(frame: .zero)
//    }
    
    override init(name vcNameInit: String) {
        super.init(name: vcNameInit)
        naviBarHead = NaviBar.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 创建NaviBar
        let vcViewFrame: CGRect = self.view.frame
        naviBarHead?.frame = CGRect(x: 0, y: 0, width: vcViewFrame.size.width, height: CGFloat(kNavigationBarHeight))
        // 创建NaviBar的子界面
        self.setupNaviBarDefaultSubs(naviBarHead!)
        // 添加
        self.view.addSubview(naviBarHead!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupNaviBarDefaultSubs(_ viewParent: NaviBar) {
        // BackItem
        let leftItem = NaviBarItem.init(backTarget: self, action: #selector(goBack(_:)))
        viewParent.setLeftBarItem(with: leftItem)
    }
    
    // 获取Bar
    func naviBar() -> NaviBar? {
        return naviBarHead
    }
    
    @objc func goBack(_ sender: AnyObject) {
        let _ = VCController.pop(with: VCAnimationClassic.defaultAnimation())
    }
    
    // 默认的EmptyView的位置和尺寸
    override func justifyEmptyView(loadEmptyView: LoadEmptyView, inView viewParent: UIView) {
        let naviBarHeight = naviBarHead?.height ?? 64
        loadEmptyView.frame = CGRect(x: 0, y: naviBarHeight, width: self.view.width, height: self.view.height - naviBarHeight)
    }
    
    // MARK: - Navigation
    func navi_centerview(_ items:Array<Any>) {
        
    }

}
