//
//  ViewController.swift
//  UIMaseter
//
//  Created by one2much on 2018/4/9.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var introView: SwiftIntroView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Util.isAlone(){
            if !SandboxData.isExistUCSetInfo() {
                
                let appinfo = AppInfoData.shared.appModel
                
                let params = NSMutableDictionary()
                params.setValue(appinfo?.app_id, forKey: "pid")
                
                ApiUtil.share.allRestriction(params: params) {(status, data, msg) in
                    
                    //迁移写入指定文件
                    if data != nil {
                        
                        let dataObj = data?.data(using: String.Encoding.utf8)
                        let tmpData: NSMutableData? = NSMutableData()
                        tmpData?.append((dataObj)!)
                        tmpData?.write(toFile: SandboxData.resoursePathUCSetInfo(), atomically: true)
                        AllRestrictionHandler.share.init_ucSetConfig()
                        
                    }
                }
            }
            self.moveTabberIcon()
        }
        //main rootView
        self.startLaunPage()
    }
    func moveTabberIcon() {
        
        if !SandboxData.isExistTabbarIcons() {
            let path = SandboxData.tabbarIconPath()
            
            for index in 1...6{
                
                var path_Name = String.init(format: "tabBar_icon_%d%@.png", index,"@2x")
                var imgData = UIImage.init(named: path_Name)?.sd_imageData()
                let tmpData: NSMutableData? = NSMutableData()
                tmpData?.append((imgData)!)
                let pathstr = "\((path))/\((path_Name))"
                tmpData?.write(toFile: pathstr, atomically: true)
                
                path_Name = String.init(format: "tabBar_icon_%d%@.png", index,"_sel@2x")
                imgData = UIImage.init(named: path_Name)?.sd_imageData()
                let tmpData1: NSMutableData? = NSMutableData()
                tmpData1?.append((imgData)!)
                let pathstr1 = "\((path))/\((path_Name))"
                tmpData1?.write(toFile: pathstr1, atomically: true)
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    func startLaunPage(){
        
        let userDefaults = UserDefaults.standard
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        //根据版本号来判断是否需要显示引导页，一般来说每更新一个版本引导页都会有相应的修改
        let show = userDefaults.bool(forKey: "version_"+version)
        
        if !show  {
            userDefaults.set(true, forKey: "version_"+version)
            userDefaults.synchronize()
        }else{
            
            if Util.isAlone(){
                
                let mainvc = MainVC()
                VCController.push(mainvc, with: nil)
                
            }else {
                if Util.get_defult(key: kIsNeedGotoApp) != nil && (Util.get_defult(key: kIsNeedGotoApp)) as! String == "1" {//主动进入pid
                    
                    let searchapp = AppSearchNavVC()
                    VCController.push(searchapp, with:nil)
                    
                    let mainvc = MainVC()
                    VCController.push(mainvc, with: nil)
                }else {
                    
                    let searchapp = AppSearchNavVC()
                    VCController.push(searchapp, with:nil)
                }
            }
            
            return
        }
        
        introView = SwiftIntroView(frame: self.view.frame)
        introView?.delegate = self
        introView?.backgroundColor = kNaviBarBackGroundColor
        self.view.addSubview(introView!)
        
    }
}

extension ViewController: SwiftIntroViewDelegate{
    func doneButtonClick() {
        if Util.isAlone(){
            
            let mainvc = MainVC()
            VCController.push(mainvc, with: nil)
            
            return
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let searchapp = AppSearchNavVC()
                VCController.push(searchapp, with:nil)
            }
        }
        
        UIView.animate(withDuration: 1, animations: {() -> Void in
            self.introView?.alpha = 0
            
        }) { (finished) -> Void in
            self.introView?.removeFromSuperview()
        }
    }
}
