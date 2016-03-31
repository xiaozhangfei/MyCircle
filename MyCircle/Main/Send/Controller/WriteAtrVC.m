//
//  WriteAtrVC.m
//  MyCircle
//
//  Created by and on 16/3/18.
//  Copyright © 2016年 and. All rights reserved.
//

#import "WriteAtrVC.h"
#import "ArtView.h"
#import "ToolBarToastView.h"

#import "MMMarkdown.h"

@interface WriteAtrVC ()

@property (strong, nonatomic) ArtView *artView;
@property (strong, nonatomic) ToolBarToastView *toast;

@property (strong, nonatomic) UIWebView *web;
@end

@implementation WriteAtrVC

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    rightImg.image = [UIImage imageNamed:@"pay_open_touchID_success"];
    [rightImg addTapCallBack:self sel:@selector(rightBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightImg];
    
    
    [self initView];
    [self initData];
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButtonAction:(UIBarButtonItem *)sender {
    NSError  *error;
    NSString *markdown   = _artView.textView.text;
    NSString *htmlString =  [MMMarkdown HTMLStringWithMarkdown:markdown error:&error];
    NSLog(@"html = %@",htmlString);
    
    // 获取当前应用的根目录
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    // 通过baseURL的方式加载的HTML
    // 可以在HTML内通过相对目录的方式加载js,css,img等文件
    [_web loadHTMLString:htmlString baseURL:baseURL];
    _web.hidden = NO;
    _artView.hidden = YES;
}

- (void)initView {
    _artView = [[ArtView alloc] initWithFrame:CGRectMake(0, NavigetionBarHeight, WIDTH(self.view), HEIGHT(self.view))];
    [self.view addSubview:_artView];
    
    _web = [[UIWebView alloc] initWithFrame:_artView.frame];
    [self.view addSubview:_web];
    _web.hidden = YES;
    
    
    
//    _toast = [[ToolBarToastView alloc] initWithFrame:CGRectMake(30, 100, WIDTH(self.view) - 60, 80)];
//    [self.view addSubview:_toast];
}

- (void)initData {
    
}
/**
 *  上传数据
 */
- (void)pushData {
    
}


@end
