//
//  VCAnimation.h
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

@protocol VCAnimation <NSObject>

// 压入节点动画
/**
 *  <#Description#>
 *
 *  @param topVC      push在底部的VC
 *  @param arriveVC   push在顶部的VC
 *  @param completion push动画完成后的处理block
 */
- (void)pushAnimationFromTopVC:(UIViewController *)topVC
                    ToArriveVC:(UIViewController *)arriveVC
                WithCompletion:(void (^)(BOOL finished))completion;

/**
 *  弹出节点动画
 *
 *  @param topVC      pop在顶部的VC
 *  @param arriveVC   pop在底部的VC
 *  @param completion pop动画完成后的处理block
 */
- (void)popAnimationFromTopVC:(UIViewController *)topVC ToArriveVC:(UIViewController *)arriveVC WithCompletion:(void (^)(BOOL finished))completion;

@end

