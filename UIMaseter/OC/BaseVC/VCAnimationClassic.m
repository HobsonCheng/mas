//
//  VCAnimationClassic.m
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "VCAnimationClassic.h"
#import "UIView+Frame.h"

@implementation VCAnimationClassic

+ (VCAnimationClassic *)defaultAnimation
{
    return [[VCAnimationClassic alloc] init];
}

- (void)pushAnimationFromTopVC:(UIViewController *)topVC
                    ToArriveVC:(UIViewController *)arriveVC
                WithCompletion:(void (^)(BOOL finished))completion
{
    [[arriveVC view] setViewX:[[arriveVC view] frame].size.width];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [[topVC view] setViewX:-[[topVC view] frame].size.width];
                         [[arriveVC view] setViewX:0];
                     }
                     completion:completion];
}

- (void)popAnimationFromTopVC:(UIViewController *)topVC
                   ToArriveVC:(UIViewController *)arriveVC
               WithCompletion:(void (^)(BOOL finished))completion
{
    [[arriveVC view] setViewX:-[[arriveVC view] frame].size.width];
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [[topVC view] setViewX:[[topVC view] frame].size.width];
                         [[arriveVC view] setViewX:0];
                     }
                     completion:completion];
}

@end
