//
//  ThridLoginVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/17.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Then
import RxCocoa
import RxSwift
import RxGesture
import NSObject_Rx

class ThridLoginVC: BaseNameVC {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = kThemeWhiteColor
        view.rx.tapGesture().do(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).subscribe().disposed(by: rx.disposeBag)
        
        initEnableMudule()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: 生成页面信息
extension ThridLoginVC: AccountLoginable{
    
    fileprivate func initEnableMudule() {
        
        
        // 创建 容器组件
        let scrollView = UIScrollView().then {
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }
        
        //创建页面信息
        // 创建 协议组件
        let accountField = initAccountField { }
        let (smsCodeField,phoneCodeBt) = initSMSCode { }
        
        let (loginBtnView, loginBtn) = initLoginBtnView(showFP: false) { event in print(event.title ?? "") }
        
        weak var tmpimgCodeView: UITextField?
        tmpimgCodeView = UITextField()
        let extractedExpr = initImgCodeView(type: "login") { [weak self] (codekey) in
            let regServise = PhoneService(input: (accountField, tmpimgCodeView!,smsCodeField, loginBtn, phoneCodeBt), codekey: codekey!)
            
            regServise.loginBtnEnable.drive(onNext: { (beel) in
                
                loginBtn.isEnabled = beel
                
            }).disposed(by: (self?.rx.disposeBag)!)
            regServise.getCodeBtEnable.drive(onNext: { (beel) in
                
                phoneCodeBt.isEnabled = beel
                
            }).disposed(by: (self?.rx.disposeBag)!)
            regServise.loginResult.drive().disposed(by: (self?.rx.disposeBag)!)
            regServise.getCodeResult.drive(onNext: { (params) in
                
                let phone = params.object(forKey: "phone_Email_num")
                let auth_code = params.object(forKey: "auth_code")
                
                
                Util.getSMSCode(type: "phone_login",phone: phone as! String, codekey: codekey!, auth_code: auth_code as! String, callback: { (code) in

                    if code != nil {
                        phoneCodeBt.startTime()
                    }else{
                        phoneCodeBt.isUserInteractionEnabled = true
                        phoneCodeBt.setTitle("获取失败请重试", for: UIControlState.normal)
                    }
                })
                
            }).disposed(by: (self?.rx.disposeBag)!)
        }
        let imgCodeView = extractedExpr
        
        tmpimgCodeView = imgCodeView
        
        // 添加
        view.addSubview(scrollView)
        scrollView.addSubview(accountField)
        scrollView.addSubview(imgCodeView)
        scrollView.addSubview(smsCodeField)
        scrollView.addSubview(loginBtnView)
        
        
        // 布局
        scrollView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(kScreenW)
        }
        
        accountField.snp.makeConstraints { (make) in
            if kScreenW <= 320 {
                make.left.equalToSuperview().offset(MetricGlobal.margin * 2)
            } else {
                make.left.equalToSuperview().offset(MetricGlobal.margin * 3)
            }
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(MetricGlobal.margin * 2)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        imgCodeView.snp.makeConstraints { (make) in
            make.left.equalTo(accountField.snp.left)
            make.right.equalTo(accountField.snp.right)
            make.top.equalTo(accountField.snp.bottom).offset(MetricGlobal.margin * 2)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        smsCodeField.snp.makeConstraints { (make) in
            make.left.equalTo(imgCodeView.snp.left)
            make.right.equalTo(imgCodeView.snp.right)
            make.top.equalTo(imgCodeView.snp.bottom).offset(MetricGlobal.margin * 2)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        
        loginBtnView.snp.makeConstraints { (make) in
            make.left.equalTo(accountField.snp.left)
            make.right.equalTo(accountField.snp.right)
            make.top.equalTo(smsCodeField.snp.bottom).offset(MetricGlobal.margin * 2)
            make.height.equalTo(Metric.fieldHeight)
        }
        
    }
    
}
