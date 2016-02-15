//
//  PracticeVC.m
//  MyCircle
//
//  Created by and on 15/12/19.
//  Copyright © 2015年 and. All rights reserved.
//

#import "PracticeVC.h"
#import "RxWebViewController.h"
#import "RxLabel.h"
#import "XFAppContext.h"

#import <LocalAuthentication/LocalAuthentication.h>

#define UIColorFromHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface PracticeVC () <RxLabelDelegate>

@end

@implementation PracticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
    
    self.view.backgroundColor = [UIColor brownColor];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    button.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    RxLabel *label = [[RxLabel alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40, 200)];
    label.backgroundColor = [UIColor whiteColor];
    label.delegate = self;
    label.text = @"长者，指年纪大、辈分高、德高望重的人。http://www.baidu.com 一般多用于对别人的尊称，也可用于自称。能被称为长者的人往往具有丰富的人生经验，可以帮助年轻人提高姿势水平 http://github.com";
    label.customUrlArray = @[
                             @{
                                 @"scheme":@"baidu",
                                 @"color":@0X459df5,
                                 @"title":@"百度"
                                 },
                             @{
                                 @"scheme":@"github",
                                 @"color":@0X333333,
                                 @"title":@"Github"
                                 }
                             ];
    [self.view addSubview:label];
    
    
    //设置对应的导航条的返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction1:)];
}

- (void)leftBarButtonAction1:(id )sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- RxLabel代理
-(void)RxLabel:(RxLabel *)label didDetectedTapLinkWithUrlStr:(NSString *)urlStr{
    RxWebViewController* webViewController = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:urlStr]];
    [self.navigationController pushViewController:webViewController animated:YES];
    
    //重写navigationBar按钮方法时，开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
}


- (void)btnAction:(UIButton *)sender {
    
    RxWebViewController *webVC = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://www.baidu.com"]];
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    
    //重写navigationBar按钮方法时，开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
}



@end