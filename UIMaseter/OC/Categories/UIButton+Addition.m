//
//  UIButton+Addition.m
//  NeiHan
//
//  Created by Charles on 16/9/1.
//  Copyright © 2016年 Com.Charles. All rights reserved.
//

#import "UIButton+Addition.h"
#import <objc/runtime.h>
#import "UIColor+Utility.h"
typedef void(^ActionBlock)();

@implementation UIButton (Addition) 

static char buttonBlockKey;

+ (instancetype)buttonWithImagename:(NSString *)imagename
                     hightImagename:(NSString *)hightImagename
                        bgImagename:(NSString *)bgImagename
                             target:(id)target
                             action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    if (target && action) {
        
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (imagename) {
        
        [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    }
    if (hightImagename) {
        
        [button setImage:[UIImage imageNamed:hightImagename] forState:UIControlStateNormal];
    }
    
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentMode = UIViewContentModeCenter;
    return button;

}

+ (instancetype)buttonWithImagename:(NSString *)imagename
                     hightImagename:(NSString *)hightImagename
                        bgImagename:(NSString *)bgImagename
                         touchBlock:(void (^)())block {
    
    
    UIButton *button = [self buttonWithImagename:imagename hightImagename:hightImagename bgImagename:bgImagename target:self action:@selector(btnTouch:)];
    button.block = block;
    return button;
}

+ (void)btnTouch:(UIButton *)button {
    if (button.block) {
        button.block();
    }
}

+ (instancetype)buttonWithTitle:(NSString *)title
                    normalColor:(UIColor *)normalColor
                  selectedColor:(UIColor *)selectedColor
                       fontSize:(CGFloat)fontSize
                     touchBlock:(void (^)())block {
    
    UIButton *button = [self buttonWithTitle:title
                                 normalColor:normalColor
                               selectedColor:selectedColor
                                    fontSize:fontSize
                                      target:self
                                      action:@selector(btnTouch:)];
    button.block = block;
    return button;
}

+ (instancetype)buttonWithTitle:(NSString *)title normalColor:(UIColor *)normalColor diableColor:(UIColor *)diableColor fontSize:(CGFloat)fontSize target:(id)target action:(SEL)action {
    
    UIButton *button = [[UIButton alloc] init];
    if (target && action) {
        
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (normalColor && title) {
        [button setTitleColor:normalColor forState:UIControlStateNormal];
    }
    if (diableColor && title) {
        [button setTitleColor:diableColor forState:UIControlStateDisabled];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentMode = UIViewContentModeCenter;
    
    return button;
}

+ (instancetype)buttonWithTitle:(NSString *)title
                    normalColor:(UIColor *)normalColor
                  selectedColor:(UIColor *)selectedColor
                       fontSize:(CGFloat)fontSize
                         target:(id)target
                         action:(SEL)action {
    
    UIButton *button = [[UIButton alloc] init];
    if (target && action) {
        
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
    }
    if (normalColor && title) {
        [button setTitleColor:normalColor forState:UIControlStateNormal];
    }
    if (selectedColor && title) {
        [button setTitleColor:selectedColor forState:UIControlStateSelected];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentMode = UIViewContentModeCenter;
    
    return button;
}

- (void)setBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &buttonBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ActionBlock)block {
    return objc_getAssociatedObject(self, &buttonBlockKey);
}



//MARK: 验证
- (void)startTime{
    
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置（倒计时结束后调用）
                [self setTitle:@"获取验证码" forState:UIControlStateNormal];
                //设置不可点击
                self.userInteractionEnabled = YES;
                self.backgroundColor = [UIColor colorWithHexString:@"#4895e0"];
                
            });
        }else{
            //            int minutes = timeout / 60;    //这里注释掉了，这个是用来测试多于60秒时计算分钟的。
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [self setTitle:[NSString stringWithFormat:@"%@秒后可重新发送",strTime] forState:UIControlStateNormal];
                //设置可点击
                self.userInteractionEnabled = NO;
//                self.backgroundColor = [UIColor colorWithHexString:@""];
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
    
}




@end
