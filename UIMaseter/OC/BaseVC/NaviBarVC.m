//
//  NaviBarVC.m
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "NaviBarVC.h"
#import "NaviBarItem.h"
#import "VCController.h"
#import "VCAnimationClassic.h"
// ==================================================================
// 布局参数
// ==================================================================

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 状态栏高度
#define STATUS_BAR_HEIGHT (iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (iPhoneX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)


#define kNaviNameNaivBarHeight				NAVIGATION_BAR_HEIGHT

@interface NaviBarVC ()

@property (nonatomic, retain) NaviBar *naviBarHead;     // 导航栏
@property (nonatomic, strong) Touchevetion touchleft;
@property (nonatomic, strong) Touchevetion touchright;

@end

@implementation NaviBarVC

// 初始化函数
- (instancetype)init
{
    if((self = [super init]) != nil)
    {
        // 创建NaviBar
        _naviBarHead = [[NaviBar alloc] initWithFrame:CGRectZero];
        
        return self;
    }
    
    return nil;
}

- (instancetype)initWithName:(NSString *)vcNameInit
{
    if((self = [super initWithName:vcNameInit]) != nil)
    {
        // 创建NaviBar
        _naviBarHead = [[NaviBar alloc] initWithFrame:CGRectZero];
        
        return self;
    }
    
    return nil;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) != nil){
        // 创建NaviBar
        _naviBarHead = [[NaviBar alloc] initWithFrame:CGRectZero];
        
        return self;
    }
    
    return nil;
}

// 重载初始化函数
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 创建NaviBar
    CGRect vcViewFrame = [[self view] frame];
    [_naviBarHead setFrame:CGRectMake(0, 0, vcViewFrame.size.width, kNaviNameNaivBarHeight)];
    
    // 创建NaviBar的子界面
    [self setupNaviBarDefaultSubs:_naviBarHead];
    
    // 添加
    [[self view] addSubview:_naviBarHead];
}

// 设置StatusBar样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// 创建NavigationBar的子界面
- (void)setupNaviBarDefaultSubs:(NaviBar *)viewParent
{
    // BackItem
    NaviBarItem *leftItem = [[NaviBarItem alloc] initBackItem:self action:@selector(goBack:)];
    [viewParent setLeftBarItem:leftItem];
}

// 获取Bar
- (NaviBar *)naviBar
{
    return _naviBarHead;
}

// 返回事件
- (void)goBack:(id)sender
{
    [VCController popWithAnimation:[VCAnimationClassic defaultAnimation]];
}

// =======================================================================
// 默认的EmptyView的位置和尺寸
// =======================================================================
- (void)justifyEmptyView:(LoadEmptyView *)loadEmptyView inView:(UIView *)viewParent
{
    NSInteger naviBarHeight = [_naviBarHead frame].size.height;
    [loadEmptyView setFrame:CGRectMake(0, naviBarHeight, [[self view] frame].size.width,
                                       [[self view] frame].size.height - naviBarHeight)];
}

/*
 左侧按钮
 */
//- (NaviBarItem *)genderbaritem:(NaviBarItemData *)object itemtype:(NSInteger )type :(SEL)action{
//
//    __block NaviBarItem *item;
//    if (type == 1) {//文字
//        item = [[NaviBarItem alloc] initTextItem:object.text target:self action:action];
//    }else{
//        item = [[NaviBarItem alloc]  initImageItem:CGRectMake(0, 0, 40, 40) target:self action:action];
//        [WebImageDownload bai_downLoadImage_asyncWithURL:[NSURL URLWithString:object.imageurl] options:WebImageDefault completed:^(UIImage *image, NSURL *url) {
//            [item setIconImage:image forState:eNaviBarItemStateNormal];
//        }];
//    }
//
//    item.itemobject = object;
//    return item;
//}
//- (void)navleftitems:(NSArray *)items touch:(Touchevetion )touchevet{
//
//    NSMutableArray *tmp = [NSMutableArray new];
//    if (items.count >= 1) {
//        NaviBarItemData *data = [items firstObject];
//        NaviBarItem *item1 = [self genderbaritem:data itemtype:[data.type integerValue] :@selector(touchitem_left:)];
//        [tmp addObject:item1];
//    }
//    if (items.count >= 2) {
//        NaviBarItemData *data = [items objectAtIndex:1];
//        NaviBarItem *item2 = [self genderbaritem:data itemtype:[data.type integerValue] :@selector(touchitem_left:)];
//        [tmp addObject:item2];
//    }
//    if (items.count >= 3) {
//        NaviBarItemData *data = [items objectAtIndex:2];
//        NaviBarItem *item3 = [self genderbaritem:data itemtype:[data.type integerValue] :@selector(touchitem_left:)];
//        [tmp addObject:item3];
//    }
//    self.naviBar.leftBarItems = tmp;
//    self.touchleft = touchevet;
//}
//- (void)navrightitems:(NSArray *)items touch:(Touchevetion )touchevet{
//
//    NSMutableArray *tmp = [NSMutableArray new];
//    if (items.count >= 1) {
//        NaviBarItemData *data = [items firstObject];
//        NaviBarItem *item1 = [self genderbaritem:data itemtype:[data.type integerValue] :@selector(touchitem_right:)];
//        [tmp addObject:item1];
//    }
//    if (items.count >= 2) {
//        NaviBarItemData *data = [items objectAtIndex:1];
//        NaviBarItem *item2 = [self genderbaritem:data itemtype:[data.type integerValue] :@selector(touchitem_right:)];
//        [tmp addObject:item2];
//    }
//    if (items.count >= 3) {
//        NaviBarItemData *data = [items objectAtIndex:2];
//        NaviBarItem *item3 = [self genderbaritem:data itemtype:[data.type integerValue] :@selector(touchitem_right:)];
//        [tmp addObject:item3];
//    }
//    self.naviBar.rightBarItems = tmp;
//    self.touchright = touchevet;
//}
//- (void)touchitem_left:(UIButton *)item{
//    NaviBarItem *itemview = (id )item.superview;
//    if ([itemview isKindOfClass:[NaviBarItem class]]) {
//        if (self.touchright) {
//            self.touchleft(itemview.itemobject,1);
//        }
//    }
//}
//- (void)touchitem_right:(UIButton *)item{
//    NaviBarItem *itemview = (id )item.superview;
//    if ([itemview isKindOfClass:[NaviBarItem class]]) {
//        if (self.touchright) {
//            self.touchright(itemview.itemobject,1);
//        }
//    }
//}
//

#pragma mark - center
- (void)navi_centerview:(NSArray *)items{

    
}
@end
