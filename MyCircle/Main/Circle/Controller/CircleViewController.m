//
//  CircleViewController.m
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import "CircleViewController.h"

//tab 0
#import "CircleHotPageViewController.h"
#import "CircleNewPageViewController.h"
#import "CircleAllPageViewController.h"

#import "AppDelegate.h"
#import <UIImageView+WebCache.h>

#import "NirKxMenu.h"
#import "Language.h"

@interface CircleViewController ()
{
    UIView *_backView;
    UIImageView *_leftImv;
    KxMenuItem *_item;
}

@end

@implementation CircleViewController

#pragma mark -- 所有一级页面加上此方法，防止二级页面侧滑
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)) setOpenDrawerController];
    //[self setUpVc:2];
    //self.contentScrollView.contentOffset = CGPointMake(2 * [UIScreen mainScreen].bounds.size.width, 0);
    //[self jumpToPage:2];
    //UITapGestureRecognizer *tap = [UITapGestureRecognizer alloc] initWithTarget:self. action:<#(nullable SEL)#>;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)) setCloseDrawerController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"tab_circle", @"tab_");
    
    [self initView];
    [self registerNoti];
}

#pragma mark ---- 注册通知
- (void)registerNoti {
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(portraitChange:) name:@"REFRESHPORTRAIT" object:nil];
    
}

- (void)portraitChange:(NSNotification *)sender {
    if (!ISEMPTY([XFAppContext sharedContext].portrait)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_leftImv sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:[XFAppContext sharedContext].portrait]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            }];
        });
    }
}

- (void)initView {
    
    //左右BarButton
    _leftImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    _leftImv.layer.masksToBounds = YES;
    _leftImv.layer.cornerRadius = 18;
    _leftImv.image = [UIImage imageNamed:@"women"];
    if (!ISEMPTY([XFAppContext sharedContext].portrait)) {
        [_leftImv sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:[XFAppContext sharedContext].portrait]] placeholderImage:[UIImage imageNamed:@"women"] completed:nil];
    }
    _leftImv.userInteractionEnabled = YES;
    [_leftImv addTapCallBack:self sel:@selector(leftBarButtonAction:)];
    //self.navigationController.navigationBarHidden= YES;
    //self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftImv];
    
    UIImageView *rightImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    rightImv.layer.masksToBounds = YES;
    rightImv.layer.cornerRadius = 18;
    rightImv.image = [UIImage imageNamed:@"cancel"];
    [rightImv addTapCallBack:self sel:@selector(rightBarAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightImv];

    // 添加所有子控制器
    [self setUpAllViewController];
    self.selColor = HexColor(0x51B9C7);//选中颜色
    self.norColor = [UIColor blackColor];
    self.titleScrollViewColor = [UIColor whiteColor];
    self.isSampTitleWidth = NO;
    // 推荐方式（设置下标）
    [self setUpUnderLineEffect:^(BOOL *isShowUnderLine, BOOL *isDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor) {
        // 是否显示标签
        *isShowUnderLine = YES;
        // 标题填充模式
        *underLineColor = HexColor(0x51B9C7);
        // 是否需要延迟滚动,下标不会随着拖动而改变
        //        *isDelayScroll = YES;
    }];
    
    // 设置全屏显示
    // 如果有导航控制器或者tabBarController,需要设置tableView额外滚动区域,详情请看FullChildViewController
    self.isfullScreen = NO;
}
// 添加所有子控制器
- (void)setUpAllViewController
{
    CircleHotPageViewController *c1 = [[CircleHotPageViewController alloc] init];
    c1.title = NSLocalizedString(@"circle_hot", @"tab_");
    [self addChildViewController:c1];
    
    CircleNewPageViewController *c2 = [[CircleNewPageViewController alloc] init];
    c2.title = NSLocalizedString(@"circle_new", @"tab_");
    [self addChildViewController:c2];
    
    CircleAllPageViewController *c3 = [[CircleAllPageViewController alloc] init];
    c3.title = NSLocalizedString(@"circle_all", @"tab_");
    [self addChildViewController:c3];

}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    [(AppDelegate *)([UIApplication sharedApplication].delegate) showLeftController];
}

- (void)rightBarAction:(UIGestureRecognizer *)sender {
    
    _item = [KxMenuItem menuItem:@"第一个" image:[UIImage imageNamed:@"pc_edit_big"] target:self action:@selector(rightBarMenuAction:)];
    NSArray *arr = @[_item,
                     [KxMenuItem menuItem:@"第2个" image:[UIImage imageNamed:@"pc_edit_big"] target:self action:@selector(rightBarMenuAction:)],
                     [KxMenuItem menuItem:@"第3个" image:[UIImage imageNamed:@"pc_edit_big"] target:self action:@selector(rightBarMenuAction:)],
                     [KxMenuItem menuItem:@"第4个" image:[UIImage imageNamed:@"pc_edit_big"] target:self action:@selector(rightBarMenuAction:)]];
    [KxMenu setTitleFont:[UIFont systemFontOfSize:15.0f]];
    OptionalConfiguration optionCon;
    optionCon.arrowSize = 9;  //指示箭头大小
    optionCon.marginXSpacing = 7;  //MenuItem左右边距
    optionCon.marginYSpacing = 9;  //MenuItem上下边距
    optionCon.intervalSpacing = 25;  //MenuItemImage与MenuItemTitle的间距
    optionCon.menuCornerRadius = 6.5;  //菜单圆角半径
    optionCon.maskToBackground = true;  //是否添加覆盖在原View上的半透明遮罩
    optionCon.shadowOfMenu = false;  //是否添加菜单阴影
    optionCon.hasSeperatorLine = true;  //是否设置分割线
    optionCon.seperatorLineHasInsets = false;  //是否在分割线两侧留下Insets
    //optionCon.textColor = RGB();  //menuItem字体颜色
    //optionCon.menuBackgroundColor = [UIColor whiteColor];  //菜单的底色
    CGRect rect = sender.view.frame;
    rect.origin.y += 25;
    [KxMenu showMenuInView:APP_WINDOW fromRect:rect menuItems:arr withOptions:optionCon];
}

- (void)rightBarMenuAction:(KxMenuItem *)sender {
    NSLog(@"tap -- %@" ,sender.title);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [KxMenu dismissMenu];
}

- (void)rotation_icon:(float)n {
    if (n == 0) {
        //[self refreshDisplay];
        
    }
}



@end
