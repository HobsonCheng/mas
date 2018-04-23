//
//  LoadBlockView.h
//  UIMaster
//
//  Created by bai on 16/6/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadBlockPtc.h"

@interface LoadBlockView : UIView

@property (nonatomic, assign) id<LoadBlockPtc> delegate;    // 代理

// 初始化
- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  设置代理
 *
 *  @param delegate 设置LoadBlockView的代理
 */
- (void)setDelegate:(id<LoadBlockPtc>)delegate;

/**
 *  将LoadBlockView显示在一个View中 (之所以要求传送connect，主要是为了解决connect释放的问题)
 *
 *  @param view    LoadBlockView的容器View
 *  @param connect 进行网络请求的URLConnection对象
 *  @param text    Load浮层中的提示文案
 *  @param cancel  是否能够取消链接
 */
- (void)showInView:(UIView *)view forConnect:(id)connect andHint:(NSString *)text andCancel:(BOOL)cancel;

/**
 *  改变Load浮层中的提示文案
 *
 *  @param hintNew 提示文案
 */
- (void)changeHint:(NSString *)hintNew;

/**
 *  关闭LoadBlockView
 */
- (void)dismiss;

/**
 *  @name 被屏蔽的方法
 */

/**
 *  设置Frame (已被屏蔽的方法) 调用无效
 *
 *  @param frame view的frame
 */
- (void)setFrame:(CGRect)frame DEPRECATED_MSG_ATTRIBUTE("LoadBlockView did not support setFrame:, the default frame is fullscreen");

@end
