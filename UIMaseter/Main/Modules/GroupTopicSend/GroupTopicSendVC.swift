//
//  GroupTopicSendVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/22.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import TextFieldEffects
import LPDQuoteImagesView
import Qiniu
import MBProgressHUD
import SwiftyJSON

class GroupTopicSendVC: NaviBarVC, LPDQuoteImagesViewDelegate {

    var upLoadNum: Int?
    var pageData: PageInfo?
    var mainScroll: UIScrollView?
    var titleTextF: KaedeTextField?
    var contentTxt: KMPlaceholderTextView?
    var selectPhoto: LPDQuoteImagesView?
    var attechment_value: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar()?.setTitle(title: "发布")

        self.genderNavi()
        
        self.genderRoot()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK:- 导航信息
extension GroupTopicSendVC {

    func genderNavi() {

        let right = NaviBarItem.init(imageSize: CGSize.init(width: 44, height: 22), target: self, action: #selector(GroupTopicSendVC.sendTxt))
        right.tag = NAV_BAR_TYPE.NAV_BAR_TYPE_ADD_TOPOC.rawValue
        right.button?.setYJIcon(icon: .release, forState: .normal)

        self.naviBar()?.setRightBarItems(with: right)
        
    }
    
    @objc func closeVC()  {
        let _ = VCController.pop(with: VCAnimationBottom.defaultAnimation())
    }
    
    @objc func sendTxt() {
        
        if self.titleTextF?.text?.count == 0 {
            
            self.titleTextF?.becomeFirstResponder()
            
            Util.msg(msg: "标题不能为空", type: .Info)
            return
        }
        
        if self.contentTxt?.text.count == 0 {
            
            self.contentTxt?.becomeFirstResponder()
            Util.msg(msg: "随便写点...", type: .Info)
            return
        }
        
        self.view.endEditing(true)
        
        if self.selectPhoto?.selectedPhotos.count == 0 {
            self.goOnSend()
        }else {
            self.upLoadImg { [weak self] in
                self?.goOnSend()
            }
        }
    
    }
    
    func goOnSend()  {
        
        let groupData: GroupData = self.pageData?.anyObj as! GroupData
        
        let params = NSMutableDictionary()
        params.setValue(groupData.name, forKey: "name")
        params.setValue(groupData.id, forKey: "cms_group_id")
        params.setValue(self.titleTextF?.text, forKey: "title")
        params.setValue(self.titleTextF?.text, forKey: "summarize")
        params.setValue(self.contentTxt?.text, forKey: "content")
        params.setValue(self.attechment_value, forKey: "attachment_value")
        params.setValue(groupData.pid, forKey: "group_pid")
        
        self.startLoadBlock(content: "请稍等" as AnyObject, hintText: "发布中...")
        ApiUtil.share.addInvitation(params: params) { [weak self] (status, data, msg) in
            
            self?.stopLoadBlock()
            
            Util.msg(msg: "发布成功", type: .Successful)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                self?.reloadPreviousList()
                let _ = VCController.pop(with: VCAnimationBottom.defaultAnimation())
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.stopLoadBlock()
        }
        
    }
    //刷新前一个页面的数据
//    func reloadPreviousList() {
//        let preVC = VCController.getPreviousWith(self) as! RootVC
//        let subViews = preVC.mainView?.subviews
//        for view in subViews!{
//            if view is TopicList{
//                let list = view as! TopicList
//                _ = list.reloadViewData()
//            }
//        }
//    }
    
}

extension GroupTopicSendVC {
    
    func genderRoot() {
        
        self.mainScroll = UIScrollView.init(frame: CGRect.init(x: 0, y: self.naviBar()?.bottom ?? 64, width: self.view.width, height: self.view.height - (self.naviBar()?.height ?? 64)))
        self.view.addSubview(self.mainScroll!)
        
        
        //标题
        let textField = KaedeTextField(frame: CGRect.init(x: 0, y: 0, width: self.view.width, height: 40))
        textField.placeholderColor = UIColor.white
        
        textField.backgroundColor = UIColor.white
        textField.placeholder = "加个标题呦...（点我）"
        self.mainScroll?.addSubview(textField)
        self.titleTextF = textField
        
        //生成文本输入信息
        let placeholderTextView = KMPlaceholderTextView(frame: CGRect.init(x: 0, y: textField.bottom + 0.5, width: self.view.width, height: 150))
        placeholderTextView.placeholder = "来吧，尽情发挥吧..."
        placeholderTextView.font = UIFont.systemFont(ofSize: 15)
        
        
        self.mainScroll?.addSubview(placeholderTextView)
        self.contentTxt = placeholderTextView
        self.contentTxt?.becomeFirstResponder()
        
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: placeholderTextView.bottom + 0.5, width: self.view.width, height: 280))
        bgView.backgroundColor = UIColor.white
        self.mainScroll?.addSubview(bgView)
        
        //添加图片
        let photoImg = LPDQuoteImagesView.init(frame: CGRect.init(x: 10, y: 0, width: self.view.width-20, height: 280), withCountPerRowInView: 4, cellMargin: 10)
        photoImg?.navcDelegate = self
        photoImg?.isShowTakePhotoSheet = true
        photoImg?.maxSelectedCount = 9
        bgView.addSubview(photoImg!)
        
        self.selectPhoto = photoImg
        
        if (self.mainScroll?.height)! > bgView.bottom {
            self.mainScroll?.contentSize = CGSize.init(width: 0, height: (self.mainScroll?.height)! + 1)
        }else{
            self.mainScroll?.contentSize = CGSize.init(width: 0, height: bgView.bottom)
        }
        
    }
    
}


//MARK: - 上传图片
extension GroupTopicSendVC {
    
    func upLoadImg(callback: @escaping () -> ())  {
        let hud = MBMasterHUD.showProgress(view: self.view, title: "上传中...")
        UploadImageTool.uploadImages(imageArray: self.selectPhoto?.selectedPhotos as! [UIImage], progress: { [weak self] (msg,propress) in
            Util.UpLoadProgres(progressNum: CGFloat(propress), hud: hud)
        }, success: { [weak self] (obj) in
            
            for item in obj {
                if self?.attechment_value != nil {
                    self?.attechment_value = String.init(format: "%@,%@", (self?.attechment_value)!,item as! CVarArg)
                }else {
                    self?.attechment_value = item as? String
                }
            }
            
            hud.progress = 1
            
            callback()
        }) {_ in
            
        }
    
    }
}

