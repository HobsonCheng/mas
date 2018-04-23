//
//  BaseNameVC.m
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "BaseNameVC.h"
#import "VCController.h"
#import "UIColor+Utility.h"
#import "AppInfo.h"
@interface BaseNameVC ()

@property (nonatomic, strong) LoadBlockView *loadBlockView;     // 弹窗加载框
@property (nonatomic, strong) LoadEmptyView *loadEmptyView;     // 渐入加载界面
@property (nonatomic, strong) NSString *vcName;             // 名称

@end

// ==================================================================
// 实现
// ==================================================================
@implementation BaseNameVC

// 重载初始化函数
- (BaseNameVC *)init
{
    if((self = [super init]) != nil)
    {
        // 根据时间生成随机VCName
        NSDate *curDate = [[NSDate alloc] init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale * gregorianLocale = [[NSLocale alloc] initWithLocaleIdentifier:NSCalendarIdentifierGregorian];
        [dateFormatter setLocale:gregorianLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSString *curDateText = [dateFormatter stringFromDate:curDate];
        NSString *defaultVCName = [[NSString alloc] initWithFormat:@"VCName:%@ %@", curDateText, NSStringFromClass([self class])];
        _vcName = defaultVCName;
        
        // 默认是支持右滑
        _canRightPan = YES;
        
        return self;
    }
    
    return nil;
}

- (BaseNameVC *)initWithClassName
{
    return [self initWithName:NSStringFromClass([self class])];
}

- (BaseNameVC *)initWithName:(NSString *)vcNameInit
{
    if((self = [self init]) != nil)
    {
        if (vcNameInit != nil)
        {
            _vcName = vcNameInit;
        }
        
        return self;
    }
    
    return nil;
}

// 获取VCName
- (NSString *)getVCName
{
    return _vcName;
}


- (void)setVCName:(NSString *)name{
    
    _vcName = name;
}


// 获取LoadBlockView
- (LoadBlockView *)blockView
{
    return _loadBlockView;
}

// 加载LoadVC
- (void)startLoadBlock:(id )connect withHint:(NSString *)hintText
{
    if(_loadBlockView == nil)
    {
        // 创建LoadVC
        _loadBlockView = [[LoadBlockView alloc] init];
        [_loadBlockView setDelegate:self];
        [_loadBlockView showInView:[self view] forConnect:connect andHint:hintText andCancel:NO];
    }
}

- (void)startLoadBlockCancel:(id )connect withHint:(NSString *)hintText
{
    if(_loadBlockView == nil)
    {
        // 创建LoadVC
        _loadBlockView = [[LoadBlockView alloc] init];
        [_loadBlockView setDelegate:self];
        
         [_loadBlockView showInView:[self view] forConnect:connect andHint:hintText andCancel:YES];
    }

}

- (void)stopLoadBlock
{
    [_loadBlockView dismiss];
    _loadBlockView = nil;
}

// 获取LoadEmptyView
- (LoadEmptyView *)emptyView
{
    if(_loadEmptyView == nil)
    {
        // 创建LoadVC
        _loadEmptyView = [[LoadEmptyView alloc] init];
        [_loadEmptyView setDelegate:self];
    }
    
    return _loadEmptyView;
}

// 加载LoadEmptyView
- (void)startLoadEmpty:(id)content
{
    
    if(_loadEmptyView == nil)
    {
        // 创建LoadVC
        _loadEmptyView = [[LoadEmptyView alloc] init];
        [_loadEmptyView setDelegate:self];
    }
    
    [_loadEmptyView showInView:[self view] forContext:content];
}

- (void)loadEmptyError
{
    if(_loadEmptyView == nil)
    {
        // 创建LoadVC
        _loadEmptyView = [[LoadEmptyView alloc] init];
        [_loadEmptyView setDelegate:self];
    }
    
    [_loadEmptyView loadError];
    
    if ([_loadEmptyView isDescendantOfView:[self view]] == NO)
    {
        [_loadEmptyView showInView:[self view] forContext:[_loadEmptyView context]];
    }
}

- (void)stopLoadEmpty
{
    __weak LoadEmptyView *weakview = _loadEmptyView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakview dismiss];
    });
}

// =======================================================================
// 默认的EmptyView的位置和尺寸
// =======================================================================
- (void)justifyEmptyView:(LoadEmptyView *)loadEmptyView inView:(UIView *)viewParent
{
    [loadEmptyView setFrame:CGRectMake(0, 0, [[self view] frame].size.width, [[self view] frame].size.height)];
}




// =======================================================================
// 重载
// =======================================================================
// 重载初始化函数
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect appFrame = [AppInfo appFrame];
    [[self view] setFrame:CGRectMake(0, 0, appFrame.size.width, appFrame.size.height)];
    [[self view] setBackgroundColor:[UIColor colorWithHex:0xf2f8fb alpha:1.0f]];
}

// 设置StatusBar控制的ViewController
- (UIViewController *)childViewControllerForStatusBarStyle
{
    if ([[[[UIApplication sharedApplication] delegate] window] rootViewController] == nil)
    {
        return self;
    }
    
    if ([[[[UIApplication sharedApplication] delegate] window] rootViewController] == self)
    {
        return [VCController getTopVC];
    }
    
    return nil;
}

// 设置StatusBar控制的ViewController
- (UIViewController *)childViewControllerForStatusBarHidden
{
    if ([[[[UIApplication sharedApplication] delegate] window] rootViewController] == nil)
    {
        return self;
    }
    
    if ([[[[UIApplication sharedApplication] delegate] window] rootViewController] == self)
    {
        return [VCController getTopVC];
    }
    
    return nil;
}

// 设置StatusBar样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

// 设置StatusBar是否隐藏
- (BOOL)prefersStatusBarHidden
{
    if ([[[[UIApplication sharedApplication] delegate] window] rootViewController] == nil)
    {
        return YES;
    }
    
    return NO;
}


// =======================================================================
#pragma mark - VCControllerPtc
// =======================================================================
// VC即将pop的事件通知
- (void)vcWillPop
{
    
}

@end
