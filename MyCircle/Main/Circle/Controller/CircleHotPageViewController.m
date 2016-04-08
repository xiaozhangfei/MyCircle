//
//  CircleHotPageViewController.m
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import "CircleHotPageViewController.h"

#import "CircleDetailViewController.h"

#import "CircleHotModel.h"

#import <MJRefresh/MJRefresh.h>

#import "CircleHotTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "AppDelegate.h"

#import "CircleDetailVC.h"

@interface CircleHotPageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *hotTableView;
@property (strong, nonatomic) NSMutableArray *hotDataArray;
@property (assign, nonatomic) NSInteger nowPage;

@property (assign, nonatomic) CGFloat scrollViewOffsetY;
@property (assign, nonatomic) BOOL scrollTop;//上拉

@end

@implementation CircleHotPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nowPage = 0;
    _hotDataArray = [NSMutableArray array];
    [self initView];
    [self initData];

}

- (void)initView {
    
    self.view.backgroundColor = HexColor(0xFBF7ED);
    
    _hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 120) style:(UITableViewStyleGrouped)];
    _hotTableView.delegate = self;
    _hotTableView.dataSource = self;
    _hotTableView.backgroundColor = HexColor(0xFBF7ED);
    _hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_hotTableView];
    //注册
    [_hotTableView registerClass:[CircleHotTableViewCell class] forCellReuseIdentifier:@"hotCell"];
    //添加刷新、加载
    __weak typeof(self)WeakSelf = self;
    
    self.hotTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        WeakSelf.nowPage ++;
        [WeakSelf getDataWithPage:WeakSelf.nowPage];
    }];

    self.hotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        WeakSelf.nowPage = 0;
        [WeakSelf getDataWithPage:0];
    }];

}

- (void)initData {
    [self.hotTableView.mj_header setState:(MJRefreshStateRefreshing)];
    [self getDataWithPage:_nowPage];
}
#pragma mark -- getData
- (void)getDataWithPage:(NSInteger )page {

    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager getWithURLString:[XFAPI getHotsWithPages:page sort:@"1"] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
        [weakSelf getDataSuccessWithResponse:responseDict baseModel:baseModel page:page];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        [weakSelf getDataFailWithError:error];
    } dataRequestProgress:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"bytesRead=%lu, totalBytesRead=%llu, totalBytesExpectedToRead=%llu", bytesRead, totalBytesRead, totalBytesExpectedToRead);
        NSLog(@"-----%f",totalBytesRead * 1.0 / totalBytesExpectedToRead);
    }];
    
}
#pragma mark -- data option
- (void)getDataSuccessWithResponse:(NSDictionary *)responseDict baseModel:(BaseModel *)baseModel page:(NSInteger )page{
    [self hideRefresh];

    if (![baseModel.code isEqual: @"200"]) {
        [self showToast:baseModel.s_description];
        return ;
    }
    [self hiddenInfoView];
    if (page == 0) {//如果刷新到第一页，没有拿到新数据，则不移除数据
        if (((NSArray *)responseDict).count == 0) {//没有拿到新数据
            if (self.hotDataArray.count == 0) {
                [self showInfoView:@"" withInfoText:LocalString(@"circle_empty") withText:@"哈哈" superView: self.hotTableView];
                [self showXFToastWithText:LocalString(@"toast_empty") image:[UIImage imageNamed:@"circle"]];
            }
        }else {
            [self.hotDataArray removeAllObjects];
            self.nowPage = 1;
            for (NSDictionary *di in (NSArray *)responseDict) {
                CircleHotModel *circle = [[CircleHotModel alloc] init];
                [circle setValuesForKeysWithDictionary:di];
                [self.hotDataArray addObject:circle];
            }
            [self.hotTableView reloadData];
        }
    }else {
        if (((NSArray *)responseDict).count == 0) {//
            [self showToast:LocalString(@"toast_noMoreData")];
            self.nowPage --;//由于没有加载到数据，把页数还原
        }else { //上拉加载，取到数据
            self.nowPage ++;
            NSMutableArray *index = [NSMutableArray array];
            NSInteger num = self.hotDataArray.count;
            for (NSDictionary *di in (NSArray *)responseDict) {
                CircleHotModel *circle = [[CircleHotModel alloc] init];
                [circle setValuesForKeysWithDictionary:di];
                [self.hotDataArray addObject:circle];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:num inSection:0];
                num ++;
                [index addObject:indexPath];
            }
            [self.hotTableView insertRowsAtIndexPaths:index withRowAnimation:(UITableViewRowAnimationFade)];
        }
    }
}

- (void)getDataFailWithError:(NSError *)error {
    [self hideRefresh];
    [self showToast:LocalString(@"toast_netError")];
}

- (void)hideRefresh {
    [self hideHUD];
    [self.hotTableView.mj_header endRefreshing];
    [self.hotTableView.mj_footer endRefreshing];
    // 隐藏当前的上拉刷新控件
    //self.hotTableView.mj_footer.hidden = YES;
}

#pragma mark -- tableView dataSource 、delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CircleHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotCell" forIndexPath:indexPath];
    CircleHotModel *model = self.hotDataArray[indexPath.row];
    [cell setHotModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //[self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%ld", indexPath.row+1]];
    CircleHotModel *model = _hotDataArray[indexPath.row];
    CircleDetailViewController *detailVC = [[CircleDetailViewController alloc] init];
//    CircleDetailVC *detailVC = [[CircleDetailVC alloc] init];

    detailVC.srcTitle = model.title;
    detailVC.cid = model.cid;
    //[self.navigationController pushViewController:detailVC animated:YES];
    [self pushVC:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_CURRETWIDTH(500);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hotDataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SCREEN_CURRETWIDTH(10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_CURRETWIDTH(10);
}

#pragma mark -- 上拉下滑 的 事件响应
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"%f --开始",scrollView.contentOffset.y);
//    self.scrollViewOffsetY = scrollView.contentOffset.y;
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%f --", scrollView.contentOffset.y);
//    if (scrollView.contentOffset.y > self.scrollViewOffsetY) {//上滑
//        [self toBottomAction];
//    }else { //下拉
//        [self toTopAction];
//    }
//    
//}
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSLog(@"%f --结束", scrollView.contentOffset.y);
//    self.scrollViewOffsetY = scrollView.contentOffset.y;
//}
//
//- (void)toBottomAction {//上滑动作，隐藏navigationBar
//    __weak typeof (self) weakSelf = self;
//    [UIView animateWithDuration:5.0 animations:^{
//        weakSelf.navigationController.navigationBar.alpha = 0;
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//- (void)toTopAction { //下拉动作，显示navigation
//    __weak typeof (self) weakSelf = self;
//    [UIView animateWithDuration:5.0 animations:^{
//        weakSelf.navigationController.navigationBar.alpha = 1;
//    } completion:^(BOOL finished) {
//        
//    }];
//}

@end
