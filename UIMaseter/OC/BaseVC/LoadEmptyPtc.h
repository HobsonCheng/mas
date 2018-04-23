//
//  LoadEmptyPtc.h
//  UIMaster
//
//  Created by bai on 16/6/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoadEmptyView;

@protocol LoadEmptyPtc <NSObject>

/**
 *  调整EmptyView的位置和尺寸
 *
 *  @param loadEmptyView 传递EmptyView用来设置Frame
 *  @param viewParent    传递loadEmptyView的super view来
 */
- (void)justifyEmptyView:(LoadEmptyView *)loadEmptyView inView:(UIView *)viewParent;

@optional

/**
 *  当请求失败时，对VC进行回调
 *
 *  @param context 回调的上下文
 */
- (void)doError:(id)context;

@end
