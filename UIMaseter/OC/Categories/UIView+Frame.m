//
//  UIView+Frame.m
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

// 设置UIView的X
- (void)setViewX:(CGFloat)newX
{
    CGRect viewFrame = [self frame];
    viewFrame.origin.x = newX;
    [self setFrame:viewFrame];
}

// 设置UIView的Y
- (void)setViewY:(CGFloat)newY
{
    CGRect viewFrame = [self frame];
    viewFrame.origin.y = newY;
    [self setFrame:viewFrame];
}

// 设置UIView的Origin
- (void)setViewOrigin:(CGPoint)newOrigin
{
    CGRect viewFrame = [self frame];
    viewFrame.origin = newOrigin;
    [self setFrame:viewFrame];
}

// 设置UIView的width
- (void)setViewWidth:(CGFloat)newWidth
{
    CGRect viewFrame = [self frame];
    viewFrame.size.width = newWidth;
    [self setFrame:viewFrame];
}

// 设置UIView的height
- (void)setViewHeight:(CGFloat)newHeight
{
    CGRect viewFrame = [self frame];
    viewFrame.size.height = newHeight;
    [self setFrame:viewFrame];
}

// 设置UIView的Size
- (void)setViewSize:(CGSize)newSize
{
    CGRect viewFrame = [self frame];
    viewFrame.size = newSize;
    [self setFrame:viewFrame];
}
/*!
 *  获取
 */
+(id)loadFromXib
{
    NSString *className = NSStringFromClass([self class]);
    NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    return [xibArray objectAtIndex:0];
}
+(id)loadFromXib:(NSInteger)index{
    NSString *className = NSStringFromClass([self class]);
    NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil];
    if (index < xibArray.count) {
        return [xibArray objectAtIndex:index];
    }
    return [xibArray objectAtIndex:0];
}
@end
