//
//  SetVC.m
//  MyCircle
//
//  Created by and on 15/12/30.
//  Copyright © 2015年 and. All rights reserved.
//

#import "SetVC.h"

@interface SetVC ()

@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backItemImage"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];
    
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
