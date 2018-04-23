//
//  VCController.h
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VCControllerPtc.h"
#import "VCAnimation.h"
#import "BaseNameVC.h"

// ==================================================================
// 手势类型
// ==================================================================
@interface VCController : NSObject <UIGestureRecognizerDelegate>

/**
 *  获取某一个VCName节点
 *
 *  @param vcName 需要获取的VC的Name
 *
 *  @return 返回对应Name的VC实例
 */
+ (BaseNameVC * _Nullable)getVC:(NSString * _Nonnull)vcName;

/**
 *  获取最上层的节点
 *
 *  @return 返回当前在Window最上层的VC实例
 */
+ (BaseNameVC * _Nullable)getTopVC;

/**
 *  获取某一个VC节点前面的节点
 *
 *  @param baseNameVC 要指定的VC
 *
 *  @return 返回改VC前的
 */
+ (BaseNameVC * _Nullable)getPreviousWithVC:(BaseNameVC * _Nonnull)baseNameVC;

/**
 *  获取最下层节点
 *
 *  @return 返回最下层节点的VC
 */
+ (BaseNameVC * _Nullable)getHomeVC;

/**
 *  Push一个ViewController，可指定push动画
 *
 *  @param baseNameVC 要Push进来的VC实例
 *  @param animation  Push时使用的动画实例，可以为nil
 */
+ (void)pushVC:(BaseNameVC * _Nonnull)baseNameVC WithAnimation:(id <VCAnimation> _Nullable)animation;

/**
 *  Pop到上一个节点，可指定动画模式
 *
 *  @param animation pop时使用的动画实例，可以为nil
 *
 *  @return 返回是否成功Pop
 */
+ (BOOL)popWithAnimation:(id <VCAnimation> _Nullable)animation;

// 弹出节点
+ (BOOL)popToVC:(NSString * _Nonnull)vcName WithAnimation:(id <VCAnimation> _Nullable)animation;

// 弹出节点然后压入节点
+ (BOOL)popThenPushVC:(BaseNameVC * _Nonnull)baseNameVC WithAnimation:(id <VCAnimation> _Nullable)animation;

// 弹出节点然后压入节点
+ (BOOL)popToVC:(NSString * _Nonnull)vcName thenPushVC:(BaseNameVC * _Nonnull)baseNameVC WithAnimation:(id <VCAnimation> _Nullable)animation;

// 弹出到最下层的VC
+ (BOOL)popToHomeVCWithAnimation:(id <VCAnimation> _Nullable)animation;

// 弹出到最下层的VC然后压入节点
+ (BOOL)popToHomeVCThenPushVC:(BaseNameVC * _Nonnull)baseNameVC WithAnimation:(id <VCAnimation> _Nullable)animation;

@end

