//
//  RegVCService.swift
//  UIDS
//
//  Created by one2much on 2018/1/19.
//  Copyright © 2018年 one2much. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//注册发起
class RegVCService {

    let loginBtnEnable: Driver<Bool>
    let loginResult: Driver<Bool>
    
    
    init(input: (userName: UITextField,pwd: UITextField,pwd2: UITextField, nickName: UITextField,codeNum: UITextField, regButton: UIButton,smsInput: UITextField), codekey: String) {
       
        let accountDriver = input.userName.rx.text.orEmpty.asDriver()
        let passwordDriver = input.pwd.rx.text.orEmpty.asDriver()
        let password2Driver = input.pwd2.rx.text.orEmpty.asDriver()
        let nickNameDriver = input.nickName.rx.text.orEmpty.asDriver()
        let codeDriver = input.codeNum.rx.text.orEmpty.asDriver()
        let regButtonDriver = input.regButton.rx.tap.asDriver()
        
        let smsInputDriver = input.smsInput.rx.text.orEmpty.asDriver()
        
        let accountAndPassword = Driver.combineLatest(accountDriver, passwordDriver, password2Driver,nickNameDriver,codeDriver,smsInputDriver) {
            
            return ($0, $1, $2, $3, $4, $5)
        }
        
        
        loginBtnEnable = accountAndPassword.flatMap({ (user,pwd,pwd2,nick,code,smscode) in
        
            if AllRestrictionHandler.share.ucSetCofig.project_set?.regist_auth_code_type == 1 {
                //处理逻辑
                if user.isEmpty || pwd.isEmpty || pwd2.isEmpty || nick.isEmpty || code.isEmpty {
                    return Observable.just(false).asDriver(onErrorJustReturn: false)
                }
            }else{
                //处理逻辑
                if user.isEmpty || pwd.isEmpty || pwd2.isEmpty || nick.isEmpty{
                    return Observable.just(false).asDriver(onErrorJustReturn: false)
                }
            }

            if pwd != pwd2 {
                return Observable.just(false).asDriver(onErrorJustReturn: false)
            }
            
            return Observable.just(true).asDriver(onErrorJustReturn: false)
        })
        
        loginResult = regButtonDriver.withLatestFrom(accountAndPassword).flatMapLatest({ (user,pwd,pwd2,nick,code,smscode) in
            
            let params = NSMutableDictionary()
            params.setValue(user, forKey: "username")
            params.setValue(pwd, forKey: "password")
            params.setValue(nick, forKey: "zh_name")
            if !(smscode.isEmpty) && smscode.count > 0 {
                params.setValue(smscode, forKey: "auth_code")
            }else {
                params.setValue(code, forKey: "auth_code")
            }
            params.setValue(codekey, forKey: "code_key")
            
            ApiUtil.share.userRegist(params: params, fininsh: { (status, data, msg) in
               
                
                Util.msg(msg: "注册成功", type: .Successful)
                
                UserUtil.share.saveUser(userInfo: data)
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    
                    VCController.pop(with: VCAnimationClassic.defaultAnimation())
                };
            })
            

            return Observable.just(false).asDriver(onErrorJustReturn: false)
        })
    
    }
    
}
