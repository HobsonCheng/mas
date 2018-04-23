//
//  BaseNameVC.h
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCControllerPtc.h"
#import "LoadBlockView.h"
#import "LoadEmptyView.h"
// ==================================================================
// 该类是Project中所有需要跳转的UIViewController的基类
// 它记录了VC的name,方便基于name的VC和管理
// ==================================================================

@interface BaseNameVC : UIViewController<VCControllerPtc,LoadBlockPtc, LoadEmptyPtc>


@property (nonatomic, assign) BOOL canRightPan;		// 是否可以右滑
@property (nonatomic, assign) NSInteger tagInt;     //页面唯一标示

// 初始化函数
- (BaseNameVC *)init;
- (BaseNameVC *)initWithClassName;
- (BaseNameVC *)initWithName:(NSString *)vcNameInit;

/**
 *  获取一个 BaseNameVC 的 Name
 *
 *  @return 返回 Name 字符串
 */
- (NSString *)getVCName;

- (void)setVCName:(NSString *)name;

/**
 *  获取BaseNameVC的LoadblockView
 *
 *  @return 返回该BaseNameVC的 LoadblockView
 */
- (LoadBlockView *)blockView;

// 加载LoadBlockView
- (void)startLoadBlock:(id )connect withHint:(NSString *)hintText;
- (void)startLoadBlockCancel:(id)connect withHint:(NSString *)hintText;
- (void)stopLoadBlock;

// 获取LoadEmptyView
/**
 *  获取BaseNameVC 的 LoadEmptyView
 *
 *  @return 返回BaseNameVC的 LoadEmptyView
 */
- (LoadEmptyView *)emptyView;

// 加载LoadEmptyView
- (void)startLoadEmpty:(id)content;
- (void)loadEmptyError;
- (void)stopLoadEmpty;


@end
