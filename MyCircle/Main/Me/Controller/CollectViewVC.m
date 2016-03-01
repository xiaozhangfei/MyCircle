//
//  CollectViewVC.m
//  MyCircle
//
//  Created by and on 15/12/14.
//  Copyright © 2015年 and. All rights reserved.
//

#import "CollectViewVC.h"

@interface CollectViewVC () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *collectTV;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation CollectViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    
}

- (void)initView {
    //设置对应的导航条的返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];
    
    _collectTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height)];
    [self.view addSubview:_collectTV];
    _collectTV.delegate = self;
    _collectTV.dataSource = self;
    
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
    cell.textLabel.text = @"text";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
