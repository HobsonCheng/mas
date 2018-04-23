//
//  VCAnimationClassic.h
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "VCAnimation.h"

@interface VCAnimationClassic : NSObject <VCAnimation>

/**
 *  Classic弹出动画默认创建实例
 *
 *  @return 返回默认配置实例
 */
+ (VCAnimationClassic *)defaultAnimation;

@end
