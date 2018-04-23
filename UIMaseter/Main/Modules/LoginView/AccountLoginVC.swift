//
//  AccountLoginVC.swift
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

let kLoginNotification = "kLoginNotification"
class AccountLoginVC: BaseNameVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = kThemeWhiteColor
        view.rx.tapGesture().do(onNext: { [weak self] _ in
            self?.view.endEditing(true)
        }).subscribe().disposed(by: rx.disposeBag)
//
        initEnableMudule()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: 初始化
extension AccountLoginVC: AccountLoginable {
    // MARK:- 初始化 登录 输入框
    func initEnableMudule() {
        
        // 创建 容器组件
        let scrollView = UIScrollView().then {
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }
        
        
        var getCodeKey: String?
        // 创建 协议组件
        let accountField = initAccountField { }
        let passwordField = initPasswordField { }
        let imgCodeView = initImgCodeView(type: "login") { (codekey) in
            getCodeKey = codekey
        }
        //加入 短信验证或者邮箱验证入
        let (smsCodeField,phoneCodeBt) = initSMSCode { }
        
        let (loginBtnView, loginBtn) = initLoginBtnView(showFP: true) { event in print(event.title ?? "") }
        let otherLoginView = initOtherLoginView { event in print(event.title ?? "") }
        
        // 创建 视图模型
        let accountLoginView = HCAccountLoginViewModel(input: (accountField, passwordField, loginBtn, imgCodeView, phoneCodeBt), service: HCAccountLoginService.shareInstance)
        
        accountLoginView.accountUseable.drive(accountField.rx.validationResult).disposed(by: rx.disposeBag)
        accountLoginView.passwordUseable.drive(passwordField.rx.validationResult).disposed(by: rx.disposeBag)
        
        accountLoginView.loginBtnEnable.drive(onNext: { (beel) in
            
            loginBtn.isEnabled = beel
            
        }).disposed(by: rx.disposeBag)
        
        //获取验证码
        accountLoginView.smsBtnEnable.drive(onNext: { (params) in
            if params.object(forKey: "phone_Email_num") != nil {
                let phone = params.object(forKey: "phone_Email_num")
                let auth_code = params.object(forKey: "auth_code")
                
                Util.getSMSCode(type: "login",phone: phone as! String, codekey: getCodeKey!, auth_code: auth_code as! String, callback: { (code) in
                    
                    if code != nil {
                        phoneCodeBt.startTime()
                    }else{
                        phoneCodeBt.isUserInteractionEnabled = true
                        phoneCodeBt.setTitle("获取失败请重试", for: UIControlState.normal)
                    }
                })
            }
            
            
        }).disposed(by: rx.disposeBag)
        
        
        accountLoginView.loginResult.drive(onNext: { (result) in
            
            result.paramsObj.setValue(getCodeKey, forKey: "code_key")
            ApiUtil.share.userLogin(params: result.paramsObj, fininsh: {(status, data, msg) in
                
                Util.msg(msg: "登录成功", type: .Successful)
                
                UserUtil.share.saveUser(userInfo: data)
                NotificationCenter.default.post(name: NSNotification.Name.init(kLoginNotification), object: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let _ = VCController.pop(with: VCAnimationBottom.defaultAnimation())
                }
                
            })
            
        }).disposed(by: rx.disposeBag)
        
        // 添加
        view.addSubview(scrollView)
        scrollView.addSubview(accountField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginBtnView)
        scrollView.addSubview(otherLoginView)
        scrollView.addSubview(imgCodeView)
        scrollView.addSubview(smsCodeField)
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
            make.top.equalTo(accountField.snp.bottom).offset(MetricGlobal.margin * 1)
            make.height.equalTo(Metric.fieldHeight)
            
        }
        smsCodeField.snp.makeConstraints { (make) in
            
            make.left.equalTo(imgCodeView.snp.left)
            make.right.equalTo(imgCodeView.snp.right)
            make.top.equalTo(imgCodeView.snp.bottom).offset(MetricGlobal.margin * 1)
            
            //单纯验证码
            let  auth_code_type = AllRestrictionHandler.share.ucSetCofig.project_set?.login_auth_code_type
        
            if auth_code_type == 0 {//图片验证码
                 make.height.equalTo(0)
            }else if auth_code_type == 1 {
            
                 make.height.equalTo(Metric.fieldHeight)
            }
            
        }
        
        
        passwordField.snp.makeConstraints { (make) in
            make.left.equalTo(smsCodeField.snp.left)
            make.right.equalTo(smsCodeField.snp.right)
            make.top.equalTo(smsCodeField.snp.bottom).offset(MetricGlobal.margin * 1)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        loginBtnView.snp.makeConstraints { (make) in
            make.left.equalTo(accountField.snp.left)
            make.right.equalTo(accountField.snp.right)
            make.top.equalTo(passwordField.snp.bottom).offset(MetricGlobal.margin * 2)
        }
    
        otherLoginView.snp.makeConstraints { (make) in
        
            if kScreenW <= 320 {
                make.left.equalTo(accountField.snp.left).offset(-MetricGlobal.margin * 1)
            } else {
                make.left.equalTo(accountField.snp.left).offset(-MetricGlobal.margin * 2)
            }
            make.centerX.equalToSuperview()
            make.top.equalTo(loginBtnView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        otherLoginView.isHidden = true
        
      
        
    }
    
    
}
