//
//  ScrollColorHeader.m
//  UIMaster
//
//  Created by bai on 16/6/13.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//


#import "ScrollColorHeader.h"

@interface ScrollColorHeader ()

@property (nonatomic, weak) UIScrollView	*scrollView;	// RefreshControl所在的ScrollView

@end

@implementation ScrollColorHeader

- (instancetype)initInScrollView:(UIScrollView *)scrollView
{
    self = [super initWithFrame:CGRectMake(0, scrollView.contentOffset.y, scrollView.frame.size.width, -scrollView.contentOffset.y)];
    if (self)
    {
        // 设置RefreshControl所在的ScrollView
        _scrollView = scrollView;
        
        // 设置RefreshControl的位置
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [scrollView addSubview:self];
        [scrollView sendSubviewToBack:self];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat offset = [[change objectForKey:@"new"] CGPointValue].y;
    
    [self setFrame:CGRectMake(0, offset, self.scrollView.frame.size.width, -offset)];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil)
    {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    }
    else
    {
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    [super willMoveToSuperview:newSuperview];
}

@end
