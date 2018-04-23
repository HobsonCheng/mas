//
//  MainTabBarView.swift
//  UIDS
//
//  Created by one2much on 2018/2/11.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

//自定义标签栏代理协议
protocol MainTabBarDelegate {
    func didChooseItem(itemIndex:Int)
}

class MainTabBarView: UIView {
    var delegate:MainTabBarDelegate? //代理,点击item
    var itemArray:[MainTabBarItem] = [] //标签Item数组
    var tabbarStyle : Tabbar_style?
    init(frame: CGRect,tabbarConfigArr:[TABBER_INFO]) {
        super.init(frame: frame)
        getTabbarStyle()
        let screenW = UIScreen.main.bounds.size.width
        let itemWidth = screenW / CGFloat(tabbarConfigArr.count)
        for i in 0..<tabbarConfigArr.count{
            let itemDic = tabbarConfigArr[i];
            let itemFrame = CGRect(x: itemWidth * CGFloat(i) , y: 0, width: itemWidth, height: frame.size.height)
            //创建Item视图
            let itemView = MainTabBarItem(frame: itemFrame, itemDic:itemDic, itemIndex: i,tabbarStyle: self.tabbarStyle)
            self.addSubview(itemView)
            self.itemArray.append(itemView)
            //添加事件点击处理
            itemView.tag = i
            itemView.addTarget(self, action:#selector(self.didItemClick(item:))  , for: UIControlEvents.touchUpInside)
            
            //默认点击第一个,即首页
            if i == 0 {
                self .didItemClick(item: itemView)
            }
        }
    }
    
    private func getTabbarStyle(){
        let appinfo = AppInfoData.shared.appModel
        //获取和设置tabbar栏的背景色
        let getBgColor = SandboxData.findConfigData(name: "productFooter_module_bg_104", model_id: nil, config_key: (appinfo?.config_key)!)
        let getTabbarBg = Footer_style.deserialize(from: getBgColor)
        if getTabbarBg == nil{
            self.backgroundColor = UIColor.white
        }else{
            self.backgroundColor =  UIColor.init(hexString: getTabbarBg?.bgcolor ?? "#ffffff")
        }
        
        //获取tabbarItem的样式
        let getTabbarItemStyle = SandboxData.findConfigData(name: "module_TabberView_Tabber_content", model_id: nil, config_key: (appinfo?.config_key)!)
        self.tabbarStyle = Tabbar_style.deserialize(from: getTabbarItemStyle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //点击单个标签视图，通过currentSelectState的属性观察器更新标签的显示
    //并且通过代理方法切换标签控制器的当前视图控制器
    @objc func didItemClick(item:MainTabBarItem){
        for i in 0..<itemArray.count{
            let tempItem = itemArray[i]
            if i == item.tag{
                tempItem.currentSelectState = true
            }else{
                tempItem.currentSelectState = false
            }
        }
        //执行代理方法
        self.delegate?.didChooseItem(itemIndex: item.tag)
    }
}
