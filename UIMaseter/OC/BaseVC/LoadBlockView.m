//
//  LoadBlockView.m
//  UIMaster
//
//  Created by bai on 16/6/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "LoadBlockView.h"
#import "AppInfo.h"
#import "UIColor+Utility.h"
#import "NSString+Utility.h"
#import "UIImageView+GIFDecode.h"
#import "UIView+Frame.h"
// ==================================================================
// 布局参数
// ==================================================================
// 控件限高宽
#define kLoadBlockContentViewWidth			240
#define kLoadBlockContentViewHeight			124
#define	kLoadBlockImageViewWidth			80
#define	kLoadBlockImageViewHeight			100
#define	kLoadBlockCancelButtonWidth			100
#define	kLoadBlockCancelButtonHeight		44
#define kLoadBlockBGImageWidth              233
#define kLoadBlockBGImageHeight             233
#define kLoadBlockBGMaskWidth               320
#define kLoadBlockBGMaskHeight              329

// 控件间距
#define kLoadBlockCamelVMargin              30
#define	kLoadBlockHintLabelHMargin			12
#define kLoadBlockHintLabelVMargin          16
#define kLoadBlockBGVMargin                 2

// 控件字体
#define	kLoadBlockHintLabelFont             (14)

// 扩展
@interface LoadBlockView ()

@property (nonatomic, retain) UIView *viewContent;          // 内容界面
@property (nonatomic, strong) UIImageView *imageBGAnimation;// 地图背景
@property (nonatomic, retain) UIImageView *imageViewLoad;   // 加载动画
@property (nonatomic, retain) UILabel *labelHint;           // 提示文本
@property (nonatomic, retain) UIButton *buttonCancel;       // 取消按钮
@property (nonatomic, retain) id connect;     // 网络连接
@property (nonatomic, retain) NSString *hintText;			// 提示文本
@property (nonatomic, assign) BOOL canCancel;				// 是否可以取消

@end

// ==================================================================
// 实现
// ==================================================================
@implementation LoadBlockView

// 初始化
- (instancetype)init
{
    if((self = [super initWithFrame:CGRectZero]) != nil)
    {
        [self commonInit];
        return self;
    }
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frameInit
{
    if((self = [super initWithFrame:CGRectZero]) != nil)
    {
        [self commonInit];
        return self;
    }
    
    return nil;
}

- (void)commonInit {
    CGRect appFrame = [AppInfo appFrame];
    [super setFrame:CGRectMake(0, 0, appFrame.size.width, appFrame.size.height)];
    [self setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
    
    _hintText = @"努力加载中...";
}

// 设置Frame(!!!屏蔽该函数)
- (void)setFrame:(CGRect)frame
{
    // do nothing
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
    // Content View
    // =======================================================================
    // 创建View
    if(_viewContent == nil)
    {
        _viewContent = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    [_viewContent setFrame:CGRectMake((NSInteger)(parentFrame.size.width - kLoadBlockContentViewWidth) / 2,
                                      (NSInteger)(parentFrame.size.height - kLoadBlockContentViewHeight) / 2,
                                      kLoadBlockContentViewWidth, kLoadBlockContentViewHeight)];
    [_viewContent setBackgroundColor:[UIColor whiteColor]];
    [[_viewContent layer] setCornerRadius:5.0f];
    [[_viewContent layer] setMasksToBounds:YES];
    
    // 创建子界面
    [self setupViewContentSubs:_viewContent];
    
    // 添加到父窗口
    [viewParent addSubview:_viewContent];
}

// 创建Content View的子界面
- (void)setupViewContentSubs:(UIView *)viewParent
{
    // 父窗口
    CGRect parentFrame = [viewParent frame];
    
    // 子窗口
    NSInteger spaceYStart = 0;
    
    /* 间距 */
    spaceYStart += kLoadBlockCamelVMargin;
    
    // 动画图片

    if(_imageViewLoad == nil)
    {
        // =======================================================================
        // 骆驼背景动画 ImageView
        // =======================================================================
        UIImageView *imageBGView = [[UIImageView alloc] init];
        [imageBGView setBackgroundColor:[UIColor clearColor]];
        [imageBGView setFrame:CGRectMake((parentFrame.size.width - kLoadBlockBGImageWidth) / 2, spaceYStart - kLoadBlockBGVMargin, kLoadBlockBGImageWidth, kLoadBlockBGImageHeight)];
        [viewParent addSubview:imageBGView];
        
        // =======================================================================
        // 骆驼背景动画 ImageView
        // =======================================================================
//        _imageBGAnimation = [[UIImageView alloc] initWithImage:UIMaster_Image(@"icon_server_error.png")];
//        [_imageBGAnimation setFrame:CGRectMake(0, 0, [imageBGView frame].size.width, [imageBGView frame].size.height)];
        [imageBGView addSubview:_imageBGAnimation];
        
        // =======================================================================
        // 遮罩Mask
        // =======================================================================
        UIImage *maskImage = [[UIImage alloc] init];
        CALayer *maskLayer = [CALayer layer];
        [maskLayer setFrame:CGRectMake(([imageBGView frame].size.width - kLoadBlockBGMaskWidth) / 2, ([imageBGView frame].size.height - kLoadBlockBGMaskHeight) / 2, kLoadBlockBGMaskWidth, kLoadBlockBGMaskHeight)];
        [maskLayer setContents:(id)[maskImage CGImage]];
        [[imageBGView layer] setMask:maskLayer];
        
        
        _imageViewLoad = [[UIImageView alloc] init];
        [_imageViewLoad setFrame:CGRectMake((parentFrame.size.width - kLoadBlockImageViewWidth) / 2,
                                            spaceYStart, kLoadBlockImageViewWidth, kLoadBlockImageViewHeight)];
        [_imageViewLoad setAnimationDuration:3];
        
        // 设置动画图片
        NSMutableArray *arrayImages = [[NSMutableArray alloc] init];
        for (int i=0; i<=7; i++) {
            NSString *name = [NSString stringWithFormat:@"icon_shake_animation_%zd.png",(i+1)];
            [arrayImages addObject:[UIImage imageNamed:name]];
        }
        [_imageViewLoad setAnimationImages:arrayImages];
        
        // 保存
        [viewParent addSubview:_imageViewLoad];
    }
    
    /* 间距 */
    spaceYStart += [_imageViewLoad frame].size.height;
    spaceYStart += kLoadBlockHintLabelVMargin;
    
    // =======================================================================
    // Hint Label
    // =======================================================================
    if(_labelHint == nil)
    {
        _labelHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelHint setFont:[UIFont systemFontOfSize:kLoadBlockHintLabelFont]];
        [_labelHint setLineBreakMode:NSLineBreakByWordWrapping];
        [_labelHint setNumberOfLines:0];
        [_labelHint setTextAlignment:NSTextAlignmentCenter];
        [_labelHint setTextColor:[UIColor colorWithHex:0x000000 alpha:1.0]];
        
        // 保存
        [viewParent addSubview:_labelHint];
    }
    
    // 设置属性
    if(_hintText != nil)
    {
        // 设置字符串的尺寸
        CGSize hintTextSize = [_hintText sizeWithFontCompatible:[UIFont systemFontOfSize:kLoadBlockHintLabelFont]
                                              constrainedToSize:CGSizeMake(parentFrame.size.width - 2 * kLoadBlockHintLabelHMargin, CGFLOAT_MAX)
                                                  lineBreakMode:NSLineBreakByWordWrapping];
        
        // 设置Label属性
        [_labelHint setFrame:CGRectMake((NSInteger)(parentFrame.size.width - hintTextSize.width) / 2,
                                        spaceYStart, hintTextSize.width, hintTextSize.height)];
        [_labelHint setText:_hintText];
        [_labelHint setHidden:NO];
    }
    else
    {
        [_labelHint setHidden:YES];
    }
    
    /* 间距 */
    spaceYStart += [_labelHint frame].size.height;
    spaceYStart += kLoadBlockCamelVMargin;
    
    // =======================================================================
    // Close Button
    // =======================================================================
    if(_buttonCancel == nil)
    {
        _buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_buttonCancel setBackgroundImage:UIMaster_Image(@"CClossIcon.png") forState:UIControlStateNormal];
//        [_buttonCancel setBackgroundImage:UIMaster_Image(@"CClossIcon.png") forState:UIControlStateHighlighted];
        [_buttonCancel addTarget:self action:@selector(doCancel:) forControlEvents:UIControlEventTouchUpInside];
        
        // 保存
        [viewParent addSubview:_buttonCancel];
    }
    
    // 现实
    if(_canCancel)
    {
        [_buttonCancel setFrame:CGRectMake(parentFrame.size.width - kLoadBlockCancelButtonWidth / 2 - 12,
                                           -kLoadBlockCancelButtonHeight / 2 + 12,
                                           kLoadBlockCancelButtonWidth, kLoadBlockCancelButtonHeight)];
        [_buttonCancel setHidden:NO];
    }
    else
    {
        [_buttonCancel setHidden:YES];
    }
    
    // 重置高度
    if (viewParent != nil && spaceYStart > parentFrame.size.height)
    {
        CGPoint center = [viewParent center];
        [viewParent setViewHeight:spaceYStart];
        [viewParent setCenter:center];
    }

}

// =======================================================================
// 事件处理函数
// =======================================================================
// 取消
- (void)doCanceldo:(id)sender
{
    // 停止加载
    [self dismiss];
    
    // 取消网络请求
    if(_connect != nil)
    {
        //        [_connect cancelNetConnection];
    }
    
    // 请求代理函数
    if((_delegate != nil) && ([_delegate respondsToSelector:@selector(cancelLoadForContext:)] == YES))
    {
        [_delegate cancelLoadForContext:_connect];
    }
}

// =======================================================================
// 接口函数
// =======================================================================
// 加载(ctx, text如果没发生变化，就传nil)
- (void)showInView:(UIView *)view forConnect:(id )connect andHint:(NSString *)text andCancel:(BOOL)cancel
{
    // 设置属性
    _connect = connect;
    _hintText = text;
    _canCancel = cancel;
    
    // 刷新界面
    [self setupViewRootSubs:self];
    
    // 添加到父窗口
    [self setAlpha:0];
    [view addSubview:self];
    
    // 显示
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [_imageViewLoad startAnimating];
                         [self setAlpha:1];
                         
                         // 设置动画
                         CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                         [animation setToValue:[NSNumber numberWithDouble:M_PI]];
                         [animation setDuration:9];
                         [animation setCumulative:YES];
                         [animation setRepeatCount:HUGE_VALF];
                         [[_imageBGAnimation layer] addAnimation:animation forKey:@"activity"];
                     }
                     completion:nil];
}

// 设置代理
- (void)setDelegate:(id<LoadBlockPtc>)delegateNew
{
    _delegate = delegateNew;
}

// 设置文本
- (void)changeHint:(NSString *)hintNew
{
    _hintText = hintNew;
    
    [self setupViewRootSubs:self];
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

// 销毁代理
- (void)dealloc
{
    _delegate = nil;
}

@end
