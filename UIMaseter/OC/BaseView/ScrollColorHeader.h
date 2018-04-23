//
//  ScrollColorHeader.h
//  UIMaster
//
//  Created by bai on 16/6/13.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

/**
 *  ScrollColorHeader 实现类似 RefreshControl
 *  目的在于当某些界面需要使用 TableView 或 ScrollView 滚动的同时与 NavigationBar 进行颜色连接的需求时使用
 *
 *  可通过设置 ScrollColorHeader 的 BackgroundColor 来修改该控件所展示的颜色
 */
#import <UIKit/UIKit.h>

@interface ScrollColorHeader : UIView

/**
 *  将ScrollColorHeader加入到ScrollView上
 *
 *  @param scrollView 要加入ScrollColorHeader的TableView
 *
 *  @return 返回ScrollColorHeader对象
 */
- (instancetype)initInScrollView:(UIScrollView *)scrollView;

@end

