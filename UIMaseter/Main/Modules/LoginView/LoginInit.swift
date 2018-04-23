//
//  LoginInit.swift
//  UIDS
//
//  Created by one2much on 2018/1/17.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import TYPagerController

// MARK:- 初始化协议
extension LoginView {

    func initEnableMudule() {
        
        if AllRestrictionHandler.share.ucSetCofig.project_set?.regist_type == 1 {
            
        }else {
            //注册 入口
            let loginRegister = NaviBarItem.init(withText: "注册", target: self, action: #selector(LoginView.gotoReg))
            loginRegister.frame = CGRect.init(x: 0, y: 0, width: 50, height: 44)
            self.naviBarHead?.setRightBarItems(with: loginRegister)
        }
    }
    
    //MARK: 分页
    func initPageController() {
        
        // 给 PageTabBar 添加一个底部细线
        let bottomLine = UIView().then {
            $0.backgroundColor = kThemeGainsboroColor
        }
        self.pageVC.tabBar.addSubview(bottomLine)
        
        
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1.0)
        }

        addChildViewController(self.pageVC)
        view.addSubview(self.pageVC.view)
        self.pageVC.didMove(toParentViewController: self)

        self.pageVC.view.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavibarH)
            make.left.right.bottom.equalToSuperview()
        }
        self.pageVC.delegate = self
        self.pageVC.dataSource = self
        self.pageVC.reloadData()
        
        // 设置起始页
        self.pageVC.pagerController.scrollToController(at: 0, animate: false)
        
    }
    

}

//MARK: action
extension LoginView {
    
    @objc public func gotoReg(){
       
        let reg = RegVC.init(name: "reg")
        VCController.push(reg, with: VCAnimationClassic.defaultAnimation())
    }
}
//MARK : page vc deleaget
extension LoginView: TYTabPagerControllerDelegate, TYTabPagerControllerDataSource,TYTabPagerBarDelegate{
    
    func numberOfControllersInTabPagerController() -> Int {
        
        if AllRestrictionHandler.share.ucSetCofig.project_set?.auth_code_login == 1 {
            return self.titles.count
        }else {
            self.titles = [Metric.leftTitle]
            return self.titles.count
        }
    }
    
    func tabPagerController(_ tabPagerController: TYTabPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        
        if index == 0 {
            
            return AccountLoginVC()
        }
        else if index == 1 {
            
            return ThridLoginVC()
        }
        
        let VC = UIViewController()
        VC.view.backgroundColor = kThemeWhiteColor
        return VC
    }
    
    func tabPagerController(_ tabPagerController: TYTabPagerController, titleFor index: Int) -> String {
        return self.titles[index]
    }
}
