//
//  MainVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class MainVC: BaseNameVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Util.save_defult(key: kIsNeedGotoApp, value: "1")
        
        self.initTabber();
        
        if UserUtil.isValid() {
            
        }
        
        if (OpenVC.share.pageList != nil) {
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.updataApp()
        }
        
        MsgUtil.shared.showUtil()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: 初始化tabber
    func  initTabber() {
    
        let tabBarController = MainTabbarVC()
        self.addChildViewController(tabBarController);
        self.view.addSubview(tabBarController.view);
    
    }

}


//MARK: - 检测 更新
extension MainVC {
    
    fileprivate func updataApp(){
        
        ApiUtil.share.getProjectVersion(params: NSMutableDictionary()) { (status, data, msg) in
            
            guard let appversion_new = AppVersion.deserialize(from: data)?.data else{
                return
            }
            
            var appversion: Int! = 0
            
            if Util.get_defult(key: kAppVersion) != nil {
                appversion = Int(Util.get_defult(key: kAppVersion) as! String)
            }
            
            
            if appversion_new > appversion {//版本号老了
                
                ZZDiskCacheHelper.getObj(HistoryKey.HistoryKey_Phone) {(obj) in
                    
                    if obj != nil {
                        let tmpobj: String = obj as! String
                        
                        let getObj = ProjectList.deserialize(from: tmpobj) ?? ProjectList(data: [Project]())
                        
                        //处理路基 发现新版本
                        if getObj.data.first != nil {
                            
                            Util.msg(msg: "数据更新了", type: .Info)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                let loading = AssembleVC.init(nibName: "AssembleVC", bundle: nil)
                                loading.pObj = getObj.data.first
                                VCController.push(loading, with: VCAnimationClassic.defaultAnimation())
                            }
                            
                        }
                    }
                }
                
            }
            
        }
        
    }
}

