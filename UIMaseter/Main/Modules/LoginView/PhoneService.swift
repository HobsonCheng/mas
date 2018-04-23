//
//  PhoneService.swift
//  UIDS
//
//  Created by one2much on 2018/1/19.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneService {
    
    let loginBtnEnable: Driver<Bool>
    let loginResult: Driver<Bool>
    let getCodeBtEnable: Driver<Bool>
    let getCodeResult: Driver<NSMutableDictionary>
    
    init(input: (userName: UITextField,codeNum: UITextField,phoneCodeNum: UITextField, loginButton: UIButton,getCodeBt: UIButton), codekey: String) {
        
        let accountDriver = input.userName.rx.text.orEmpty.asDriver()
        let codeDriver = input.codeNum.rx.text.orEmpty.asDriver()
        let phoneCodeDriver = input.phoneCodeNum.rx.text.orEmpty.asDriver()
        let loginButtonDriver = input.loginButton.rx.tap.asDriver()
        let getCodeBtDriver = input.getCodeBt.rx.tap.asDriver()
        
        
        let accountAndPassword = Driver.combineLatest(accountDriver,codeDriver,phoneCodeDriver) {
            return ($0,$1,$2)
        }
        

        loginBtnEnable = accountAndPassword.flatMap({ (user,code,phoneCode) in

            //处理逻辑
            if user.isEmpty || code.isEmpty || phoneCode.isEmpty {
                return Observable.just(false).asDriver(onErrorJustReturn: false)
            }
            return Observable.just(true).asDriver(onErrorJustReturn: false)
        })

        getCodeBtEnable = accountAndPassword.flatMap({ (user,code,phoneCode) in
            
            //处理逻辑
            if user.isEmpty || code.isEmpty {
                return Observable.just(false).asDriver(onErrorJustReturn: false)
            }
            return Observable.just(true).asDriver(onErrorJustReturn: false)
        })
        
        loginResult = loginButtonDriver.withLatestFrom(accountAndPassword).flatMapLatest({ (user,code,phoneCode) in

            //userLoginByPhone   auth_code phone_number code_key
            let params = NSMutableDictionary()
            params.setValue(user, forKey: "phone_number")
            params.setValue(phoneCode, forKey: "auth_code")
            params.setValue(codekey, forKey: "code_key")

            ApiUtil.share.userLoginByPhone(params: params, fininsh: { (status, data,msg) in
              
                Util.msg(msg: "登录成功", type: .Successful)
                
                UserUtil.share.saveUser(userInfo: data)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    VCController.pop(with: VCAnimationBottom.defaultAnimation())
                }

                
            })
            return Observable.just(false).asDriver(onErrorJustReturn: false)
        })
        
        getCodeResult = getCodeBtDriver.withLatestFrom(accountAndPassword).flatMapLatest({ (user,code,phoneCode) in
            
            let dic = NSMutableDictionary()
            dic.setValue(user, forKey: "phone_Email_num")
            dic.setValue(code, forKey: "auth_code")
            
            return Observable.just(dic).asDriver(onErrorJustReturn: NSMutableDictionary())
        })
        
    }
    
}


