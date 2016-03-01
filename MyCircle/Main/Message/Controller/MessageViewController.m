//
//  MessageViewController.m
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import "MessageViewController.h"
#import "CircleDetailViewController.h"
#import "Mes1ViewController.h"
#import "Mes3ViewController.h"

#import <Qiniu/QiniuSDK.h>
#import <QNUploadManager.h>

#import "MyControl.h"
@interface MessageViewController () <UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIScrollView *scroll;

@property (copy, nonatomic) NSString *uptoken;
@end

@implementation MessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightAction:)];


}


- (void)rightAction:(UIBarButtonItem *)sender {
    
    NSLog(@"添加");
    // 段子
    Mes1ViewController *wordVc = [[Mes1ViewController alloc] init];
    wordVc.title = @"添加的";
    [self addChildViewController:wordVc];

    [self refreshDisplay];
}


@end
