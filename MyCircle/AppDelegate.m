//
//  AppDelegate.m
//  MyCircle
//
//  Created by and on 15/10/30.
//  Copyright © 2015年 and. All rights reserved.
//

#import "AppDelegate.h"

#import <CYLTabBarController.h>
#import "CYLPlusButtonSubclass.h"

#import "CircleViewController.h"
#import "ChatListVC.h"
#import "SendViewController.h"
#import "FindViewController.h"
#import "MeViewController.h"


//侧滑 左右页面
#import "LeftViewController.h"
#import "RightViewController.h"

#import "MMExampleDrawerVisualStateManager.h"

#import "UIColor+Utils.h"

//touchVC
#import "TouchIDViewController.h"
//登录
#import "LoginViewController.h"
//访问钥匙串
#import "SFHFKeychainUtils.h"
//验证码
#import <SMS_SDK/SMSSDK.h>
//信鸽推送
#import "XGPush.h"


#import "XFHomeView.h"

#import "LaunchVC.h"

#import "AppDelegate+ZXFJSPatch.h"

#import <MobClick.h>
#import "MiscTool.h"


#define kTime 5

@interface AppDelegate () <UITabBarControllerDelegate>
{
    XFHomeView *xfHomeView;
    
    NSString *aesCon;
    
    SecKeyRef _public_key;
}
@property (strong, nonatomic) CYLTabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    //设置navi
    [self setUpNavigationBarAppearance];    
    
    //首先进入Launch页面
    LaunchVC *launch = [[LaunchVC alloc] init];
    UINavigationController *launchNC = [[UINavigationController alloc] initWithRootViewController:launch];
    self.window.rootViewController = launchNC;

    //self.window.rootViewController = self.drawerController;
    //[MiscTool deviceIPAdress];//本地ip
    
    //测试，Today
    NSUserDefaults *userDefault=[[NSUserDefaults alloc] initWithSuiteName:@"group.MyCircleContainer"];
    [userDefault setObject:@"侠之大者，为国为民" forKey:@"xia"];
    [userDefault synchronize];
    
    NSLog(@"sss %@",[userDefault valueForKey:@"xia"]);
    XFAppContext *context = [XFAppContext sharedContext];
    NSLog(@"uid = %@",context.uid);
    NSLog(@"token  = %@",context.token);
    
    
    //初始化key
    [self initKeyAndSecretWithOptions:(NSDictionary *)launchOptions];
    
    [MobClick startWithAppkey:UmengAppKey reportPolicy:BATCH channelId:@"Ceshi"];

    //初始化push
    [self initPush];
    
//    //初始化自定义小圆点
//    xfHomeView = [XFHomeView defaultSetHomeTouchViewWithTitleArray:@[@"主屏幕",@"111",@"222",@"333",@"444"] iconArray:@[@"Action_Moments",@"cancel",@"find",@"circle",@"man"]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xfHomeViewTapAction:) name:@"xfHomeViewTapNoti" object:nil];
    
    //jsPatch
    //[self getUpJS];
    
    return YES;
}

#pragma mark -
- (void)xfHomeViewTapAction:(NSNotification *)sender
{
    NSLog(@"ssss --- %@",[sender object]);
    NSString * message = [NSString stringWithFormat:@"点击第%@个按钮",[sender object]];
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"通知" message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -- 初始化tabBar
- (void)setTabBar {
    
    CircleViewController *circleVC            = [[CircleViewController alloc] init];
    UINavigationController *circleNC          = [[UINavigationController alloc] initWithRootViewController:circleVC];
    circleVC.tabBarController.selectedIndex   = 1001;

    ChatListVC *chatListVC                    = [[ChatListVC alloc] init];
    UINavigationController *messageNC         = [[UINavigationController alloc] initWithRootViewController:chatListVC];
    chatListVC.tabBarController.selectedIndex = 1002;

    FindViewController *findVC                = [[FindViewController alloc] init];
    UINavigationController *findNC            = [[UINavigationController alloc] initWithRootViewController:findVC];
    findVC.tabBarController.selectedIndex     = 1003;

    MeViewController *meVC                    = [[MeViewController alloc] init];
    UINavigationController *meNC              = [[UINavigationController alloc] initWithRootViewController:meVC];
    meVC.tabBarController.selectedIndex       = 1004;

    CYLTabBarController *tabBarController     = [[CYLTabBarController alloc] init];
    [self customizeTabBarForController:tabBarController];
    
    [tabBarController setViewControllers:@[
                                           circleNC,
                                           messageNC,
                                           findNC,
                                           meNC
                                           ]];
    self.tabBarController = tabBarController;
    self.tabBarController.delegate = self;
    //去除 TabBar 自带的顶部阴影
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    //设置nav,tab样式
    [self customizeInterface];
}

#pragma mark -- 初始化侧滑
/**
 *  初始化侧滑
 */
- (void)initDrawerController {
    
    //左侧页面
    LeftViewController *leftVC     = [[LeftViewController alloc] init];
    UINavigationController *leftNC = [[UINavigationController alloc] initWithRootViewController:leftVC];
    //中间tabBar
    [self setTabBar];
    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabBackImage"]];
    
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:self.tabBarController
                             leftDrawerViewController:leftNC
                             rightDrawerViewController:nil];
    [self.drawerController setShowsShadow:YES];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    //[self.drawerController setMaximumRightDrawerWidth:10.0];
    //leftVC宽度
    [self.drawerController setMaximumLeftDrawerWidth:self.window.frame.size.width - SCREEN_CURRETWIDTH(150)];
    
    [self setOpenDrawerController];
    //配置动画的回调函数
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
}

- (void)setWindowRootVC {
    //设置rootVC
    [self initDrawerController];
    
    self.window.rootViewController = self.drawerController;
}

- (void)setOpenDrawerController {
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}

- (void)setCloseDrawerController {
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
}

- (void)showLeftController {
    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}

- (void)pushLeftWithVC:(UIViewController *)vc {
    //先推下一页
    UITabBarController *tab = (UITabBarController *)self.drawerController.centerViewController;
    UINavigationController *nav = tab.selectedViewController;
    vc.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:vc animated:YES];
    //重写navigationBar按钮方法时，开启iOS7的滑动返回效果
    if ([nav respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        nav.interactivePopGestureRecognizer.delegate = nil;
    }
    //隐藏侧边栏
    [self.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}

#pragma mark -- 初始化各种key 、 secret
- (void)initKeyAndSecretWithOptions:(NSDictionary *)launchOptions {
    //初始化应用，appKey和appSecret从后台申请得到
    [SMSSDK registerApp:mobAppKey
             withSecret:mobAppSecret];
    
    [XGPush startApp:xgAppKey appKey:xgAppSecret];
    [XGPush handleLaunching: launchOptions];
    
    //初始化融云
    [[RCIM sharedRCIM] initWithAppKey:RCKey];
    [RCIM sharedRCIM].globalNavigationBarTintColor = HexColor(0x51B9C7);
    if (ISEMPTY([XFAppContext sharedContext].rctoken)) {
        NSLog(@"融云token为空");
    }else {
        [self connectRC];
    }
}
//连接融云服务器
- (void)connectRC {
    
    [[RCIM sharedRCIM] connectWithToken:[XFAppContext sharedContext].rctoken success:^(NSString *userId) {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
        //设置用户信息提供者,页面展现的用户头像及昵称都会从此代理取
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    
    RCUserInfo *user = [self getUserInfoWithUid:userId];
    return completion(user);
    
}

- (RCUserInfo *)getUserInfoWithUid:(NSString *)uid {
    if ([uid isEqualToString:[XFAppContext sharedContext].uid]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = [XFAppContext sharedContext].uid;
        user.name = [XFAppContext sharedContext].nickname;
        user.portraitUri = [XFAPI image_url:[XFAppContext sharedContext].portrait];
        return user;
    }
    //根据userid从数据库中取出对应的user
    
    if ([uid isEqualToString:@"1"]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"1";
        user.name = @"爆炸糖";
        user.portraitUri = [XFAPI image_url:@"e940d1ad2ac05c8965da7025d0d806c6"];
        return user;
    }else {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = @"3";
        user.name = @"小金刚";
        user.portraitUri = [XFAPI image_url:@"1235.jpg"];
        return user;
    }
    
    //如数据库中没有，则从服务器获取，获取后把内容缓存到数据库
//    [AFHTTPRequestOperationManager postWithURLString:[XFAPI getrc] parameters:@{@"uid":uid} success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
//        if (![baseModel.code isEqual:@"200"]) {
//            NSLog(@"%@",baseModel.s_description);
//            return ;
//        }
//        NSDictionary *dict = responseDict[@"user"];
//        RCUserInfo *user = [[RCUserInfo alloc]init];
//        user.userId = dict[@"uid"];
//        user.name = dict[@"nickname"];
//        user.portraitUri = [XFAPI image_url:dict[@"portrait"]];
//        
//        return user;
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
//        NSLog(@"网络错误，获取信息失败。error = %@",error);
//        RCUserInfo *user = [[RCUserInfo alloc]init];
//        user.userId = uid;
//        user.name = @"错误";
//        user.portraitUri = @"message_send_fail_status";
//        
//        return user;
//    }];
}

#pragma mark -- 初始化推送
- (void)initPush {
    //注册Push服务，注册后才能收到推送
    //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    [self registerPushForIOS8]; //具体实现参考Demo
#else
    //iOS8之前注册push方法
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#endif
}

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}




/*
 *
 在`-setViewControllers:`之前设置TabBar的属性，
 *
 */
- (void)customizeTabBarForController:(CYLTabBarController *)tabBarController {
    
    NSLog(@"xxx %@",NSLocalizedString(@"projectName", @"工程名__"));
    
    NSArray *titles = @[NSLocalizedString(@"tab_circle", @"tab_"),
                        NSLocalizedString(@"tab_message", @"tab_"),
                        NSLocalizedString(@"tab_find", @"tab_"),
                        NSLocalizedString(@"tab_me", @"tab_")];
    NSLog(@"xx title = %@",titles);
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : titles[0],
                            CYLTabBarItemImage : @"circle_no",
                            CYLTabBarItemSelectedImage : @"circle",
                            };
    
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : titles[1],
                            CYLTabBarItemImage : @"message_no",
                            CYLTabBarItemSelectedImage : @"message",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : titles[2],
                            CYLTabBarItemImage : @"find_no",
                            CYLTabBarItemSelectedImage : @"find",
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : titles[3],
                            CYLTabBarItemImage : @"man_no",
                            CYLTabBarItemSelectedImage : @"man",
                            };
    
    
    NSArray *tabBarItemsAttributes = @[ dict1, dict2, dict3, dict4];
    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes;
}

- (void)customizeInterface {
    [self setUpNavigationBarAppearance];
    [self setUpTabBarItemTextAttributes];
}
/**
 *  设置navigationBar样式
 */
- (void)setUpNavigationBarAppearance {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(34, 34, 34)};
    [navigationBarAppearance setTitleTextAttributes:navbarTitleTextAttributes];
    [navigationBarAppearance setTintColor:UIColorFromRGB(51, 51, 51)];
    [navigationBarAppearance setBarTintColor:[UIColor navigationbarColor]];
    
}

/**
 *  tabBarItem 的选中和不选中文字属性
 */
- (void)setUpTabBarItemTextAttributes {
    
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
    
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    // 设置文字属性
    //UITabBarItem *tabBar = [UITabBarItem appearance];
    // [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    // [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateHighlighted];
}

#pragma mark -- 弹出验证指纹框
- (void)showTouchVC {
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
//    TouchIDViewController *touch = [[TouchIDViewController alloc] init];
//    UINavigationController *touchNC = [[UINavigationController alloc] initWithRootViewController:touch];
//    touchNC.navigationBarHidden = YES;
//    [self.window.rootViewController presentViewController:touchNC animated:YES completion:^{
//        
//    }];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[self showTouchVC];
    //每次进入时执行js
    //[self execJs];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    //当前选中的tab
    UIViewController *selectTab = tabBarController.selectedViewController;
    //vc:  将要选中的tab
    //判断是不是选择了自己
    if (![selectTab isEqual:viewController] && ([viewController isEqual:tabBarController.viewControllers[3]] || [viewController isEqual:tabBarController.viewControllers[1]])) {
        //XFAppContext *context = [XFAppContext sharedContext];
        if (ISEMPTY([XFAppContext sharedContext].uid)) {//模态出登录界面
            LoginViewController *login = [[LoginViewController alloc] init];
            UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:login];
            [self.window.rootViewController presentViewController:loginNC animated:YES completion:nil];
            return NO;
        }
        
    }
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush Demo]register successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush Demo]register errorBlock");
    };
    
    NSString *deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"[XGPush Demo] deviceTokenStr is %@",deviceTokenStr);
    //注册融云
    NSString *token = [deviceToken description];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    NSLog(@"融云注册token成功");
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"[XGPush Demo]%@",str);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    NSDictionary *dict = userInfo;
    NSLog(@"dict = %@",dict);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信鸽推送消息" message:dict[@"aps"][@"message"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert show];

}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    //获取消息后，本地推送
    
}

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"您的帐号在别的设备上登录，您被迫下线！"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
        //操作
    }
}


#pragma mark openUrl
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.description hasPrefix:@"Today"]) {
        //你的处理逻辑
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:url.host
                              message:@"来源于Today扩展"
                              delegate:nil
                              cancelButtonTitle:@"知道了"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    return NO;
}



@end
