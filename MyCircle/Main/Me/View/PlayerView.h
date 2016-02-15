//
//  PlayerView.h
//  MyCircle
//
//  Created by and on 15/12/15.
//  Copyright © 2015年 and. All rights reserved.
//

#import "BaseView.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerView : BaseView

@property (strong, nonatomic) UIView *playView;//
@property (strong, nonatomic) UIView *container; //播放器容器

@property (nonatomic, strong) UIView *controlPlayView;//控制器容器
@property (strong, nonatomic) UIButton *playOrPause; //播放/暂停按钮
@property (strong, nonatomic) UIProgressView *progress;//播放进度
@property (strong, nonatomic) UISlider *slider;//可拖拽进度条，与播放进度一样
@property (nonatomic, strong) UIImageView *zoneImageButton;//视频全屏按钮
@property (nonatomic, strong) UILabel *cuTimeLabel;
@property (strong, nonatomic) UILabel *allTimeLabel;
@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, assign) CGRect currentFrame;
@property (nonatomic, assign) BOOL isRevolve;//是否旋转
@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) AVPlayer *avPlayer;//视频播放器
@property (strong, nonatomic) AVPlayerItem *playerItems;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

- (void)startPlayerWithVideoUrl:(NSString *)videoUrl;

- (void)startPlay;

- (void)pausePlay;

- (void)stopPlay;

@end
