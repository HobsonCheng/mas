//
//  HCAccountLoginResult.swift
//  RxXMLY
//
//  Created by sessionCh on 2018/1/3.
//  Copyright © 2018年 sessionCh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

enum HCAccountLoginResult {
    case ok(message:String)
    case empty
    case failed(message:String)
    case params(paramsObj: NSMutableDictionary)
}

extension HCAccountLoginResult {
    var paramsObj: NSMutableDictionary {
        switch self {
        case let .params(paramsObj):
            return paramsObj
        default:
            return NSMutableDictionary()
        }
    }
}

extension HCAccountLoginResult {
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case let .failed(message):
            return message
        case .params:
            return ""
        }
        
    }
}


extension HCAccountLoginResult {
    var borderColor: CGColor {
        switch self {
        case .ok:
            return kThemeGainsboroColor.cgColor
        case .empty:
            return kThemeOrangeRedColor.cgColor
        case .failed:
            return kThemeOrangeRedColor.cgColor
        case .params:
            return kThemeGainsboroColor.cgColor
        }
    }
}

extension Reactive where Base: UITextField {
    var validationResult: Binder<HCAccountLoginResult> {
        return Binder(self.base) { field, result in
            field.layer.borderColor = result.borderColor
        }
    }
}



