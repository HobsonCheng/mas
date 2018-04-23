//
//  String+GetColor.swift
//  UIMaseter
//
//  Created by one2much on 2018/4/23.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

extension String{
    
    /// 将 "255,255,255,0.5" 字符串转换成颜色
    ///
    /// - Parameter color: 格式为"255,255,255,0.5"的rgba字符串
    /// - Returns: 转换得到的颜色
    func toColor() -> UIColor? {
        let arr =  self.split(separator: ",")
        if arr.count < 4{
            return nil
        }
        var arrNew: [CGFloat] = []
        for v in arr{
            let d = Double(String(v))
            arrNew.append(CGFloat(d!))
        }
        return UIColor.init(red: arrNew[0]/255, green: arrNew[1]/255, blue: arrNew[2]/255, alpha: arrNew[3])
    }
}
