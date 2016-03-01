//
//  BaseViewController.h
//  MyCircle
//
//  Created by and on 15/10/31.
//  Copyright © 2015年 and. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BaseViewController : UIViewController

- (void)showToast:(NSString *)msg;

- (void)addNotification; // called in viewDidLoad, need to be reimplemented
- (void)removeNotification; // called in dealloc, need to be reimplemented

// hud functions
- (void)showHUD;
- (void)showHUDWithLabel:(NSString *)msg;

- (void)hideHUD;
- (void)hideHUDAfterDelay:(float)delay;

//注册通知方法
- (void)registerNotificationWithObserver:(id)Observer selector:(SEL)sel name:(NSString *)name object:(id)info;

#pragma mark - 空数据提示视图
- (void)showInfoView:(NSString *)imgName withInfoText:(NSString *)info withText:(NSString *)text superView:(UIView *)view;

- (void)hiddenInfoView;

- (void)showXFToastWithText:(NSString *)text image:(UIImage *)image;

- (void)pushVC:(UIViewController *)vc animated:(BOOL)animated;

-(void)rotation_icon:(float)n;

@end
