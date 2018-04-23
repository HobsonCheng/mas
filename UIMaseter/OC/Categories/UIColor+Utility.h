//
//  UIColor+Utility.h
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//


#import <UIKit/UIKit.h>

#define kUIColorOfHex(color)						[UIColor colorWithHex:(color) alpha:1.0]

@interface UIColor (Utility)

/**
 *  传入int型色值和alpha生成对应UIColor对象
 *
 *  @param hexValue RGB色值
 *  @param alpha    色值 Aplha 通道
 *
 *  @return The color object. The color information represented by this object is in the device RGB colorspace.
 */
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;

/**
 *  传入int型ARGB色值生成对应UIColor对象
 *
 *  @param ARGBValue The integer value of ARGB color. From 0x00000000 to 0xFFFFFFFF.
 *
 *  @return The color object. The color information represented by this object is in the device RGB colorspace.
 */
+ (UIColor *)colorWithARGB:(NSInteger)ARGBValue;

////
+ (UIColor *) colorWithHexString:(NSString *)hexColor;

//@name 使用
//主色：ff2600
+ (UIColor *)MainNavColor;

//底色：f6f6f6
+ (UIColor *)BottomColor;

//背景色： ffffff
+ (UIColor *)backGroundColor;

//部分按钮或配色: ff8401
+ (UIColor *)otherColor;

//字体
//主大标题：2b2b2b
+ (UIColor *)mainTextColor;

//标题：ff2600
+ (UIColor *)titleTextColor;

//有背景色字: ffffff
+ (UIColor *)backGroundTextColor;

//副标题 ： 5a5a5a
+ (UIColor *)FtitleColor;

//内容：bbbbbb
+ (UIColor *)contextColor;

//内容2：888888
+ (UIColor *)contextTwoColor;

//辅色：ffc90d
+ (UIColor *)helpColor;

//辅色2：329ce0
+ (UIColor *)helpTwoColor;
@end

