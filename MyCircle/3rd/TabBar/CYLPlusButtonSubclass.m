//
//  CYLPlusButtonSubclass.m
//  DWCustomTabBarDemo
//
//  Created by 微博@iOS程序犭袁 (http://weibo.com/luohanchenyilong/) on 15/10/24.
//  Copyright (c) 2015年 https://github.com/ChenYilong . All rights reserved.
//

#import "CYLPlusButtonSubclass.h"
#import "SendViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "UIImage+ImageEffects.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "XFAppContext.h"
#import "UtilsMacro.h"
#import "LoginViewController.h"

@interface CYLPlusButtonSubclass () {
    CGFloat _buttonImageHeight;
}
@end
@implementation CYLPlusButtonSubclass

#pragma mark -
#pragma mark - Life Cycle

+(void)load {
    [super registerSubclass];
}

#pragma mark -
#pragma mark - Life Cycle

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
    }
    
    return self;
}

//上下结构的 button
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 控件大小,间距大小
    CGFloat const imageViewEdge   = self.bounds.size.width * 1.8;//1.0
    CGFloat const centerOfView    = self.bounds.size.width * 0.5;
    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
    CGFloat const verticalMarginT = self.bounds.size.height - labelLineHeight - imageViewEdge;
    CGFloat const verticalMargin  = verticalMarginT / 2;
    
    // imageView 和 titleLabel 中心的 Y 值
    CGFloat const centerOfImageView  = verticalMargin + imageViewEdge * 0.6;
    CGFloat const centerOfTitleLabel = imageViewEdge  + verticalMargin * 2 + labelLineHeight * 0.5 + 5;
    //imageView position 位置
    
    self.imageView.bounds = CGRectMake(0, 0, imageViewEdge, imageViewEdge);
    self.imageView.backgroundColor = [UIColor orangeColor];
    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);
    
    //title position 位置
    
    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
}

#pragma mark -
#pragma mark - Public Methods
/*
 *
 Create a custom UIButton with title and add it to the center of our tab bar
 *
 */
+ (instancetype)plusButton{

    CYLPlusButtonSubclass *button = [[CYLPlusButtonSubclass alloc]init];
    
    [button setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    //[button setTitle:@"发布" forState:UIControlStateNormal];

    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:9.5];
    [button sizeToFit];

    [button addTarget:button action:@selector(clickPublish) forControlEvents:UIControlEventTouchUpInside];

    return button;
}

#pragma mark -
#pragma mark - Event Response

- (void)clickPublish {
    //获取tabbar
    UITabBarController *tabbar = (UITabBarController *)((AppDelegate *)[UIApplication sharedApplication].delegate).drawerController.centerViewController;
    //UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UIViewController *viewController = tabbar.selectedViewController;
    
    if (ISEMPTY([XFAppContext sharedContext].uid)) {
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNC = [[UINavigationController alloc] initWithRootViewController:login];
        [viewController presentViewController:loginNC animated:YES completion:nil];
        return;
    }
    
//    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
//                                                            delegate:nil
//                                                   cancelButtonTitle:@"取消"
//                                              destructiveButtonTitle:nil
//                                                   otherButtonTitles:@"拍照", @"从相册选取", @"淘宝一键转卖", nil];
//    [actionSheet showInView:viewController.view];
    
    //截取当前屏幕模糊化
    UIGraphicsBeginImageContextWithOptions(viewController.view.frame.size, NO, 0.5);
    [viewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    image = [image applyBlurWithRadius:20 tintColor:[UIColor colorWithWhite:0.8 alpha:0.3] saturationDeltaFactor:1.2 maskImage:nil];
    
    SendViewController *sendVC = [[SendViewController alloc] init];
    sendVC.view.backgroundColor = [UIColor colorWithPatternImage:image];//将模糊的图片作为背景
    sendVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *sendNC = [[UINavigationController alloc] initWithRootViewController:sendVC];
    //重写模态页面动画
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[viewController.view layer] addAnimation:animation forKey:@"sendDismiss"];
    
    [viewController presentViewController:sendNC animated:NO completion:nil];
    UIGraphicsEndImageContext();

}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex = %ld", buttonIndex);
}
//调节上下位置
+ (CGFloat)multiplerInCenterY {
    return  0.5;
}



@end
