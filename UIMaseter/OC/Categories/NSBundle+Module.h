//
//  NSBundle+Module.h
//  UIMaster
//
//  Created by bai on 16/5/19.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSBundle (Module)

+ (instancetype)bundleWithModuleName:(NSString *)moduleName;

+ (NSString *)pathWihResource:(NSString *)resourceName inModule:(NSString *)moduleName;

@end
