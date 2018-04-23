//
//  UILableUtil.swift
//  UIDS
//
//  Created by one2much on 2018/2/2.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

extension UILabel {
    
    /**
     
     *  多样性字符串处理
     
     *
     
     *  @param original   原始字符串
     
     *  @param conversion 需转换的字符串
     
     *  @param font       字体
     
     *  @param color      颜色
     
     *
     
     *  @return 转换好的字符串
     
     */
    
    func diverseStringOriginalStr(original : String,conversionStr conversion : String,withFont font : UIFont,withColor color : UIColor){
        
        
        
        let range : NSRange = (original as NSString).range(of: conversion as String)
        
        let str = NSMutableAttributedString(string: original as String)
        
        
        
        str.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        
        str.addAttribute(NSAttributedStringKey.font, value: font, range: range)
        
        
        self.attributedText = str
        
    }
    
    /**
     
     *  多样性字符串处理(批量处理)
     
     *
     
     *  @param original   原始字符串
     
     *  @param conversion 需转换的字符串数组
     
     *  @param font       字体
     
     *  @param color      颜色
     
     *
     
     *  @return 转换好的字符串
     
     */
    
    func diverseStringOriginalStr(original : String,conversionStrArr conversionArr : NSArray,withFont font : UIFont,withColor color : UIColor){
        
        
        
        let str = NSMutableAttributedString(string: original as String)
        
        
        
        for subStr in conversionArr{
            
            let range : NSRange = (original as NSString).range(of: subStr as! String)
            
            
            
            str.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
            
            str.addAttribute(NSAttributedStringKey.font, value: font, range: range)
            
        }
        
        
        self.attributedText = str
    }
    
}
