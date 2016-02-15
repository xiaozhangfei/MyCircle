//
//  WeatherVC.m
//  MyCircle
//
//  Created by and on 15/12/30.
//  Copyright © 2015年 and. All rights reserved.
//

#import "WeatherVC.h"
#import "CityVC.h"

@interface WeatherVC ()

@end

@implementation WeatherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonAction:(UIBarButtonItem *)sender {
    //定位，或选择城市
    CityVC *city = [[CityVC alloc] init];
    city.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:city animated:YES];
    //重写navigationBar按钮方法时，开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (void)initView {
    self.title = @"天气";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backItemImage"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sight_icon_location_selected"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonAction:)];

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
