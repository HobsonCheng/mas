//
//  LoadEmptyView.h
//  UIMaster
//
//  Created by bai on 16/6/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadEmptyPtc.h"

@interface LoadEmptyView : UIView

@property (nonatomic, assign) id<LoadEmptyPtc> delegate;    // 代理

// 初始化
- (instancetype _Nullable)init;
- (instancetype _Nonnull)initWithFrame:(CGRect)frame;

// 设置Frame
- (void)setFrame:(CGRect)frame;

// 设置代理
- (void)setDelegate:(id <LoadEmptyPtc> _Nonnull)delegate;

// 设置加载提示文本
- (void)setLoadHint:(NSString * _Nullable)hintNew;

// 设置失败提示文本Title,默认为nil
- (void)setErrorTitleHint:(NSString * _Nullable)hintNew;

// 设置失败提示文本
- (void)setErrorHint:(NSString * _Nullable)hintNew;

// 设置失败提示文本Title和提示文本
- (void)updateErrorTitleHint:(NSString * _Nullable)titleHintNew errorHint:(NSString * _Nullable)errorHintNew;

// 设置按钮提示文本
- (void)setButtonHint:(NSString * _Nullable)hintNew;

// 加载(这里面相关的connect释放，都是通过BasenameVC的Dealloc来进行)
// 如果脱离BaseNameVC独立使用该View，则需要自己处理释放的事情
- (void)showInView:(UIView * _Nonnull)view forContext:(id _Nullable)ctx;

// 结束
- (void)loadError;

// 结束
- (void)dismiss;

// 获取Context
- (id _Nullable)context;

@end
