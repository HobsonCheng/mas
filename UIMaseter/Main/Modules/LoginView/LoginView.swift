//
//  LoginView.swift
//  UIDS
//
//  Created by one2much on 2018/1/17.
//  Copyright © 2018年 one2much. All rights reserved.
//

//登录模块信息  1.0 原生版本
import UIKit
import Then
import TYPagerController

class LoginView: NaviBarVC {

    var pageVC = TYTabPagerController().then {
        
        $0.pagerController.scrollView?.backgroundColor = kThemeGainsboroColor
        
        // 设置滚动条 属性
        if AllRestrictionHandler.share.ucSetCofig.project_set?.auth_code_login == 1 {
            $0.tabBarHeight = Metric.pagerBarHeight
        }else {
            $0.tabBarHeight = 0
        }
        $0.tabBar.backgroundColor = kThemeWhiteColor
        $0.tabBar.layout.cellWidth = kScreenW * 0.5
        $0.tabBar.layout.progressWidth = Metric.leftTitle.getSize(font: Metric.pagerBarFontSize).width + MetricGlobal.margin * 2
        $0.tabBar.layout.progressHeight = 3.0
        $0.tabBar.layout.cellSpacing = 0
        $0.tabBar.layout.cellEdging = 0
        $0.tabBar.layout.normalTextFont = Metric.pagerBarFontSize
        $0.tabBar.layout.selectedTextFont = Metric.pagerBarFontSize
    }
    
    var titles: [String] = [Metric.leftTitle, Metric.rightTitle]
    var vcs: [BaseNameVC] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.naviBarHead?.setTitle(title: "登录")
//        self.naviBar().setTitle("登录")
        
        self.canRightPan = false
        
        self.initEnableMudule()
        self.initPageController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func goBack(_ sender: AnyObject) {
        let _ = VCController.pop(with: VCAnimationBottom.defaultAnimation())
    }
    
}
