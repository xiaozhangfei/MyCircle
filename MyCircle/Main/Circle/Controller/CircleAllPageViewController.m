//
//  CircleAllPageViewController.m
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import "CircleAllPageViewController.h"
#import "UtilsMacro.h"

#import "UIScrollView+XFRefresh.h"

@interface CircleAllPageViewController () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tv;
}

@end

@implementation CircleAllPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)initView {
    self.view.backgroundColor = HexColor(0xFBF7ED);
    _tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 120) style:(UITableViewStyleGrouped)];
    _tv.delegate = self;
    _tv.dataSource = self;
    [self.view addSubview:_tv];
    
    [_tv registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [_tv addXFRefreshHeader];
}

- (void)initData {
    
}



#pragma mark -- tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_CURRETWIDTH(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SCREEN_CURRETWIDTH(10);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @"测试";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
