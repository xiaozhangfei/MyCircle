//
//  FindOneViewController.m
//  MyCircle
//
//  Created by and on 15/12/6.
//  Copyright © 2015年 and. All rights reserved.
//

#import "FindOneViewController.h"
#import "MyControl.h"
#import "BtnExt.h"

#import "FindSVC.h"
#import <MJExtension.h>
#import "FindOneModel.h"


#import "RxWebViewController.h"

@interface FindOneViewController ()
{
    UIView *_backView;
}
@end

@implementation FindOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 113)];
    _backView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_backView];
    
    BtnExt *btn = [[BtnExt alloc] initWithFrame:CGRectMake(100, 100, 120, 120)];
    btn.btnType = XFBtnTypeBottom;
    [btn setImage:[UIImage imageNamed:@"Shake_Received_Icon"] forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [btn setTitle:@"哈哈" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    btn.backgroundColor  =[UIColor whiteColor];
    [self.view addSubview:btn];
//    UIButton *btn = [MyControl createButton:CGRectMake(100, 100, 90, 90) ImageName:@"Shake_Received_Icon" Target:self Action:@selector(btnAction:) Title:@"标题"];
//    btn.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:btn];
    [self getData];
}

#pragma mark -- getData
- (void)getData {
    
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager getWithURLString:@"http://www.u22t.com/home/index/mj" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
        [weakSelf getDataSuccessWithResponse:responseDict baseModel:baseModel];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        [weakSelf getDataFailWithError:error];
    } dataRequestProgress:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"bytesRead=%lu, totalBytesRead=%llu, totalBytesExpectedToRead=%llu", bytesRead, totalBytesRead, totalBytesExpectedToRead);
        NSLog(@"-----%f",totalBytesRead * 1.0 / totalBytesExpectedToRead);
    }];
    
}
- (void)getDataFailWithError:(NSError *)error {
    NSLog(@"error = %@",error);
}

- (void)getDataSuccessWithResponse:(NSDictionary *)response baseModel:(BaseModel *)model {
    for (NSDictionary *dict in response) {
        FindOneModel *one = [FindOneModel mj_objectWithKeyValues:dict];
        NSLog(@"l = %@,id = %@",one.location.l,one.f_id);
        
    }
}


- (void)btnAction:(UIButton *)btn {
    NSLog(@"..点击");
    
//    FindSVC *svc = [[FindSVC alloc] init];
//    svc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:svc animated:YES];
//    
    RxWebViewController *webVC = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://www.baidu.com"]];
    [self pushVC:webVC animated:YES];
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
