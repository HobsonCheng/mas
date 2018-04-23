//
//  NaviBarVC.h
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "BaseNameVC.h"
#import "NaviBar.h"

typedef void(^Touchevetion)(id objct , NSInteger eventType);

@interface NaviBarVC : BaseNameVC

// 初始化函数
- (instancetype)init;

- (instancetype)initWithName:(NSString *)vcNameInit;

/*!
 *  返回
 *
 *  @param sender 
 */
- (void)goBack:(id)sender;

/**
 *  获取NaviBar对象
 *
 *  @return 返回VC的NaviBar对象
 */
- (NaviBar *)naviBar;


//- (void)navleftitems:(NSArray *)items touch:(Touchevetion )touchevet;
//
//
//- (void)navrightitems:(NSArray *)items touch:(Touchevetion )touchevet;

- (void)navi_centerview:(NSArray *)items;
@end
