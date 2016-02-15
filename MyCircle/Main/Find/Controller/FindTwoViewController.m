//
//  FindTwoViewController.m
//  MyCircle
//
//  Created by and on 15/12/6.
//  Copyright © 2015年 and. All rights reserved.
//

#import "FindTwoViewController.h"

@interface FindTwoViewController ()
{
    UIView *_backView;
}

@end

@implementation FindTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 113)];
    _backView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_backView];
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
