//
//  AppInfo.h
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppInfo : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic) NSString *city;

@property (nonatomic) NSString *code;


+ (AppInfo *)shareAppInfo;

/**
 *  获取当前App所占屏幕的大小
 *
 *  @return 返回屏幕大小
 */
+ (CGRect)appFrame;

/*
 版本号
 */
+ (NSString *)systemVersion;


/**
 *  给出URL不包含Scheme header的部分，根据所使用的客户端天假Scheme头
 *
 *  @param string URL除去Scheme头的部分
 *
 *  @return 返回添加了Scheme Header后的URL字符串
 */
+ (NSString *)appIPhoneSchemeString:(NSString *)string;


@end
