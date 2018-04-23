//
//  FeedbackVC.swift
//  UIDS
//
//  Created by one2much on 2018/2/26.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import SwiftForms
import SwiftyJSON

class FeedbackVC: NaviBarVC {
    
    lazy var formlist: FormViewController = {
        let tmp = FormViewController(style: UITableViewStyle.plain)
        tmp.tableView.tableFooterView = UIView()
        return tmp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar()?.setTitle(title: "意见反馈")
        
        genderUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension FeedbackVC {
    
    fileprivate func genderUI(){
        
        //创建form实例
        let form = FormDescriptor()
        form.title = "意见反馈"
        
        //第一个section分区
        let section1 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        var row: FormRowDescriptor//录入反馈的标题
        
        row = FormRowDescriptor(tag: "1", type: .text, title: "标题")
        row.configuration.cell.appearance = ["textField.placeholder" : "请输入反馈的标题内容" as AnyObject, "textField.textAlignment" : NSTextAlignment.left.rawValue as AnyObject]
        section1.rows.append(row)
        
        
        row = FormRowDescriptor(tag: "2", type: .multilineText, title: "反馈内容")
        section1.rows.append(row)
        
        //第二个section分区
        let section2 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        //提交按钮
        row = FormRowDescriptor(tag: "button", type: .button, title: "提交")
        row.configuration.button.didSelectClosure = { [weak self] _ in
            self?.submit()
        }
        section2.rows.append(row)
        
        form.sections = [section1,section2]
        
        self.formlist.form = form
        
        view.addSubview(formlist.view)
        formlist.view.top = self.naviBar()?.bottom ?? 64
        formlist.view.height = self.view.height - (self.naviBar()?.bottom ?? 64)
    }
    
    private func submit(){
        
        //取消当前编辑状态
        self.view.endEditing(true)
        
        //将表单中输入的内容打印出来
        let message = self.formlist.form.formValues().description
        print(message)
        
        
        let sub_val = JSON.init(self.formlist.form.formValues())
        
        let params = NSMutableDictionary()
        params.setValue(sub_val["1"].description, forKey: "title")
        params.setValue(sub_val["2"].description, forKey: "content")
        
        
        ApiUtil.share.cms_addOpinion(params: params) { (status, data, msg) in
            
            Util.msg(msg: "提交成功", type: .Successful)
            
            let _ = VCController.pop(with: VCAnimationClassic.defaultAnimation())
        }
        
    }
}
