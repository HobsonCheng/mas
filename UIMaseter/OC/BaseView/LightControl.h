//
//  LightControl.h
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  LightControl 是用来解决 UIButton 无法做到点击时将子View也设置为Highlight状态的控件
 */

@interface LightControl : UIControl

/**
 *  自定义信息，可用来进行数据传递
 */
@property (nonatomic, strong) id customInfo;

/**
 *  设置LightControl的背景图
 *
 *  @param image    背景图的UIImage对象
 *  @param stateNew 设置背景图所在的State
 */
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)stateNew;

/**
 *  设置LightControl的Frame
 *
 *  @param frame LightControl新的Frame
 */
- (void)setFrame:(CGRect)frame;

@end

