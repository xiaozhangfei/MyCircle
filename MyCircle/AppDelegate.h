//
//  AppDelegate.h
//  MyCircle
//
//  Created by and on 15/10/30.
//  Copyright © 2015年 and. All rights reserved.
//

#import <UIKit/UIKit.h>
//融云
#import <RongIMKit/RongIMKit.h>
//侧滑
#import "MMDrawerController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCIMConnectionStatusDelegate, RCIMUserInfoDataSource>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) MMDrawerController *drawerController;


@property (nonatomic, assign) BOOL inNightMode;

- (void)setWindowRootVC;

/**
 *  打开侧滑
 */
- (void)setOpenDrawerController;
/**
 *  关闭侧滑
 */
- (void)setCloseDrawerController;
/**
 *  展开左侧vc
 */
- (void)showLeftController;
/**
 *  在侧滑栏中push
 *
 *  @param vc 需要显示的vc
 */
- (void)pushLeftWithVC:(UIViewController *)vc;

- (void)connectRC;
//获取头像等信息
- (RCUserInfo *)getUserInfoWithUid:(NSString *)uid;

@end

