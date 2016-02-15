//
//  CollectView.m
//  MyCircle
//
//  Created by and on 15/12/14.
//  Copyright © 2015年 and. All rights reserved.
//

#import "CollectView.h"
#import "AppMacro.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "XFAPI.h"
#import "VideoModel.h"
@implementation CollectView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _thumbImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_thumbImage];
    
    _videoName = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_videoName];
    
    _sizeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_sizeLabel];
    
    _progressImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_progressImage];
    
    __weak typeof (self) weakSelf = self;
    [_thumbImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.mas_left).with.offset (SCREEN_CURRETWIDTH(20));
        make.top.equalTo (weakSelf.mas_top).with.offset (SCREEN_CURRETWIDTH(20));
        make.width.offset (SCREEN_CURRETWIDTH(90));
        make.bottom.equalTo (weakSelf.mas_bottom).with.offset (SCREEN_CURRETWIDTH(-20));
    }];
    
    [_videoName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.thumbImage.mas_right).with.offset (SCREEN_CURRETWIDTH(10));
        make.top.equalTo (weakSelf.thumbImage.mas_top);
        make.right.equalTo (weakSelf.mas_right).with.offset (SCREEN_CURRETWIDTH(-130));
        make.height.equalTo (weakSelf.mas_height).with.offset (SCREEN_CURRETWIDTH(45));
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.videoName.mas_left);
        make.top.equalTo (weakSelf.videoName.mas_bottom);
        make.width.equalTo (weakSelf.videoName.mas_width);
        make.height.equalTo (weakSelf.videoName.mas_height);
    }];
    
    [_progressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.mas_left).with.offset (SCREEN_CURRETWIDTH(20));
        make.right.equalTo (weakSelf.mas_right).with.offset (SCREEN_CURRETWIDTH(-20));
        make.width.equalTo (weakSelf.thumbImage.mas_width);
        make.height.equalTo (weakSelf.thumbImage.mas_height);
    }];
    
}

- (void)setVideoModel:(VideoModel *)videoModel {
    if (_videoModel != videoModel) {
        _videoModel = videoModel;
        [_thumbImage sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:_videoModel.thumbname]] completed:nil];
        _videoName.text = _videoModel.videoname;
        _sizeLabel.text = [NSString stringWithFormat:@"%@B/%@M",@"100",_videoModel.videosize];
        //进度条设置
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
