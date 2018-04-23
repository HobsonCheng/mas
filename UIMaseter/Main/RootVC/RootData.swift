//
//  RootData.swift
//  UIDS
//
//  Created by one2much on 2018/1/15.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
import SwiftyJSON

extension RootVC {
    
    func initAppInfo(){
        
        //监听结束
        self.esCallBack = { [weak self] in
            self?.mainView?.mj_header.endRefreshing()
            self?.mainView?.mj_footer.endRefreshing()
        }
        
        
        //MARK: 数据刷新
        
        self.updateVC()
        
        //获取数据开启 页面绘制
        self.genderModelList()
        
    }
    
    func findConfigData(name: String,model_id: String) -> NSDictionary{
        return SandboxData.findConfigData(name: name, model_id: model_id, config_key: (self.pageData?.config_key)!)
    }
    func findCSSData(model_id:String) -> NSDictionary?{
        return SandboxData.findCSSData(model_id: model_id, css_key: (self.pageData?.app_css_key)!)
    }
    private func updateVC(){
        
        let navibarJson = JSON.init(parseJSON: (self.pageData?.config_key)!)
        
        for item in navibarJson {//数据拆分
            let configName: String? = String(describing: item.0)
            if ((configName?.range(of: "module_NaviBarView_NaviBar_layout")) != nil){
                
                let navibarLayout = item.1.rawValue
                self.navibar_layout(dic: navibarLayout as! NSDictionary)
                
                
            }
            if ((configName?.range(of: "module_NaviBarView_NaviBar_content")) != nil){
                let navibarContent = item.1.rawValue
                self.navibar_content(dic: navibarContent as! NSDictionary)
            }
        
        }
    
    }
    
    private func navibar_layout(dic: NSDictionary)  {
        
        let bgData = dic.object(forKey: "bg")
        
        let colorStr = (bgData! as! NSDictionary).object(forKey: "bgColor") as! String
        
//        let bgColor = UIColor(hexString: colorStr)

//        self.naviBar()?.naviBarBgColor = bgColor
        StyleUtil.themeBgColor = colorStr
    }
    private func navibar_content(dic: NSDictionary) {
        
        let centerObj = dic["center"]
        self.naviBar()?.setTitle(title: (centerObj as! NSDictionary).object(forKey: "title") as! String)
//        let color = (centerObj as! NSDictionary).object(forKey: "color") as! String
//        self.naviBar()?.titleColor = UIColor.init(hexString: color)
//        StyleUtil.themeFontColor = color
        let leftList = dic["leftList"]
        self.navibar_leftViews(list: leftList as! NSArray)
        let rightList = dic["rightList"]
        self.navibar_rightViews(list: rightList as! NSArray)
        
    }
    
    private func navibar_leftViews(list: NSArray){
        
        var leftlist = [NaviBarItem]()
        //整理
        for (index,item) in list.enumerated() {
            
            let pageData = PageInfo.deserialize(from: item as? NSDictionary)
            
            let left =  NaviBarItem.init(imageSize: CGSize.init(width: 44, height: 22), target: self, action: #selector(RootVC.touchLeft(button:)))
            left.tag = index
            left.setIconImageUrl(with: pageData?.icon ?? "", for: .normal)
            left.setIconImageUrl(with: pageData?.icon_sel ?? "", for: .highlighted)
            
            leftlist.append(left)
        }
        
        self.leftList = list
        
        self.naviBar()?.setLeftBarItems(with: leftlist)
    }
    
    private func navibar_rightViews(list: NSArray){
        
        var rightlist = [NaviBarItem]()
        //整理
        for (index,item) in list.enumerated() {
            
            let pageData = PageInfo.deserialize(from: item as? NSDictionary)
            
            let right = NaviBarItem.init(imageSize: CGSize.init(width: 44, height: 22), target: self, action: #selector(RootVC.touchRight(button:)))
            right.tag = index
            right.setIconImageUrl(with: pageData?.icon ?? "", for: .normal)
            right.setIconImageUrl(with: pageData?.icon_sel ?? "", for: .highlighted)
            
            rightlist.append(right)
        }
        
        self.rightList = list
        
        self.naviBar()?.setRightBarItems(with: rightlist)
    }
    
    
    @objc func touchLeft(button: UIButton) {
        
        let item = self.leftList?.object(at: button.tag)
        
        let itemobj = PageInfo.deserialize(from: item as? NSDictionary)
        
        OpenVC.share.goToPage(pageType: (itemobj?.page_type)!, pageInfo: itemobj)
    }
    @objc func touchRight(button: UIButton) {
        
        let item = self.rightList?.object(at: button.tag)
        
        let itemobj = PageInfo.deserialize(from: item as? NSDictionary)
        
        OpenVC.share.goToPage(pageType: (itemobj?.page_type)!, pageInfo: itemobj)
    }
}
