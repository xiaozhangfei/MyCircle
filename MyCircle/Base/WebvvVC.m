//
//  WebVC.m
//  MyCircle
//
//  Created by and on 16/3/7.
//  Copyright © 2016年 and. All rights reserved.
//

#import "WebvvVC.h"
#import "WebViewJavascriptBridge.h"
#import "D3Generator.h"
#import "NSObject+D3.h"

@interface WebvvVC () <UIWebViewDelegate>
{
    UIWebView *_webView;
    
}
@property(nonatomic,strong)WebViewJavascriptBridge *bridge;


@end

@implementation WebvvVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = !_showNav;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = !_showNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)initView {
    
}

- (void)initData {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
