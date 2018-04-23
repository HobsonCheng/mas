//
//  NaviBarItem.h
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import <UIKit/UIKit.h>


// 状态
typedef enum
{
    eNaviBarItemStateNormal,		// 普通状态
    eNaviBarItemStateHighlighted,	// 高亮状态
    eNaviBarItemDisable,			// 禁用状态
} NaviBarItemState;

// 导航栏按钮
@interface NaviBarItem : UIView

@property (nonatomic, strong) UIButton *button;            // 按钮
    
// 创建BarItem
- (NaviBarItem *)initImageItem:(CGRect)frameInit target:(id)target action:(SEL)action;

// 创建BarItem
- (NaviBarItem *)initTextItem:(NSString *)title target:(id)target action:(SEL)action;

// 创建EmptyRightBarItem
- (NaviBarItem *)initEmptyRightItem:(id)target action:(SEL)action;

// 创建BackBarItem
- (NaviBarItem *)initBackItem:(id)target action:(SEL)action;

// 创建CloseBarItem
- (NaviBarItem *)initCloseItem:(id)target action:(SEL)action;

// 设置Frame
- (void)setFrame:(CGRect)frameNew;

// 设置文本
- (void)setTitle:(NSString *)titleNew;

// 设置背景色
- (void)setBackgroundImage:(UIImage *)image forState:(NaviBarItemState)state;

// 设置图片按钮
- (void)setIconImage:(UIImage *)image forState:(NaviBarItemState)state;

//网络图片
- (void)setIconImageUrl:(NSString *)imageUrl forState:(NaviBarItemState)state;

// 设置Item是否为Disabled
- (void)setItemEnable:(BOOL)isEnable;



//格外增加绑定属性
@property (nonatomic, strong)id itemobject;

@end

