//
//  LeftViewController.m
//  MyCircle
//
//  Created by and on 15/12/10.
//  Copyright © 2015年 and. All rights reserved.
//

#import "LeftViewController.h"
#import "RightViewController.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "LeftHeaderView.h"
#import "LeftFooterView.h"
#import "EditPersonViewController.h"
#import <UIImageView+WebCache.h>

//图片上传
#import "AFManagerHandle.h"
//md5加密
#import <CommonCrypto/CommonDigest.h>

#import <SDImageCache.h>

#import "SetVC.h"
#import <AFHTTPRequestOperationManager.h>
#import "WeatherVC.h"

@interface LeftViewController () <UITableViewDataSource, UITableViewDelegate>
{
    LeftHeaderView *_leftHeaderView;//
    LeftFooterView *_leftFooterView;
}
@property (strong, nonatomic) UITableView *leftTV;

@end

@implementation LeftViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (ISEMPTY(_leftFooterView.locationLabel.text)) {
        [_leftFooterView locationAction];
    }else {
        [_leftFooterView refreshWeather];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexColor(0x57C9F0);
    self.title = @"left";
    self.navigationController.navigationBarHidden = YES;
    [self initView];
    [self initData];
    [self registerNoti];
}

- (void)initView {
    
    _leftHeaderView = [[LeftHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - SCREEN_ORIGINWIDTH_5(150), SCREEN_ORIGINWIDTH_5(300))];
    [self.view addSubview:_leftHeaderView];
    
    [_leftHeaderView addTapCallBack:self sel:@selector(leftHeaderAction:)];
    
    _leftTV = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_ORIGINWIDTH_5(300), _leftHeaderView.width, self.view.height - _leftHeaderView.height - SCREEN_ORIGINWIDTH_5(150)) style:(UITableViewStyleGrouped)];
    _leftTV.delegate = self;
    _leftTV.dataSource = self;
    _leftTV.backgroundColor = HexColor(0x57C9F0);
    [self.view addSubview:_leftTV];
    [_leftTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _leftFooterView = [[LeftFooterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_leftTV.frame), _leftHeaderView.width, self.view.height - CGRectGetMaxY(_leftTV.frame))];
    [self.view addSubview:_leftFooterView];
    
    [_leftFooterView.setView addTapCallBack:self sel:@selector(setViewAction:)];
    [_leftFooterView.nightView addTapCallBack:self sel:@selector(nightViewAction:)];
    [_leftFooterView.weatherView addTapCallBack:self sel:@selector(weatherViewAction:)];
}

- (void)initData {
    _leftHeaderView.backgroundColor = HexColor(0xE7DDC7);
    _leftHeaderView.nickLabel.text = [XFAppContext sharedContext].nickname;
    _leftHeaderView.introLabel.text = [XFAppContext sharedContext].intro;
    [_leftHeaderView.portraitImv sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:[XFAppContext sharedContext].portrait]] placeholderImage:[UIImage imageNamed:@"man"] completed:nil];
}


#pragma mark -
#pragma mark -- 下方action
- (void)setViewAction:(UIGestureRecognizer *)sender {
    NSLog(@"setView--");
    SetVC *set = [[SetVC alloc] init];
    [self pushLeftWithVC:set];
}
- (void)nightViewAction:(UIGestureRecognizer *)sender {
    NSLog(@"nightView--");
}
- (void)weatherViewAction:(UIGestureRecognizer *)sender {
    NSLog(@"weatherView--");
    WeatherVC *weather = [[WeatherVC alloc] init];
    [self pushLeftWithVC:weather];
}

#pragma mark ---- 注册通知
- (void)registerNoti {
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(portraitChange:) name:@"REFRESHPORTRAIT" object:nil];
    
}

- (void)portraitChange:(NSNotification *)sender {
    if (!ISEMPTY([XFAppContext sharedContext].portrait)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_leftHeaderView.portraitImv sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:[XFAppContext sharedContext].portrait]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
            _leftHeaderView.nickLabel.text = [XFAppContext sharedContext].nickname;
        });
    }
}

/**
 *  推入下个页面
 */
- (void)leftHeaderAction:(UIGestureRecognizer *)sender {
    EditPersonViewController *editVC = [[EditPersonViewController alloc] init];
    [((AppDelegate *)[UIApplication sharedApplication].delegate) pushLeftWithVC:editVC];
}

#pragma mark -- tableView delegate dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"清空缓存:%luMB",[[SDImageCache sharedImageCache] getSize] / 1024 / 1024];
    }else {
        cell.textLabel.text = @"我的收藏";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        //清空缓存
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] cleanDiskWithCompletionBlock:^{
            NSLog(@"清空");
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.textLabel.text = [NSString stringWithFormat:@"清空缓存:%luMB",[[SDImageCache sharedImageCache] getSize] / 1024 / 1024];
  
            });
        }];
        [_leftTV reloadData];

        return;
    }
    RightViewController *rightVC = [[RightViewController alloc] init];
    [self pushLeftWithVC:rightVC];
}

- (void)pushLeftWithVC:(id)vc {
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate) pushLeftWithVC:vc];
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
