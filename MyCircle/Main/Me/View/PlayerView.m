//
//  PlayerView.m
//  MyCircle
//
//  Created by and on 15/12/15.
//  Copyright © 2015年 and. All rights reserved.
//

#import "PlayerView.h"
#import <Masonry.h>

@implementation PlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    _playView = [[UIView alloc] initWithFrame:CGRectZero];
    _playView.backgroundColor = [UIColor blackColor];
    [self addSubview:_playView];
    
    _container = [[UIView alloc] initWithFrame:CGRectZero];
    _container.backgroundColor = [UIColor blackColor];
    _container.userInteractionEnabled = YES;
    //[_container addTapCallBack:self sel:@selector(removeControlView:)];
    [_playView addSubview:_container];
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.text = @"左上";
    _label.textColor = [UIColor whiteColor];
    [_playView addSubview:_label];
    
    _controlPlayView = [[UIView alloc] initWithFrame:CGRectZero];
    _controlPlayView.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    [_playView addSubview:_controlPlayView];
    
    _playOrPause = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _playOrPause.frame = CGRectZero;
    _playOrPause.backgroundColor = [UIColor whiteColor];
    [_playOrPause setTintColor:[UIColor whiteColor]];
    [_playOrPause setImage:[UIImage imageNamed:@"player_pause"] forState:(UIControlStateNormal)];
    //[_playOrPause addTarget:self action:@selector(playClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [_controlPlayView addSubview:_playOrPause];
    
    _progress = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    _progress.frame = CGRectZero;
    _progress.backgroundColor = [UIColor orangeColor];
    _progress.progress = 0.4;
    _progress.tintColor = [UIColor redColor];
    [_controlPlayView addSubview:_progress];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectZero];
    _slider.tintColor = [UIColor colorWithRed:248.0/255.0 green:195.0/255.0 blue:72.0/255.0 alpha:100];
    //[_controlPlayView addSubview:_slider];
    //_slider.maximumValue = 1.0;
    _slider.minimumValue = 0.0;
    //_slider setThumbImage:[UIImage imageNamed:@""] forState:<#(UIControlState)#>
    //[_slider addTarget:self action:@selector(sliderAction:) forControlEvents:(UIControlEventValueChanged)];
    
    _cuTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _cuTimeLabel.text = @"00:00";
    _cuTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    _cuTimeLabel.textColor = [UIColor whiteColor];
    _cuTimeLabel.backgroundColor = [UIColor orangeColor];
    [_controlPlayView addSubview:_cuTimeLabel];
    
    _allTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _allTimeLabel.text = @"00:00:00";
    _allTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    _allTimeLabel.backgroundColor = [UIColor brownColor];
    _allTimeLabel.textColor = [UIColor whiteColor];
    [_controlPlayView addSubview:_allTimeLabel];
    
    _zoneImageButton = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_zoneImageButton setImage:[UIImage imageNamed:@"fullscreen"]];
    _zoneImageButton.userInteractionEnabled = YES;
    _zoneImageButton.backgroundColor = [UIColor whiteColor];
    //[_zoneImageButton addTapCallBack:self sel:@selector(zoneImageButtonAction:)];
    [_controlPlayView addSubview:_zoneImageButton];
    

    
    //[self initFrame];
}

- (void)initFrame {
    _playView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _container.frame = _playView.frame;
    _label.frame = CGRectMake(0, 0, 70, 40);
    _controlPlayView.frame = CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50);
    _playOrPause.frame = CGRectMake(10, 0, 50, _controlPlayView.frame.size.height);
    _cuTimeLabel.frame = CGRectMake(CGRectGetMaxX(_playOrPause.frame), 0, 80, _controlPlayView.frame.size.height);
    
    _zoneImageButton.frame = CGRectMake(_controlPlayView.frame.size.width - 60, 0, 50, _controlPlayView.frame.size.height);
    _allTimeLabel.frame = CGRectMake(CGRectGetMinX(_zoneImageButton.frame) - 80, 0, 80, _controlPlayView.frame.size.height);
    _progress.frame = CGRectMake(CGRectGetMaxX(_cuTimeLabel.frame), 20, CGRectGetMinX(_allTimeLabel.frame) - CGRectGetMaxX(_cuTimeLabel.frame), 5);
//    _playerItems = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_videoURL]];
//    _avPlayer = [AVPlayer playerWithPlayerItem:_playerItems];
//    _playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
//    _playerLayer.frame=CGRectMake(0, 0, _container.width, _container.height);
//    _playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
//    [self.container.layer addSublayer:_playerLayer];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self initFrame];
}

- (void)startPlayerWithVideoUrl:(NSString *)videoUrl {
    if (_avPlayer) {
        [self removeObserverFromPlayerItem:_playerItems];
    }
    _playerItems = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_videoURL]];
    _avPlayer = [AVPlayer playerWithPlayerItem:_playerItems];
    [self addObserverToPlayerItem:_playerItems];
    _playerLayer.frame = CGRectZero;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
    [self.container.layer addSublayer:_playerLayer];
}

- (void)startPlay {
    if (_avPlayer) {
        [_avPlayer play];
    }
}

- (void)pausePlay {
    if (_avPlayer) {
        [_avPlayer pause];
    }
}

- (void)stopPlay {
    [self removeObserverFromPlayerItem:_playerItems];
}

#pragma mark - 监控
/**
 *  给播放器添加进度更新
 */
-(void)addProgressObserver{
    
    AVPlayerItem *playerItem=self.avPlayer.currentItem;
    //UIProgressView *progress=self.progress;
    //这里设置每秒执行一次
    __weak typeof (self) weakSelf = self;
    [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([playerItem duration]);
        if (current > total) {
            return ;
        }
        NSString *cuTime = [NSString stringWithFormat:@"%02d:%02d/%02d:%02d",(int)current / 60,(int)current % 60, (int) total / 60 , (int )total % 60];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.cuTimeLabel.text = cuTime;
            [weakSelf.slider setValue:current animated:YES];
        });
        NSLog(@"当前已经播放%.2fs.",current);
        if (current) {
            [weakSelf.progress setProgress:(current/total) animated:YES];
            
            weakSelf.slider.maximumValue = total;
            NSLog(@".. %f",current/total);
        }
    }];
    
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
        if(status==AVPlayerStatusReadyToPlay){
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

#pragma mark - 通知
/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayer.currentItem];
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
    __weak typeof (self) weakSelf = self;
    [self.avPlayer seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished) {
        //weakSelf.isPlaying = NO;
        [weakSelf.avPlayer pause];
//        //切换视频
//        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_XF(75), SCREEN_WIDTH_XF(75))];
//        imv.image = [UIImage imageNamed:@"player_play"];
//        imv.userInteractionEnabled = YES;
//        imv.tag = 1200;
//        if (_isRevolve) {//全屏状态
//            imv.center = CGPointMake(_playView.frame.size.height / 2, _playView.frame.size.width / 2);
//        }else {
//            imv.center = CGPointMake(_playView.frame.size.width / 2, _playView.frame.size.height / 2);
//        }
//        //[imv addTapCallBack:self sel:@selector(finishPlayAction:)];
//        [weakSelf.playView addSubview:imv];
    }];
    
    //    [self removeNotification];
    //    [_playOrPause setImage:[UIImage imageNamed:@"player_play"] forState:(UIControlStateNormal)];
    //    self.isPlaying = NO;
    //    [self removeObserverFromPlayerItem:playerItems];
    //
    //    playerItems = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_videoURL]];
    //    [self addObserverToPlayerItem:playerItems];
    //    [self.avPlayer replaceCurrentItemWithPlayerItem:playerItems];
    //
    //
    //    
    //    [self addNotification];
    
}

/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    if (_avPlayer == nil) {
        return;
    }
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    if (_avPlayer == nil) {
        return;
    }
    [_avPlayer pause];
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    _playerItems = nil;
    _avPlayer = nil;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
