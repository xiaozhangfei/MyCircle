//
//  EditContentVC.m
//  MyCircle
//
//  Created by and on 16/1/5.
//  Copyright © 2016年 and. All rights reserved.
//

#import "EditContentVC.h"

@interface EditContentVC () <UITableViewDataSource, UITableViewDelegate>
{
    UITextField *_tf;
    UITableView *_tableView;
}
@end

@implementation EditContentVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        _tf.text = weakSelf.content;
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)leftBarButtonAction:(id )sender {
    self.contentBlock(_tf.text);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView {
    self.title = _conTitle;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:(UITableViewStyleGrouped)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = HexColor(0xFBF7ED);
    [self.view addSubview:_tableView];
}


#pragma mark -- tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor whiteColor];
    _tf = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, self.view.width - 2 * 10, 35)];
    _tf.borderStyle = UITextBorderStyleNone;
    _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tf.textColor = [UIColor darkGrayColor];
    [cell addSubview:_tf];
    
    return cell;
}

- (void)initData {
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
