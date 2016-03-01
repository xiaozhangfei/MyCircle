//
//  BaseViewController.m
//  MyCircle
//
//  Created by and on 15/10/31.
//  Copyright © 2015年 and. All rights reserved.
//

#import "BaseViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "iToast.h"
#import "AppMacro.h"
#import "UtilsMacro.h"
#import "XFTopToast.h"


@interface BaseViewController ()<UIAlertViewDelegate>
{
    UIView *_bgView;
    NSMutableArray *items;
}
@property (nonatomic, strong) MBProgressHUD *hud;


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1.0];
    
    [self addNotification];
    
    [self addobserver];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeobserver];
}

#pragma mark - iToast Functions
- (void)showToast:(NSString *)msg
{
    [[iToast makeText:msg] show];
}



#pragma mark -- notification

//注册通知方法
- (void)registerNotificationWithObserver:(id)Observer selector:(SEL)sel name:(NSString *)name object:(id)info
{
    [[NSNotificationCenter defaultCenter] addObserver:Observer selector:sel name:name object:info];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(todayNotiAction:) name:@"todayNoti" object:nil];
}

- (void)todayNotiAction:(NSNotification *)sender {
    NSLog(@"today----------");
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"todayNoti" object:nil];
}

#pragma mark -  HUD Functions
- (void)showHUD
{
    [self showHUDWithLabel:@"加载数据"];
}

- (void)showHUDWithLabel:(NSString *)msg
{
    [self hideHUD];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    self.hud.labelText = msg;
    [self.hud show:YES];
}

- (void)hideHUD
{
    if (self.hud) {
        [self.hud hide:YES afterDelay:0];
        self.hud = nil;
    }
}
- (void)hideHUDAfterDelay:(float)delay
{
    if (self.hud) {
        [self.hud hide:YES afterDelay:delay];
        self.hud = nil;
    }
}

#pragma mark --- 空数据处理
//图片名字  提示文本 上下   父视图
- (void)showInfoView:(NSString *)imgName withInfoText:(NSString *)info withText:(NSString *)text superView:(UIView *)view
{
    _bgView.hidden = NO;
    if (_bgView) {
        
        [_bgView removeFromSuperview];
        _bgView = nil;
    }
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_WIDTH_XF(78), SCREEN_WIDTH, SCREEN_WIDTH_XF(140))];
    _bgView.backgroundColor = [UIColor clearColor];
    [view addSubview:_bgView];
    
    //    if ([info isEqualToString:@"暂无视频"] || [info isEqualToString:@"暂无评论"] || [info isEqualToString:@"你还没有粉丝,完善个人信息会让更"]) {
    //
    //        _bgView.frame = CGRectMake(0,SCREEN_WIDTH_XF(118), SCREEN_WIDTH, SCREEN_WIDTH_XF(140));
    //    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH_XF(75))/2.0f, 0, SCREEN_WIDTH_XF(75), SCREEN_WIDTH_XF(75))];
    imgView.image = [UIImage imageNamed:imgName];
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame)+SCREEN_WIDTH_XF(15), SCREEN_WIDTH, SCREEN_WIDTH_XF(15))];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = UIColorFromRGB(170, 170, 170);
    infoLabel.font = UIFontOfSize(14);
    infoLabel.text = info;
    [_bgView addSubview:infoLabel];
    UILabel *ifLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(infoLabel.frame)+SCREEN_WIDTH_XF(5), SCREEN_WIDTH, SCREEN_WIDTH_XF(15))];
    ifLabel.textAlignment = NSTextAlignmentCenter;
    ifLabel.textColor = UIColorFromRGB(170, 170, 170);
    ifLabel.font = UIFontOfSize(14);
    ifLabel.text = text;
    [_bgView addSubview:ifLabel];
    [_bgView addSubview:imgView];
}

//隐藏 空数据视图
- (void)hiddenInfoView
{
    
    _bgView.hidden = YES;
    _bgView.userInteractionEnabled = YES;
    [_bgView removeFromSuperview];
    _bgView = nil;
    
}



#pragma mark -
#pragma mark - xfToast
- (void)showXFToastWithText:(NSString *)text image:(UIImage *)image {
    [XFTopToast showXFTopViewWithText:text image:image leftOffset:10 topOffset:20 backColor:[UIColor orangeColor] time:2.0f];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark -- pushVC
- (void)pushVC:(UIViewController *)vc animated:(BOOL)animated {
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    //重写navigationBar按钮方法时，开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait;
}

- (void)addobserver{
    // Do any additional setup after loading the view from its nib.
    //----- SETUP DEVICE ORIENTATION CHANGE NOTIFICATION -----
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
    [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];
}

- (void)removeobserver{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [nc removeObserver:self name:UIDeviceOrientationDidChangeNotification object:device];
}

- (void)orientationChanged:(NSNotification *)note  {      UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
    switch (o) {
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
            [self  rotation_icon:0.0];
            break;
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
            [self  rotation_icon:180.0];
            break;
        case UIDeviceOrientationLandscapeLeft :      // Device oriented horizontally, home button on the right
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
            
            [self  rotation_icon:90.0*3];
            break;
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:YES];
            
            [self  rotation_icon:90.0];
            break;
        default:
            break;
    }
}

-(void)rotation_icon:(float)n {
    
}

@end
