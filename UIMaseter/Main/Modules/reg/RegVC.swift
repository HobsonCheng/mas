//
//  RegVC.swift
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


class RegVC: NaviBarVC {
    //MARK: 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar()?.setTitle(title: "注册")
        
        view.backgroundColor = kThemeWhiteColor
        view.rx.tapGesture().do(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).subscribe().disposed(by: rx.disposeBag)
        
        initEnableMudule()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


//MARK:- 初始化
extension RegVC: AccountLoginable {
    
    // MARK: 初始化 登录 输入框
    func initEnableMudule() {
        
        // 创建 容器组件
        let scrollView = UIScrollView().then {
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }
        
        // 创建 协议组件
        let accountField = initOtherField(type: 1, titleStr: "用户名") { }
        let passwordField = initOtherField(type: 2, titleStr: "密码") { }
        let passwordField_2 = initOtherField(type: 2, titleStr: "确认密码") {}
        let nicknameField = initOtherField(type: 3, titleStr: "昵称") {}
        let (regBtnView, regBT) = initRegBtnView { event in print(event ) }
        
        var getcodeo = ""
        weak var tmpimgCodeView: UITextField?
        tmpimgCodeView = UITextField()
        
        //加入 短信验证或者邮箱验证入
        let (smsCodeField,phoneCodeBt) = initSMSCode { }
        //单纯验证码
//        let  auth_code_type = AllRestrictionHandler.share.ucSetCofig.project_set?.regist_auth_code_type
        
        var imgCodeView: UITextField!
//        if auth_code_type == 0 {//图片验证码
//            imgCodeView = initImgCodeView(type: "regist") { [weak self] (codekey) in
//                getcodeo = codekey!
//                let regServise = RegVCService(input: (accountField, passwordField, passwordField_2, nicknameField, tmpimgCodeView!, regBT,UITextField()), codekey: getcodeo)
//
//                regServise.loginBtnEnable.drive(onNext: { (beel) in
//
//                    regBT.isEnabled = beel
//
//                }).disposed(by: (self?.rx.disposeBag)!)
//                regServise.loginResult.drive().disposed(by: (self?.rx.disposeBag)!)
//
//            }
//            tmpimgCodeView = imgCodeView
//        }else if auth_code_type == 1 {
        
            tmpimgCodeView = UITextField()
            imgCodeView = initImgCodeView(type: "regist") { [weak self] (codekey) in
                getcodeo = codekey!
                let regServise = PhoneService(input: (accountField, imgCodeView,smsCodeField, regBT, phoneCodeBt), codekey: getcodeo)
                
                regServise.getCodeBtEnable.drive(onNext: { (beel) in
                    
                    phoneCodeBt.isEnabled = beel
                    if beel{
                        phoneCodeBt.backgroundColor = kNaviBarBackGroundColor
                    }else{
                        phoneCodeBt.backgroundColor = .lightGray
                    }
                }).disposed(by: (self?.rx.disposeBag)!)
                
                regServise.getCodeResult.drive(onNext: { (params) in
                    
                    let phone = params.object(forKey: "phone_Email_num")
                    let auth_code = params.object(forKey: "auth_code")
                    
                    
                    Util.getSMSCode(type: "regist",phone: phone as! String, codekey: codekey!, auth_code: auth_code as! String, callback: { (code) in
                        
                        if code != nil {
                            phoneCodeBt.startTime()
                        }else{
                            phoneCodeBt.isUserInteractionEnabled = true
                            phoneCodeBt.setTitle("获取失败请重试", for: UIControlState.normal)
                        }
                    })
                    
                }).disposed(by: (self?.rx.disposeBag)!)
                
                
                let newregServise = RegVCService(input: (accountField, passwordField, passwordField_2, nicknameField, tmpimgCodeView!, regBT,smsCodeField), codekey: getcodeo)
                
                newregServise.loginBtnEnable.drive(onNext: { (beel) in
                    
                    regBT.isEnabled = beel
                    
                }).disposed(by: (self?.rx.disposeBag)!)
                newregServise.loginResult.drive().disposed(by: (self?.rx.disposeBag)!)
                
            }
            tmpimgCodeView = imgCodeView
//        }
        
        
        
        
        // 添加
        view.addSubview(scrollView)
        scrollView.addSubview(accountField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(passwordField_2)
        scrollView.addSubview(nicknameField)
        scrollView.addSubview(imgCodeView)
        scrollView.addSubview(smsCodeField)
        scrollView.addSubview(regBtnView)
        
        // 布局
        scrollView.snp.makeConstraints { [weak self] (make) in
            make.left.bottom.equalToSuperview()
            make.top.equalTo((self?.naviBar()?.bottom)!)
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
        
        passwordField.snp.makeConstraints { (make) in
            make.left.equalTo(accountField.snp.left)
            make.right.equalTo(accountField.snp.right)
            make.top.equalTo(accountField.snp.bottom).offset(MetricGlobal.margin * 1)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        passwordField_2.snp.makeConstraints { (make) in
            make.left.equalTo(passwordField.snp.left)
            make.right.equalTo(passwordField.snp.right)
            make.top.equalTo(passwordField.snp.bottom).offset(MetricGlobal.margin * 1)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        nicknameField.snp.makeConstraints { (make) in
            make.left.equalTo(passwordField_2.snp.left)
            make.right.equalTo(passwordField_2.snp.right)
            make.top.equalTo(passwordField_2.snp.bottom).offset(MetricGlobal.margin * 1)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        imgCodeView.snp.makeConstraints { (make) in
            
            make.left.equalTo(nicknameField.snp.left)
            make.right.equalTo(nicknameField.snp.right)
            make.top.equalTo(nicknameField.snp.bottom).offset(MetricGlobal.margin * 1)
            if AllRestrictionHandler.share.ucSetCofig.project_set?.regist_auth_code == 1 {
                make.height.equalTo(Metric.fieldHeight)
            }else{
                make.height.equalTo(0)
            }
        }
        
        smsCodeField.snp.makeConstraints { (make) in
            make.left.equalTo(imgCodeView.snp.left)
            make.right.equalTo(imgCodeView.snp.right)
            make.top.equalTo(imgCodeView.snp.bottom).offset(MetricGlobal.margin * 2)
            if AllRestrictionHandler.share.ucSetCofig.project_set?.regist_auth_code_type == 1 {
                make.height.equalTo(Metric.fieldHeight)
            }else{
                make.height.equalTo(0)
            }
        }
        
        regBtnView.snp.makeConstraints { (make) in
            make.left.equalTo(smsCodeField.snp.left)
            make.right.equalTo(smsCodeField.snp.right)
            make.top.equalTo(smsCodeField.snp.bottom).offset(MetricGlobal.margin * 2)
            make.height.equalTo(Metric.fieldHeight)
        }
        
    }
    
}
