//
//  AppInfo.m
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

+ (AppInfo *)shareAppInfo{
    
    static AppInfo *staticeSelf = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticeSelf = [[AppInfo alloc] init];
        staticeSelf.code = @"110105";
        staticeSelf.city = @"北京市";
    });
    
    return staticeSelf;
}

+ (CGRect)appFrame
{
    return [[[[UIApplication sharedApplication] delegate] window] frame];
}


+ (NSString *)systemVersion{
    
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)appIPhoneSchemeString:(NSString *)string{
    
    NSString *UIMasterString = [NSString stringWithFormat:@"UIMaster://%@",string];
    return UIMasterString;
}

@end
