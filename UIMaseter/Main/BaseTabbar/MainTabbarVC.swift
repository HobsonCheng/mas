//
//  MainTabberVC.swift
//  UIDS
//
//  Created by one2much on 2018/2/11.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

struct TABBER_INFO {
    var pageinfo: PageInfo
    var isNeedVC: Bool
    var isbigshow: Bool
    var index: Int
}

class MainTabbarVC: UITabBarController,MainTabBarDelegate {
    var tarbarConfigArr:[TABBER_INFO]!
    var mainTabBarView: MainTabBarView! //自定义的底部TabbarView
    var tabbarBg : String?
    //MARK: - Life Cycle
    init() {
        //1.调用父类的初始化方法
        super.init(nibName: nil, bundle: nil)
        //2.pagelist
        self.tarbarConfigArr = self.getConfigArrFromPlistFile()
        //3.创建视图控制器
        self.createControllers()
        //4.创建自定义TabBarView
        self.createMainTabBarView()
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
    }
    
    
    
    //MARK: - Private Methods
    private  func  getConfigArrFromPlistFile() ->([TABBER_INFO]?){
        
        //获取pagelist
        //分析
        var configArr = [TABBER_INFO]()
        
        let appinfo = AppInfoData.shared.appModel
        let getConfig = SandboxData.findConfigData(name: "module_TabberView_Tabber_layout", model_id: nil, config_key: (appinfo?.config_key)!)
        
        let tabobj = TabberModel.deserialize(from: getConfig)
        tabbarBg = tabobj?.bg?.bgColor
        
        let pageListinfo = PageListInfo.shared.pageListModel
        
        var bigNum = 10000
        if tabobj?.bigShow ?? false {
            if (pageListinfo?.count)!%2 != 0 {
                bigNum = (((pageListinfo?.count)! + 1)/2)
                bigNum -= 1
            }
        }
        
        var count = 1
        for item in (pageListinfo?.enumerated())! {
            
            let tabber = RootVC()
            tabber.isHomePage = true
            tabber.pageData = item.element
            if (bigNum + 1) == count {
               
                let tmpData = TABBER_INFO(pageinfo: item.element, isNeedVC: false,isbigshow: true,index: count)
                configArr.append(tmpData)
                
            }else{
                let tmpData = TABBER_INFO(pageinfo: item.element, isNeedVC: true,isbigshow: false,index: count)
                configArr.append(tmpData)
            }
            count += 1
        }

        return configArr;
    }
    
    //创建视图控制器
    private func createControllers(){
        
        //初始化导航控制器数组
        var nvcArray = [RootVC]()
        
        for item in self.tarbarConfigArr{
            let viewcontroller = RootVC.init(name: "RootVC_tabber")
            viewcontroller.isHomePage = true
            viewcontroller.pageData = item.pageinfo
            nvcArray.append(viewcontroller)
        }
        //设置标签栏控制器数组
        self.viewControllers = nvcArray
    }
    
    
    //创建自定义Tabbar
    private func createMainTabBarView(){
        //1.获取系统自带的标签栏视图的frame,并将其设置为隐藏
        let tabBarRect = self.tabBar.frame
        self.tabBar.isHidden = true
        //3.使用得到的frame，和plist数据创建自定义标签栏
        mainTabBarView = MainTabBarView(frame: tabBarRect,tabbarConfigArr:tarbarConfigArr!)
        if tabbarBg != nil{
            mainTabBarView.backgroundColor = UIColor.init(hexString: tabbarBg)
        }
        
        mainTabBarView.delegate = self
        self.view.addSubview(mainTabBarView)
    }
    
    //MARK: - MainTabBarDelegate
    func didChooseItem(itemIndex: Int) {
        self.selectedIndex = itemIndex
    }
    
    
}
