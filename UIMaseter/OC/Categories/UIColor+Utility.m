//
//  UIColor+Utility.m
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "UIColor+Utility.h"


@implementation UIColor (Utility)

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithARGB:(NSInteger)ARGBValue
{
    return [UIColor colorWithRed:((float)((ARGBValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((ARGBValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(ARGBValue & 0xFF))/255.0
                           alpha:((float)((ARGBValue & 0xFF000000) >> 24)) / 255.0];
}

+ (UIColor *) colorWithHexString:(NSString *)hexColor
{
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }else if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

//主色：ff2600
+ (UIColor *)MainNavColor{
    return [UIColor colorWithHex:0xff2600 alpha:1.0];
}

//底色：f6f6f6
+ (UIColor *)BottomColor{
    return [UIColor colorWithHex:0xf6f6f6 alpha:1.0];
}

//背景色： ffffff
+ (UIColor *)backGroundColor{
    return [UIColor colorWithHex:0xffffff alpha:1.0];
}

//部分按钮或配色: ff8401
+ (UIColor *)otherColor{
    return [UIColor colorWithHex:0xff8401 alpha:1.0];
}

//字体
//主大标题：2b2b2b
+ (UIColor *)mainTextColor{
    return [UIColor colorWithHex:0x2b2b2b alpha:1.0];
}

//标题：ff2600
+ (UIColor *)titleTextColor{
    return [UIColor colorWithHex:0xff2600 alpha:1.0];
}

//有背景色字: ffffff
+ (UIColor *)backGroundTextColor{
    return [UIColor colorWithHex:0xffffff alpha:1.0];
}

//副标题 ： 5a5a5a
+ (UIColor *)FtitleColor{
    return [UIColor colorWithHex:0x5a5a5a alpha:1.0];
}

//内容：bbbbbb
+ (UIColor *)contextColor{
    return [UIColor colorWithHex:0xbbbbbb alpha:1.0];
}

//内容2：888888
+ (UIColor *)contextTwoColor{
    return [UIColor colorWithHex:0x888888 alpha:1.0];
}

//辅色：ffc90d
+ (UIColor *)helpColor{
    return [UIColor colorWithHex:0xffc90d alpha:1.0];
}

//辅色2：329ce0
+ (UIColor *)helpTwoColor{
    return [UIColor colorWithHex:0x329ce0 alpha:1.0];
}

@end
