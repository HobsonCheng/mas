//
//  NaviBar.h
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NaviBarItem.h"


@interface NaviBar : UIControl

@property (nonatomic, assign) BOOL isClickEnable;
@property (nonatomic, retain) NSArray *rightBarItems;
@property (nonatomic, retain) NSArray *leftBarItems;
@property (nonatomic, strong) UIView *viewBG;           // 背景图片

// 初始化函数
- (NaviBar *)initWithFrame:(CGRect)frameInit;

// 设置frame
- (void)setFrame:(CGRect)frameNew;

// 设置背景Color
- (void)setNaviBarBackgroundColor:(UIColor *)backgroundColor;

// Title
- (NSString *)title;
- (void)setTitle:(NSString *)titleNew;
- (void)setTitleColor:(NSString *)titleColor;

// Title
//- (UIColor *)titleColor;
//- (void)setTitleColor:(UIColor *)titleNew;

// 获取和设置左边的Item
- (UIView *)leftBarItem;
- (void)setLeftBarItem:(UIView *)viewLeftNew;

// 获取和设置右边的Item
- (UIView *)rightBarItem;
- (void)setRightBarItem:(UIView *)viewRightNew;

// 获取和设置标题View
- (UIControl *)titleView;
- (void)setTitleView:(UIView *)viewTitleNew;



@end

