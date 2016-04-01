//
//  CircleDetailVC.m
//  MyCircle
//
//  Created by and on 16/2/23.
//  Copyright © 2016年 and. All rights reserved.
//

#import "CircleDetailVC.h"
#import "CircleDetailModel.h"

@interface CircleDetailVC ()
{
    CircleDetailModel *_detailModel;

    WMPlayer *wmPlayer;
    CGRect playerFrame;
}

@end

@implementation CircleDetailVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullScreenBtnClick:) name:@"fullScreenBtnClickNotice" object:nil];
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    wmPlayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    wmPlayer.playerLayer.frame =  CGRectMake(0,0, self.view.frame.size.height,self.view.frame.size.width);
    
    [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.view.frame.size.width-40);
        make.width.mas_equalTo(self.view.frame.size.height);
    }];
    
    [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(wmPlayer).with.offset((-self.view.frame.size.height/2));
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.top.equalTo(wmPlayer).with.offset(5);
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    wmPlayer.isFullscreen = YES;
    wmPlayer.fullScreenBtn.selected = YES;
    [wmPlayer bringSubviewToFront:wmPlayer.bottomView];
    
}
-(void)toNormal{
    [wmPlayer removeFromSuperview];
    [UIView animateWithDuration:0.5f animations:^{
        wmPlayer.transform = CGAffineTransformIdentity;
        wmPlayer.frame =CGRectMake(playerFrame.origin.x, playerFrame.origin.y, playerFrame.size.width, playerFrame.size.height);
        wmPlayer.playerLayer.frame =  wmPlayer.bounds;
        [self.view addSubview:wmPlayer];
        [wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(0);
            make.right.equalTo(wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(wmPlayer).with.offset(0);
        }];
        [wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(wmPlayer).with.offset(5);
        }];
        
    }completion:^(BOOL finished) {
        wmPlayer.isFullscreen = NO;
        wmPlayer.fullScreenBtn.selected = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
        
    }];
}
-(void)fullScreenBtnClick:(NSNotification *)notice{
    UIButton *fullScreenBtn = (UIButton *)[notice object];
    if (fullScreenBtn.isSelected) {//全屏显示
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        [self toNormal];
    }
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (wmPlayer==nil||wmPlayer.superview==nil){
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (wmPlayer.isFullscreen) {
                [self toNormal];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            if (wmPlayer.isFullscreen == NO) {
                [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
            }
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _detailModel = [[CircleDetailModel alloc] init];
    [self initData];
}

- (void)initData {
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager getWithURLString:[XFAPI getCircleDetailWithCid:_cid] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
        
        if (![baseModel.code isEqual:@"200"]) {
            [weakSelf showXFToastWithText:baseModel.s_description image:[UIImage imageNamed:@"operationbox_fail_web"]];
            return ;
        }
        [weakSelf circleDetailInfoHandle:responseDict];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        [weakSelf showXFToastWithText:@"网络错误" image:[UIImage imageNamed:@"operationbox_fail_web"]];
    } dataRequestProgress:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"bytesRead=%ld, totalBytesRead=%lld, totalBytesExpectedToRead=%lld", bytesRead, totalBytesRead, totalBytesExpectedToRead);
        NSLog(@"-----%f",totalBytesRead * 1.0 / totalBytesExpectedToRead);
    }];
}

- (void)circleDetailInfoHandle:(NSDictionary *)response {
    NSLog(@"--re = %@",response);
    [_detailModel setValuesForKeysWithDictionary:response];
    NSLog(@"%@..",_detailModel.cid);
    //[_detailView setDetailModel:_detailModel];
    
    playerFrame = CGRectMake(0, 64, self.view.frame.size.width, (self.view.frame.size.width)*3/4);
//    wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:@"http://flv2.bn.netease.com/videolib3/1602/23/RCZxL1911/SD/movie_index.m3u8"];
    wmPlayer = [[WMPlayer alloc]initWithFrame:playerFrame videoURLStr:@"http://7xo6u7.com1.z0.glb.clouddn.com/Taylor%20Swift%20-%20You%20Belong%20With%20Me.mp4"];
    wmPlayer.closeBtn.hidden = YES;
    [self.view addSubview:wmPlayer];
    [wmPlayer.player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)releaseWMPlayer{
    [wmPlayer.player.currentItem cancelPendingSeeks];
    [wmPlayer.player.currentItem.asset cancelLoading];
    
    [wmPlayer.player pause];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer = nil;
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
}

-(void)dealloc{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"player deallco");
}


@end