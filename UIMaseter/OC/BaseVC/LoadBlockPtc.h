//
//  LoadBlockPtc.h
//  UIMaster
//
//  Created by bai on 16/6/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol LoadBlockPtc <NSObject>

@optional

/**
 *  取消Load，通过上下文判断处理
 *
 *  @param context 取消Load对应的上下文
 */
- (void)cancelLoadForContext:(id)context;

@end
