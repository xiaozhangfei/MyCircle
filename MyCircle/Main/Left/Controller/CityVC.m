//
//  CityVC.m
//  MyCircle
//
//  Created by and on 15/12/31.
//  Copyright © 2015年 and. All rights reserved.
//

#import "CityVC.h"
#import "AppMacro.h"

@interface CityVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *cityTV;

@property (strong, nonatomic) NSMutableArray *cityDataSource;
@end

@implementation CityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cityDataSource = [NSMutableArray array];
    [self initView];
    [self initData];
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backItemImage"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];
    
    _cityTV = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    _cityTV.delegate = self;
    _cityTV.dataSource = self;
    [self.view addSubview:_cityTV];
    [_cityTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)initData {
    
}


#pragma mark -- tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_CURRETWIDTH(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SCREEN_CURRETWIDTH(10);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
