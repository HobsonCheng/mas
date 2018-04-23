//
//  HCAccountLoginViewModel.swift
//  RxXMLY
//
//  Created by sessionCh on 2018/1/3.
//  Copyright © 2018年 sessionCh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HCAccountLoginViewModel {

    let accountUseable: Driver<HCAccountLoginResult>
    let passwordUseable: Driver<HCAccountLoginResult>
    let codeUseable: Driver<Bool>
    let loginBtnEnable: Driver<Bool>
    let smsBtnEnable: Driver<NSMutableDictionary>
    let loginResult: Driver<HCAccountLoginResult>
    
    init(input: (accountField: UITextField, passwordField: UITextField, loginBtn: UIButton,codeField: UITextField, smsBt: UIButton), service: HCAccountLoginService)  {
        
        let accountDriver = input.accountField.rx.text.orEmpty.asDriver()
        let passwordDriver = input.passwordField.rx.text.orEmpty.asDriver()
        let loginTapDriver = input.loginBtn.rx.tap.asDriver()
        let codeDriver = input.codeField.rx.text.orEmpty.asDriver()
        let smsTapDriver = input.smsBt.rx.tap.asDriver()
        
        accountUseable = accountDriver.skip(1).flatMapLatest { account in
            return service.validationAccount(account).asDriver(onErrorJustReturn: .failed(message: "连接service失败"))
        }
    
        passwordUseable = passwordDriver.skip(1).flatMapLatest { password in
            return service.validationPassword(password).asDriver(onErrorJustReturn: .failed(message: "连接service失败"))
        }
        
        codeUseable = codeDriver.skip(1).flatMapLatest { codeStr in
            return service.chechText(codeStr: codeStr).asDriver(onErrorJustReturn: false)
        }
        
        let accountAndPassword = Driver.combineLatest(accountDriver, passwordDriver, codeDriver) {
            return ($0, $1, $2)
        }
        
        loginBtnEnable = accountAndPassword.flatMap { (account, password,codeStr) in
            return service.loginBtnEnable(account: account, password: password,codeStr: codeStr).asDriver(onErrorJustReturn: false)
        }
        
        let smsEn = Driver.combineLatest(accountDriver,codeDriver) {
            return ($0, $1)
        }
        
        smsBtnEnable = smsTapDriver.withLatestFrom(smsEn).flatMapLatest({ (account, codeStr) in
            if (account.count > 0) && (codeStr.count > 0) {
                let dic = NSMutableDictionary()
                dic.setValue(account, forKey: "phone_Email_num")
                dic.setValue(codeStr, forKey: "auth_code")
                
                return Observable.just(dic).asDriver(onErrorJustReturn: NSMutableDictionary())
            }else {
                
                return Observable.just(NSMutableDictionary()).asDriver(onErrorJustReturn: NSMutableDictionary())
            }
            
        })
        
        
        loginResult = loginTapDriver.withLatestFrom(accountAndPassword).flatMapLatest{ (account, password,codeStr)  in
            return service.login(account: account, password: password, codeStr: codeStr).asDriver(onErrorJustReturn: .failed(message: "连接service失败"))
        }
    }
}
