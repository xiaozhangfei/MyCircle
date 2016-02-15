//
//  AdVC.m
//  MyCircle
//
//  Created by and on 15/12/18.
//  Copyright © 2015年 and. All rights reserved.
//

#import "AdVC.h"
#import "AppDelegate.h"

@interface AdVC ()

@end

@implementation AdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"广告";
    //设置对应的导航条的返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    [((AppDelegate *)[UIApplication sharedApplication].delegate) setWindowRootVC];
    
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
