//
//  CircleDetailViewController.m
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "RxWebViewController.h"

#import "CircleDetailModel.h"
#import <LocalAuthentication/LocalAuthentication.h>

#import "CircleDetailView.h"

#import <AVFoundation/AVFoundation.h>

#import "ChatVC.h"
@interface CircleDetailViewController ()
{
    CircleDetailModel *_detailModel;
    
    AVPlayerItem *playerItems;
    UIView *_playView;//视频播放器的view
    UIView *_container; //播放器容器
    UIButton *_playOrPause; //播放/暂停按钮
    UIImageView *_zoneImageButton;//视频全屏按钮
    UIView *_controlPlayView;
    AVPlayerLayer *_playerLayer;
    UIImageView *_closePlayView;
    NSURL *_videoURL;
    CGRect _currentFrame;
    BOOL _isRevolve;//是否旋转
    BOOL _isPlaying;
    AVPlayer *_avPlayer;//播放器对象
    
}
@property (strong, nonatomic) CircleDetailView *detailView;

@property (strong, nonatomic) UIProgressView *progress;//播放进度
@property (nonatomic, strong) UILabel *cuTimeLabel;

@end

@implementation CircleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _srcTitle;
    [self initView];
    _detailModel = [[CircleDetailModel alloc] init];
    [self initData];
}

- (void)leftBarButtonAction:(id )sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView {
    //设置对应的导航条的返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];
    
    CGRect rect = self.view.frame;
    rect.origin.y = 64;
    rect.size.height -= 64;
    _detailView = [[CircleDetailView alloc] initWithFrame:rect];
    [self.view addSubview:_detailView];
    
    [_detailView.playIcon addTapCallBack:self sel:@selector(playAction:)];
    [_detailView.photoImg addTapCallBack:self sel:@selector(photoImgAction:)];
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

- (void)photoImgAction:(UIGestureRecognizer *)sender {
    NSLog(@"跳入聊天界面");
    if (ISEMPTY([XFAppContext sharedContext].uid)) {
        [self showToast:@"您尚未登录"];
        return;
    }
    
    ChatVC *chat = [[ChatVC alloc] initWithConversationType:(ConversationType_PRIVATE) targetId:_detailModel.uid];
//    //新建一个聊天会话View Controller对象
//    RCConversationViewController *chat = [[RCConversationViewController alloc]init];
//    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
//    chat.conversationType = ConversationType_PRIVATE;
//    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
//    chat.targetId = _detailModel.uid;
//    //设置聊天会话界面要显示的标题
//    chat.title = _detailModel.nickname;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)dealloc
{
    if (_avPlayer) {
        [self removeObserverFromPlayerItem:playerItems];
        [self removeNotification];
        _avPlayer = nil;
    }
}

- (void)circleDetailInfoHandle:(NSDictionary *)response {
    NSLog(@"--re = %@",response);
    [_detailModel setValuesForKeysWithDictionary:response];
    NSLog(@"%@..",_detailModel.cid);
    [_detailView setDetailModel:_detailModel];
}

#pragma mark -- arction
- (void)playAction:(UIGestureRecognizer *)sender {
    //[self showXFToastWithText:@"播放视频" image:[UIImage imageNamed:@"Action_Moments"]];
    //播放网络视频
//    [self playVideoWithURL:[NSURL URLWithString:[XFAPI video_url:_detailModel.vpath]]];
    [self playVideoWithURL:[NSURL URLWithString:@"http://7xo6u7.com1.z0.glb.clouddn.com/Taylor%20Swift%20-%20You%20Belong%20With%20Me.mp4"]];

}

- (void)btnAction:(UIButton *)sender {

    RxWebViewController *webVC = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:@"http://www.baidu.com"]];
    webVC.hidesBottomBarWhenPushed = YES;
    [self pushVC:webVC animated:YES];

}


#pragma mark ===================视频播放
- (void)playVideoWithURL:(NSURL *)url{
    _videoURL = url;
    if (!_avPlayer) {
        playerItems = [AVPlayerItem playerItemWithURL:_videoURL];
        _avPlayer = [AVPlayer playerWithPlayerItem:playerItems];
        [self addObserverToPlayerItem:playerItems];
        [self addProgressObserver];
        [self addNotification];
    }
    [self setupUIWithFrame:CGRectMake(SCREEN_WIDTH_XF(0), 64, SCREEN_WIDTH - SCREEN_WIDTH_XF(0), SCREEN_WIDTH_XF(225))];
    [_avPlayer play];
    _isPlaying = YES;
}


#pragma mark -
#pragma mark -- avPlayer

-(void)setupUIWithFrame:(CGRect )frame{
    
    //创建播放器层
    _playView = [[UIView alloc] initWithFrame:frame];
    _playView.backgroundColor = [UIColor blackColor];
    _currentFrame = frame;
    _isRevolve = NO;
    [self.view addSubview:_playView];
    
    _container  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _container.backgroundColor = [UIColor blackColor];
    _container.userInteractionEnabled = YES;
    [_container addTapCallBack:self sel:@selector(removeControlView:)];
    [_playView addSubview:_container];
    
    _controlPlayView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - SCREEN_WIDTH_XF(30), frame.size.width, SCREEN_WIDTH_XF(30))];
    _controlPlayView.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    [_playView addSubview:_controlPlayView];
    
    _playOrPause = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _playOrPause.frame = CGRectMake(SCREEN_WIDTH_XF(20), SCREEN_WIDTH_XF(4), SCREEN_WIDTH_XF(22), SCREEN_WIDTH_XF(22));
    _playOrPause.tintColor = [UIColor whiteColor];
    [_playOrPause setImage:[UIImage imageNamed:@"player_pause"] forState:(UIControlStateNormal)];
    [_playOrPause addTarget:self action:@selector(playClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [_controlPlayView addSubview:_playOrPause];
    
    _progress = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    _progress.frame = CGRectMake(SCREEN_WIDTH_XF(45), SCREEN_WIDTH_XF(14), frame.size.width - SCREEN_WIDTH_XF(188), SCREEN_WIDTH_XF(2));
    _progress.tintColor = [UIColor colorWithRed:248.0/255.0 green:195.0/255.0 blue:72.0/255.0 alpha:100];
    [_controlPlayView addSubview:_progress];
    
    _cuTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - SCREEN_WIDTH_XF(138), 0, SCREEN_WIDTH_XF(70), SCREEN_WIDTH_XF(30))];
    _cuTimeLabel.text = @"00:00/00:00";
    _cuTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    _cuTimeLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [_controlPlayView addSubview:_cuTimeLabel];
    
    _zoneImageButton = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - SCREEN_WIDTH_XF(64), SCREEN_WIDTH_XF(4), SCREEN_WIDTH_XF(22), SCREEN_WIDTH_XF(22))];
    [_zoneImageButton setImage:[UIImage imageNamed:@"fullscreen"]];
    _zoneImageButton.userInteractionEnabled = YES;
    [_zoneImageButton addTapCallBack:self sel:@selector(zoneImageButtonAction:)];
    [_controlPlayView addSubview:_zoneImageButton];
    
    _closePlayView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - SCREEN_WIDTH_XF(37), SCREEN_WIDTH_XF(4), SCREEN_WIDTH_XF(22), SCREEN_WIDTH_XF(22))];
    _closePlayView.image = [UIImage imageNamed:@"record_close_normal"];
    _closePlayView.userInteractionEnabled = YES;
    [_closePlayView addTapCallBack:self sel:@selector(closePlayViewAction:)];
    [_controlPlayView addSubview:_closePlayView];
    
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    _playerLayer.frame = CGRectMake(0, 0, _container.width, _container.height);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
    [_container.layer addSublayer:_playerLayer];
}

- (void)closePlayViewAction:(UIGestureRecognizer *)sender
{
    
    if (_avPlayer) {
        [_avPlayer pause];
        [self removeObserverFromPlayerItem:playerItems];
        _avPlayer = nil;
    }
    [_playView removeFromSuperview];
    
}

- (void)removeControlView:(UIGestureRecognizer *)sender
{
    _controlPlayView.hidden = !_controlPlayView.hidden;
}
//画面旋转
- (void)zoneImageButtonAction:(UIGestureRecognizer *)sender
{
    
    if (_isRevolve) {//已经旋转
        _playView.transform = CGAffineTransformMakeRotation(0 * M_PI / 180);//旋转回到正常状态
        _isRevolve = NO;
        CGRect frame = _currentFrame;
        _playView.frame = frame;
        _container.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _controlPlayView.frame = CGRectMake(0, frame.size.height - SCREEN_WIDTH_XF(30), frame.size.width, SCREEN_WIDTH_XF(30));
        _playOrPause.frame = CGRectMake(SCREEN_WIDTH_XF(20), SCREEN_WIDTH_XF(4), SCREEN_WIDTH_XF(22), SCREEN_WIDTH_XF(22));
        _progress.frame = CGRectMake(SCREEN_WIDTH_XF(45), SCREEN_WIDTH_XF(14), frame.size.width - SCREEN_WIDTH_XF(188), SCREEN_WIDTH_XF(2));
        
        _cuTimeLabel.frame = CGRectMake(frame.size.width - SCREEN_WIDTH_XF(138), 0, SCREEN_WIDTH_XF(70), SCREEN_WIDTH_XF(30));
        _zoneImageButton.frame = CGRectMake(frame.size.width - SCREEN_WIDTH_XF(64), SCREEN_WIDTH_XF(4), SCREEN_WIDTH_XF(22), SCREEN_WIDTH_XF(22));
        _zoneImageButton.image = [UIImage imageNamed:@"fullscreen"];
        _closePlayView.frame = CGRectMake(frame.size.width - SCREEN_WIDTH_XF(37), SCREEN_WIDTH_XF(4), SCREEN_WIDTH_XF(22), SCREEN_WIDTH_XF(22));
        _playerLayer.frame = _playerLayer.frame = CGRectMake(0, 0, _container.width, _container.height);
        [_playView viewWithTag:1200].center = CGPointMake(_playView.frame.size.width / 2, _playView.frame.size.height / 2);
        [self.view addSubview:_playView];
        
        NSLog(@"旋转到正常");
    }else {
        //全屏改变全部子frame
        _playView.transform=CGAffineTransformMakeRotation(90 * M_PI / 180);
        _isRevolve = YES;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _playView.frame = [UIScreen mainScreen].bounds;
        CGRect frame = _playView.frame;
        //改变子View frame
        _container.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
        [_container removeAllSubviews];
        _controlPlayView.frame = CGRectMake(0, SCREEN_WIDTH - SCREEN_WIDTH_XF(30), SCREEN_HEIGHT, SCREEN_WIDTH_XF(30));
        _playOrPause.frame = CGRectMake(SCREEN_WIDTH_XF(20), SCREEN_WIDTH_XF(4), SCREEN_WIDTH_XF(22), SCREEN_WIDTH_XF(22));
        _progress.frame = CGRectMake(SCREEN_WIDTH_XF(45), SCREEN_WIDTH_XF(14), frame.size.height - SCREEN_WIDTH_XF(188), SCREEN_WIDTH_XF(2));
        
        _cuTimeLabel.frame = CGRectMake(frame.size.height - SCREEN_WIDTH_XF(138), 0, SCREEN_WIDTH_XF(70), SCREEN_WIDTH_XF(30));
        _zoneImageButton.frame = CGRectMake(frame.size.height - SCREEN_WIDTH_XF(64), SCREEN_WIDTH_XF(4), SCREEN_WIDTH_XF(22), SCREEN_WIDTH_XF(22));
        _zoneImageButton.image = [UIImage imageNamed:@"videoMini"];
        _closePlayView.frame = CGRectMake(frame.size.height - SCREEN_WIDTH_XF(37), SCREEN_WIDTH_XF(4), SCREEN_WIDTH_XF(22), SCREEN_WIDTH_XF(22));
        _playerLayer.frame = _container.frame;
        [_playView viewWithTag:1200].center = CGPointMake(_playView.frame.size.height / 2, _playView.frame.size.width
                                                          / 2);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
        
        [window addSubview:_playView];
        NSLog(@"旋转到全屏");
    }
}

/**
 *  截取指定时间的视频缩略图
 *
 *  @param timeBySecond 时间点
 */

/**
 *  根据视频索引取得AVPlayerItem对象
 *
 *  @param videoIndex 视频顺序索引
 *
 *  @return AVPlayerItem对象
 */
#pragma mark - 通知
/**
 *  添加播放器通知
 */
-(void)addNotification{
    
    [self removeNotification];
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayer.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    
    NSLog(@"视频播放完成.");
    //播放按钮和进度条设置为初始状态
    [_playOrPause setImage:[UIImage imageNamed:@"player_play"] forState:(UIControlStateNormal)];
    _progress.progress = 0;
    //将播放器置为初始值
    [_avPlayer seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        _isPlaying = NO;
        [_avPlayer pause];
        //添加中央大的播放图标
        //切换视频
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_XF(75), SCREEN_WIDTH_XF(75))];
        imv.image = [UIImage imageNamed:@"player_play"];
        imv.userInteractionEnabled = YES;
        imv.tag = 1200;
        if (_isRevolve) {//全屏状态
            imv.center = CGPointMake(_playView.frame.size.height / 2, _playView.frame.size.width / 2);
        }else {
            imv.center = CGPointMake(_playView.frame.size.width / 2, _playView.frame.size.height / 2);
        }
        [imv addTapCallBack:self sel:@selector(finishPlayAction:)];
        [_playView addSubview:imv];
    }];
    
}

#pragma mark - 监控
/**
 *  给播放器添加进度更新
 */
-(void)addProgressObserver{
    
    AVPlayerItem *playerItem = _avPlayer.currentItem;
    //这里设置每秒执行一次
    __weak typeof (self) weakSelf = self;
    [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds([playerItem duration]);
        if (current > total) {
            return ;
        }
        NSString *cuTime = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d",(int)current / 60,(int)current % 60, (int) total / 60 , (int )total % 60];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.cuTimeLabel.text = cuTime;
        });
        NSLog(@"当前已经播放%.2fs.",current);
        if (current) {
            [weakSelf.progress setProgress:(current/total) animated:YES];
            NSLog(@".. %f",current/total);
        }
    }];
}

/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    
    [_avPlayer pause];
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
}
/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status == AVPlayerStatusReadyToPlay){
            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"共缓冲：%.2f",totalBuffer);
        //
    }
}

#pragma mark - UI事件
/**
 *  点击播放/暂停按钮
 *
 *  @param sender 播放/暂停按钮
 */
- (void)playClick:(UIButton *)sender {
    
    if(!_isPlaying){ //说明时暂停
        [sender setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
        [_avPlayer play];
        _isPlaying = YES;
        [[_playView viewWithTag:1200] removeFromSuperview];
        
        NSLog(@"暂停");
    }else {//正在播放
        [_avPlayer pause];
        _isPlaying = NO;
        [sender setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        NSLog(@"播放");
    }
//    if(_avPlayer.rate == 0){ //说明时暂停
//        [sender setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
//        [_avPlayer play];
//    }else if(_avPlayer.rate == 1){//正在播放
//        [_avPlayer pause];
//        [sender setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
//    }
    
    
}
- (void)finishPlayAction:(UIGestureRecognizer *)sender
{
    [_playOrPause  setImage:[UIImage imageNamed:@"player_pause"] forState:UIControlStateNormal];
    [_avPlayer play];
    _isPlaying = YES;
    [_progress setProgress:0.0 animated:YES];
    [sender.view removeFromSuperview];
}

#pragma mark -


@end
