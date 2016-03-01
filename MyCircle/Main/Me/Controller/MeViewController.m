//
//  MeViewController.m
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import "MeViewController.h"

#import "VideoDownloaderVC.h"

#import "EditPersonViewController.h"
#import "CollectViewVC.h"

#import "PlayerVC.h"
#import <UIImageView+WebCache.h>

#import "XFPicVideoPicker.h"
#import "UpFileManager.h"

#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>

@interface MeViewController() <UITableViewDataSource, UITableViewDelegate, XFPicVideoPickerProtocol, UIAlertViewDelegate>
{
    UIView *_refreshView;
    UIImageView *_refreshImg;
    BOOL _isRefreshing;//标记是否正在刷新
    CGFloat _nowContentOffsetY;//当前偏移量
    UIImageView *_headImg;//head图片
    
    
    NSString *_backgroundKey;
    NSString *_backgroundToken;
}
@property (strong, nonatomic) UITableView *setTV;
@property (strong, nonatomic) NSMutableArray *setDataArray;
@property (strong, nonatomic) XFPicVideoPicker *picker;
@end

@implementation MeViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"tab_me", @"tab_");
    
    _setDataArray = [NSMutableArray array];
    NSArray *arr = @[@"单个图片下载",@"我收藏的视频",@"我喜欢的"];
    [_setDataArray addObjectsFromArray:arr];
    [_setDataArray addObject:@"退出登录"];
    
    [self initView];
    [self initData];
    
}

- (void)initView {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pc_edit_big"] style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItemAction:)];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    CGRect rect = self.view.frame;
    rect.origin.y -= 0;
    rect.size.height += 0;
    _setTV = [[UITableView alloc] initWithFrame:rect style:(UITableViewStyleGrouped)];
    _setTV.delegate = self;
    _setTV.dataSource = self;
    _setTV.tableHeaderView = [self headerView];
    [self.view addSubview:_setTV];
    
    [_setTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setCell"];
    
//    //刷新view
//    _refreshView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 44, 44)];
//    [self.view addSubview:_refreshView];
//    _refreshImg = [[UIImageView alloc] initWithFrame:CGRectMake(-10, -10, 64, 64)];
//    _refreshImg.image = [UIImage imageNamed:@"Action_Moments@3x"];
//    [_refreshView addSubview:_refreshImg];
//    _isRefreshing = NO;
//    _nowContentOffsetY = -64;
    
    //重写navigationBar按钮方法时，开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
}

- (void)initData {
    [self getUpBackgroundKey];
}

#pragma mark -- 获取上传背景图片的key
- (void)getUpBackgroundKey {
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager getWithURLString:[XFAPI getUpTokenForPhotoWithType:@"background"] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
        if (![baseModel.code isEqual:@"200"]) {
            [weakSelf showToast:baseModel.s_description];
            return ;
        }
        _backgroundKey = responseDict[@"key"];
        _backgroundToken = responseDict[@"token"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        [weakSelf showToast:@"网络错误"];
    }];
}

#pragma mark -- 右button action，进入修改个人资料页面
- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender {
    EditPersonViewController *editVC = [[EditPersonViewController alloc] init];
    editVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editVC animated:YES];
}

- (UIView *)headerView {
    _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_CURRETWIDTH(464))];
    _headImg.image = [UIImage imageNamed:@"hed.jpg"];
    if (!ISEMPTY([XFAppContext sharedContext].backgroundUrl)) {
        [_headImg sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:[XFAppContext sharedContext].backgroundUrl]] placeholderImage:[UIImage imageNamed:@"hed.jpg"] completed:nil];
    }
    [_headImg addTapCallBack:self sel:@selector(headImgAction:)];
    return _headImg;
}

- (void)headImgAction:(UIGestureRecognizer *)sender {
    if (ISEMPTY(_backgroundKey)) {
        [self showToast:@"未获取图片上传的key"];
        return;
    }
    _picker = [[XFPicVideoPicker alloc] initWithController:self];
    _picker.type = XFPicVideoPickerTypePic;
    _picker.isAllowsEditing = YES;
    [_picker showPicActionSheet:self descMsg:@"背景图片选择"];
}

- (void)selectImage:(UIImage *)image {
    _headImg.image = image;
    
    [[UpFileManager shareHandle] sendSingleImageWithImage:image type:(UpFileManagerTypeBackground) key:_backgroundKey token:_backgroundToken];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"setCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:@"pc_friend"];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"单个图片下载";
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我收藏的视频";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"我喜欢的";
        }else if (indexPath.row == 2) {
            cell.textLabel.text = @"打赏好评";
        }
    }else {
        cell.textLabel.text = @"退出登录";
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 23;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 3;
    }else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        VideoDownloaderVC *videoDownader = [[VideoDownloaderVC alloc] init];
        videoDownader.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:videoDownader animated:YES];
        //重写navigationBar按钮方法时，开启iOS7的滑动返回效果
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        CollectViewVC *collect = [[CollectViewVC alloc] init];
        collect.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collect animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        PlayerVC *player = [[PlayerVC alloc] init];
        player.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:player animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你打算评价我们的应用吗？" delegate:self cancelButtonTitle:@"现在不" otherButtonTitles:@"YES-AppStore中",@"YES-iTunes中", nil];
        [alert show];
    }
    else if (indexPath.section == 2) {
        //退出登录
        XFAppContext *context = [XFAppContext sharedContext];
        context.uid = @"";
        [context save];
        [context clear];
        [self showToast:@"退出成功"];
        
        //断开与融云服务器连接，且不再接收推送
        [[RCIM sharedRCIM] logout];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        //[((AppDelegate *)[UIApplication sharedApplication].delegate).drawerController removeFromParentViewController];
        [((AppDelegate *)[UIApplication sharedApplication].delegate) setWindowRootVC];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/guang-dian-bi-zhi/id511587202?mt=8"]];
    } else if (buttonIndex == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/cn/app/guang-dian-bi-zhi/id511587202?mt=8"]];
    }
}

#pragma mark -- scroll
////监测速度
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y > 0){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
















@end
