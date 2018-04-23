//
//  LoadEmptyView.m
//  UIMaster
//
//  Created by bai on 16/6/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LoadEmptyView.h"
#import "UIColor+Utility.h"
#import "NSString+Utility.h"
#import "UIImage+Utility.h"
#import "AppInfo.h"

// ==================================================================
// 布局参数
// ==================================================================
// 控件限高宽
#define	kLoadEmptyLoadImageViewWidth		150
#define	kLoadEmptyLoadImageViewHeight		150
#define	kLoadEmptyErrorImageViewWidth		200
#define	kLoadEmptyErrorImageViewHeight		184
#define	kLoadEmptyErrorButtonWidth			220
#define	kLoadEmptyErrorButtonHeight         40
#define kLoadEmptyBGImageWidth              233
#define kLoadEmptyBGImageHeight             233
#define kLoadEmptyBGMaskWidth               320
#define kLoadEmptyBGMaskHeight              329


// 控件间距
#define kLoadEmptyLoadImageVMargin          80
#define kLoadEmptyLoadLabelVMargin          10
#define kLoadEmptyErrorImageVMargin         60
#define kLoadEmptyErrorLabelVMargin         8
#define kLoadEmptyErrorButtonVMargin        16
#define	kLoadEmptyHintLabelHMargin          12
#define kLoadEmptyBGVMargin                 2


// 控件字体
#define	kLoadEmptyHintLabelFont				(20)
#define kLoadEmptyErrorButtonFont			(18)

@interface LoadEmptyView ()

@property (nonatomic, retain) UIView *viewLoad;             // 加载界面
@property (nonatomic, strong) UIImageView *imageBGAnimation;// 地图背景
@property (nonatomic, retain) UIImageView *imageViewLoad;   // 加载动画
@property (nonatomic, retain) UILabel *labelLoadHint;       // 加载提示
@property (nonatomic, retain) UIView *viewError;            // 失败界面
@property (nonatomic, retain) UIImageView *imageViewError;  // 失败图片
@property (nonatomic, retain) UILabel *labelErrorTitleHint; // 失败提示Title
@property (nonatomic, retain) UILabel *labelErrorHint;      // 失败提示
@property (nonatomic, retain) UIButton *buttonError;        // 失败按钮
@property (nonatomic, retain) NSString *loadHint;           // 加载提示文本
@property (nonatomic, retain) NSString *errorTitleHint;     // 失败提示Title文本
@property (nonatomic, retain) NSString *errorHint;          // 失败提示文本
@property (nonatomic, retain) NSString *buttonHint;         // 按钮提示文本
@property (nonatomic, retain) id context;					// 上下文

@end

@implementation LoadEmptyView

// 初始化
- (instancetype)init
{
    CGRect appFrame = [AppInfo appFrame];
    if((self = [super initWithFrame:CGRectMake(0, 0, appFrame.size.width, appFrame.size.height)]) != nil)
    {
        [self setBackgroundColor:[UIColor colorWithHex:0xf2f8fb alpha:1.0]];
        
        _loadHint = @"努力加载中...";
        _errorTitleHint = nil;
        _errorHint = @"很抱歉, 加载失败";
        _buttonHint = @"重试";
        
        return self;
    }
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frameInit
{
    if((self = [super initWithFrame:frameInit]) != nil)
    {
        [self setBackgroundColor:[UIColor colorWithHex:0xf2f8fb alpha:1.0]];
        
        _loadHint = @"努力加载中...";
        _errorTitleHint = nil;
        _errorHint = @"很抱歉, 加载失败";
        _buttonHint = @"重试";
        
        return self;
    }
    
    return nil;
}

// 设置Frame
- (void)setFrame:(CGRect)frameNew
{
    [super setFrame:frameNew];
}

// =======================================================================
// 布局函数
// =======================================================================
// 创建Root View的子界面
- (void)setupViewRootSubs:(UIView *)viewParent
{
    // 父窗口属性
    CGRect parentFrame = [viewParent frame];
    
    // =======================================================================
    // Load View
    // =======================================================================
    // 创建View
    if(_viewLoad == nil)
    {
        _viewLoad = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    [_viewLoad setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
    [_viewLoad setBackgroundColor:[UIColor whiteColor]];
    
    // 创建子界面
    [self setupViewLoadSubs:_viewLoad];
    
    // 添加到父窗口
    [viewParent addSubview:_viewLoad];
    
    // =======================================================================
    // Error View
    // =======================================================================
    // 创建View
    if(_viewError == nil)
    {
        _viewError = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    [_viewError setFrame:CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height)];
    [_viewError setBackgroundColor:[UIColor clearColor]];
    
    // 创建子界面
    [self setupViewErrorSubs:_viewError];
    
    // 添加到父窗口
    [viewParent addSubview:_viewError];
}

// 创建Load View的子界面
- (void)setupViewLoadSubs:(UIView *)viewParent
{
    // 父窗口
    CGRect parentFrame = [viewParent frame];
    
    // 子窗口
    NSInteger spaceYStart = 0;
    
    /* 间距 */
    spaceYStart += kLoadEmptyLoadImageVMargin;
    // 动画图片
    if(_imageViewLoad == nil)
    {
        // =======================================================================
        // 骆驼背景动画 ImageView
        // =======================================================================
        UIImageView *imageBGView = [[UIImageView alloc] init];
        [imageBGView setBackgroundColor:[UIColor clearColor]];
        [imageBGView setFrame:CGRectMake((parentFrame.size.width - kLoadEmptyBGImageWidth) / 2, spaceYStart - kLoadEmptyBGVMargin, kLoadEmptyBGImageWidth, kLoadEmptyBGImageHeight)];
        [viewParent addSubview:imageBGView];
        
        // =======================================================================
        // 骆驼背景动画 ImageView
        // =======================================================================
//        _imageBGAnimation = [[UIImageView alloc] initWithImage:UIMaster_Image(@"icon_server_error.png")];
        [_imageBGAnimation setFrame:CGRectMake(0, 0, [imageBGView frame].size.width, [imageBGView frame].size.height)];
        [imageBGView addSubview:_imageBGAnimation];
        
        // =======================================================================
        // 遮罩Mask
        // =======================================================================
        UIImage *maskImage = [UIImage imageFromColor:[UIColor redColor]];//UIMaster_Image(@"LoadingCamelBGMask.png");
        CALayer *maskLayer = [CALayer layer];
        [maskLayer setFrame:CGRectMake(([imageBGView frame].size.width - kLoadEmptyBGMaskWidth) / 2, ([imageBGView frame].size.height - kLoadEmptyBGMaskHeight) / 2, kLoadEmptyBGMaskWidth, kLoadEmptyBGMaskHeight)];
        [maskLayer setContents:(id)[maskImage CGImage]];
        [[imageBGView layer] setMask:maskLayer];
        
        // =======================================================================
        // 骆驼动画 ImageView
        // =======================================================================
        _imageViewLoad = [[UIImageView alloc] init];
        [_imageViewLoad setFrame:CGRectMake((parentFrame.size.width - kLoadEmptyLoadImageViewWidth) / 2,
                                            spaceYStart, kLoadEmptyLoadImageViewWidth, kLoadEmptyLoadImageViewHeight)];
        [_imageViewLoad setAnimationDuration:0.7];
        
        // 设置动画图片
        NSMutableArray *arrayImages = [[NSMutableArray alloc] init];
        for (int i=1; i<=7; i++) {
            NSString *name = [NSString stringWithFormat:@"icon_shake_animation_%zd.png",(i+1)];
            [arrayImages addObject:[UIImage imageNamed:name]];
        }
        [_imageViewLoad setAnimationImages:arrayImages];
        
        // 保存
        [viewParent addSubview:_imageViewLoad];
    }
    
    /* 间距 */
    spaceYStart += [_imageViewLoad frame].size.height;
    spaceYStart += kLoadEmptyLoadLabelVMargin * 2;
    
    // =======================================================================
    // Hint Label
    // =======================================================================
    if(_labelLoadHint == nil)
    {
        _labelLoadHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelLoadHint setFont:[UIFont systemFontOfSize:kLoadEmptyHintLabelFont]];
        [_labelLoadHint setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelLoadHint setNumberOfLines:0];
        [_labelLoadHint setTextAlignment:NSTextAlignmentCenter];
        [_labelLoadHint setBackgroundColor:[UIColor clearColor]];
        [_labelLoadHint setTextColor:[UIColor colorWithHex:0x1ba9ba alpha:1.0]];
        
        // 保存
        [viewParent addSubview:_labelLoadHint];
    }
    
    // 设置属性
    if(_loadHint != nil)
    {
        // 设置字符串的尺寸
        CGSize hintTextSize = [_loadHint sizeWithFontCompatible:[UIFont systemFontOfSize:kLoadEmptyHintLabelFont]
                                              constrainedToSize:CGSizeMake(parentFrame.size.width - 2 * kLoadEmptyHintLabelHMargin, CGFLOAT_MAX)
                                                  lineBreakMode:NSLineBreakByWordWrapping];
        
        // 设置Label属性
        [_labelLoadHint setFrame:CGRectMake((NSInteger)(parentFrame.size.width - hintTextSize.width) / 2,
                                            spaceYStart, hintTextSize.width, hintTextSize.height)];
        [_labelLoadHint setText:_loadHint];
        [_labelLoadHint setHidden:NO];
    }
    else
    {
        [_labelLoadHint setHidden:YES];
    }
}

// 开始地图背景动画
- (void)circleAnimationStart
{
    if (_imageBGAnimation != nil)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.toValue = [NSNumber numberWithDouble:M_PI];
        animation.duration = 9;
        animation.cumulative = YES;
        animation.repeatCount = HUGE_VALF;
        [_imageBGAnimation.layer addAnimation:animation forKey:@"activity"];
    }
}

// 创建Error View的子界面
- (void)setupViewErrorSubs:(UIView *)viewParent
{
    // 父窗口
    CGRect parentFrame = [viewParent frame];
    
    // 子窗口
    NSInteger spaceYStart = 30;
    
    /* 间距 */
    spaceYStart += kLoadEmptyErrorImageVMargin;
    
    // 图片
    if(_imageViewError == nil)
    {
        _imageViewError = [[UIImageView alloc] init];
        [_imageViewError setFrame:CGRectMake((parentFrame.size.width - kLoadEmptyErrorImageViewWidth) / 2,
                                             spaceYStart, kLoadEmptyErrorImageViewWidth, kLoadEmptyErrorImageViewHeight)];
        [_imageViewError setImage:[UIImage imageFromColor:[UIColor yellowColor]]];//UIMaster_Image(@"加载失败400.png")
        
        // 保存
        [viewParent addSubview:_imageViewError];
    }
    
    /* 间距 */
    spaceYStart += [_imageViewError frame].size.height + 20;
    
    // =======================================================================
    // Hint Title Label
    // =======================================================================
    if(_labelErrorTitleHint == nil)
    {
        _labelErrorTitleHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelErrorTitleHint setFont:[UIFont systemFontOfSize:kLoadEmptyHintLabelFont]];
        [_labelErrorTitleHint setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelErrorTitleHint setNumberOfLines:0];
        [_labelErrorTitleHint setTextAlignment:NSTextAlignmentCenter];
        [_labelErrorTitleHint setTextColor:[UIColor colorWithHex:0x333333 alpha:1.0]];
        
        // 保存
        [viewParent addSubview:_labelErrorTitleHint];
    }
    
    // 设置属性
    if(_errorTitleHint != nil)
    {
        spaceYStart += kLoadEmptyErrorLabelVMargin;
        
        // 设置字符串的尺寸
        CGSize hintTextSize = [_errorTitleHint sizeWithFontCompatible:[UIFont systemFontOfSize:kLoadEmptyHintLabelFont]
                                                    constrainedToSize:CGSizeMake(parentFrame.size.width - 2 * kLoadEmptyHintLabelHMargin, CGFLOAT_MAX)
                                                        lineBreakMode:NSLineBreakByWordWrapping];
        
        // 设置Label属性
        [_labelErrorTitleHint setFrame:CGRectMake((NSInteger)(parentFrame.size.width - hintTextSize.width) / 2,
                                                  spaceYStart, hintTextSize.width, hintTextSize.height)];
        [_labelErrorTitleHint setText:_errorTitleHint];
        [_labelErrorTitleHint setHidden:NO];
        
        /* 间距 */
        spaceYStart += [_labelErrorTitleHint frame].size.height;
    }
    else
    {
        [_labelErrorTitleHint setHidden:YES];
    }
    
    // =======================================================================
    // Hint Label
    // =======================================================================
    if(_labelErrorHint == nil)
    {
        _labelErrorHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelErrorHint setFont:[UIFont systemFontOfSize:kLoadEmptyHintLabelFont]];
        [_labelErrorHint setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelErrorHint setNumberOfLines:0];
        [_labelErrorHint setTextAlignment:NSTextAlignmentCenter];
        [_labelErrorHint setTextColor:[UIColor colorWithHex:0x333333 alpha:1.0]];
        
        // 保存
        [viewParent addSubview:_labelErrorHint];
    }
    
    // 设置属性
    if(_errorHint != nil)
    {
        spaceYStart += kLoadEmptyErrorLabelVMargin;
        
        // 设置字符串的尺寸
        CGSize hintTextSize = [_errorHint sizeWithFontCompatible:[UIFont systemFontOfSize:kLoadEmptyHintLabelFont]
                                               constrainedToSize:CGSizeMake(parentFrame.size.width - 2 * kLoadEmptyHintLabelHMargin, CGFLOAT_MAX)
                                                   lineBreakMode:NSLineBreakByWordWrapping];
        
        // 设置Label属性
        [_labelErrorHint setFrame:CGRectMake((NSInteger)(parentFrame.size.width - hintTextSize.width) / 2,
                                             spaceYStart, hintTextSize.width, hintTextSize.height)];
        [_labelErrorHint setText:_errorHint];
        [_labelErrorHint setHidden:NO];
        
        /* 间距 */
        spaceYStart += [_labelErrorHint frame].size.height;
    }
    else
    {
        [_labelErrorHint setHidden:YES];
    }
    
    /* 间距 */
    spaceYStart += kLoadEmptyErrorLabelVMargin;
    
    // =======================================================================
    // Button
    // =======================================================================
    if(_buttonError == nil)
    {
        _buttonError = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonError setFrame:CGRectMake((NSInteger)(parentFrame.size.width - kLoadEmptyErrorButtonWidth) / 2,
                                          spaceYStart, kLoadEmptyErrorButtonWidth, kLoadEmptyErrorButtonHeight)];
        [[_buttonError titleLabel] setFont:[UIFont systemFontOfSize:14]];
        [_buttonError setBackgroundImage:[UIImage imageFromColor:[UIColor MainNavColor]]
                                forState:UIControlStateNormal];
        [_buttonError addTarget:self action:@selector(doError:) forControlEvents:UIControlEventTouchUpInside];
        [[_buttonError layer] setCornerRadius:2.0];
        [[_buttonError layer] setMasksToBounds:YES];
        
        // 保存
        [viewParent addSubview:_buttonError];
    }
    
    if (_buttonHint != nil)
    {
        [_buttonError setTitle:_buttonHint forState:UIControlStateNormal];
        [_buttonError setFrame:CGRectMake((NSInteger)(parentFrame.size.width - kLoadEmptyErrorButtonWidth) / 2,
                                          spaceYStart, kLoadEmptyErrorButtonWidth, kLoadEmptyErrorButtonHeight)];
        [_buttonError setHidden:NO];
    }
    else
    {
        [_buttonError setHidden:YES];
    }
}


// =======================================================================
// 事件处理函数
// =======================================================================
// 失败
- (void)doError:(id)sender
{
    // 请求代理函数
    if((_delegate != nil) && ([_delegate respondsToSelector:@selector(doError:)] == YES))
    {
        [_delegate doError:_context];
    }
}

// 设置代理
- (void)setDelegate:(id<LoadEmptyPtc>)delegateNew
{
    _delegate = delegateNew;
}

// 设置加载提示文本
- (void)setLoadHint:(NSString *)hintNew
{
    _loadHint = hintNew;
}

// 设置失败提示文本
- (void)setErrorTitleHint:(NSString *)hintNew
{
    _errorTitleHint = hintNew;
    if (_viewError != nil)
    {
        [self setupViewErrorSubs:_viewError];
    }
}

// 设置失败提示文本
- (void)setErrorHint:(NSString *)hintNew
{
    _errorHint = hintNew;
    if (_viewError != nil)
    {
        [self setupViewErrorSubs:_viewError];
    }
}

// 设置失败提示文本Title和提示文本
- (void)updateErrorTitleHint:(NSString *)titleHintNew errorHint:(NSString *)errorHintNew
{
    _errorTitleHint = titleHintNew;
    _errorHint = errorHintNew;
    if (_viewError != nil)
    {
        [self setupViewErrorSubs:_viewError];
    }
}

// 设置按钮提示文本
- (void)setButtonHint:(NSString *)hintNew
{
    _buttonHint = hintNew;
    if (_viewError != nil)
    {
        [self setupViewErrorSubs:_viewError];
    }
}

// 加载
- (void)showInView:(UIView *)view forContext:(id)ctx
{
    // 设置属性
    _context = ctx;
    
    // 布局
    if((_delegate != nil) && ([_delegate respondsToSelector:@selector(justifyEmptyView:inView:)] == YES))
    {
        [_delegate justifyEmptyView:self inView:view];
    }
    
    // 刷新界面
    [self setupViewRootSubs:self];
    
    // 隐藏错误界面
    [_viewLoad setHidden:NO];
    [_viewError setHidden:YES];
    [_imageViewLoad startAnimating];
    
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [animation setToValue:[NSNumber numberWithDouble:M_PI]];
    [animation setDuration:9];
    [animation setCumulative:YES];
    [animation setRepeatCount:HUGE_VALF];
    [[_imageBGAnimation layer] addAnimation:animation forKey:@"activity"];
    
    // 添加到父窗口
    [view addSubview:self];
}

// 结束
- (void)loadError
{
    [_imageViewLoad stopAnimating];
    [_viewLoad setHidden:YES];
    [_viewError setHidden:NO];
}

// 结束加载
- (void)dismiss
{
    // 停止动画
    [_imageViewLoad stopAnimating];
    [[_imageBGAnimation layer] removeAnimationForKey:@"activity"];
    [_imageViewLoad removeFromSuperview];
    _imageViewLoad = nil;
    // 移除屏幕
    [self removeFromSuperview];
}

// 获取Context
- (id)context
{
    return _context;
}

// 销毁代理
- (void)dealloc
{
    _delegate = nil;
}

@end
