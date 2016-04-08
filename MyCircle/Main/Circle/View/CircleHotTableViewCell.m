//
//  CircleHotTableViewCell.m
//  MyCircle
//
//  Created by and on 15/11/2.
//  Copyright © 2015年 and. All rights reserved.
//

#import "CircleHotTableViewCell.h"

#import <Masonry.h>
#import "CircleHotModel.h"
#import <UIImageView+WebCache.h>
#import "AppMacro.h"
#import "XFAPI.h"
#import "UtilsMacro.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
@interface CircleHotTableViewCell ()
{
    UIView *_pointView;//小圆点
}

@end

@implementation CircleHotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initView {
    _backImV = [[UIImageView alloc] init];
    _backImV.layer.masksToBounds = YES;
    _backImV.layer.cornerRadius = SCREEN_CURRETWIDTH(10);
    [self.contentView addSubview:_backImV];
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];
    _timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_timeLabel];
    _nickLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_nickLabel];
    _introLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_introLabel];
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.numberOfLines = 2;
    [self.contentView addSubview:_locationLabel];
    _seeLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_seeLabel];
    _photoImv = [[UIImageView alloc] init];
    _photoImv.layer.masksToBounds = YES;
    _photoImv.layer.cornerRadius = SCREEN_CURRETWIDTH(40);
    [self.contentView addSubview:_photoImv];
    _pointView = [[UIView alloc] init];
    [self.contentView addSubview:_pointView];
    
    //背景色
    _backImV.backgroundColor = HexColor(0xE7DDC7);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:14.0f];
    _nickLabel.textColor = [UIColor whiteColor];
    _nickLabel.font = [UIFont systemFontOfSize:14.0f];
    _introLabel.textColor = [UIColor whiteColor];
    _introLabel.font = [UIFont systemFontOfSize:14.0f];
    _locationLabel.textColor = [UIColor whiteColor];
    _locationLabel.font = [UIFont systemFontOfSize:14.0f];
    _seeLabel.textColor = [UIColor whiteColor];
    _seeLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    __weak typeof (self) weakSelf = self;
    [_backImV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.contentView.mas_top).with.offset (SCREEN_CURRETWIDTH(10));
        make.left.equalTo (weakSelf.contentView.mas_left).with.offset (SCREEN_CURRETWIDTH(10));
        make.right.equalTo (weakSelf.contentView.mas_right).with.offset (SCREEN_CURRETWIDTH(-10));
        make.bottom.equalTo (weakSelf.contentView.mas_bottom).with.offset (SCREEN_CURRETWIDTH(-10));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.backImV.mas_top).with.offset (SCREEN_CURRETWIDTH(10));
        make.left.equalTo (weakSelf.backImV.mas_left).with.offset (SCREEN_CURRETWIDTH(10));
        make.right.equalTo (weakSelf.backImV.mas_right).with.offset (SCREEN_CURRETWIDTH(-10));
        make.height.offset (SCREEN_CURRETWIDTH(40));
    }];
    
    [_introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.titleLabel.mas_left).with.offset (0);
        make.top.equalTo (weakSelf.titleLabel.mas_bottom).with.offset (SCREEN_CURRETWIDTH(0));
        make.right.equalTo (weakSelf.titleLabel.mas_right).with.offset (0);
        make.height.equalTo (weakSelf.titleLabel.mas_height).with.offset (0);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.introLabel.mas_left).with.offset (0);
        make.top.equalTo (weakSelf.introLabel.mas_bottom).with.offset (SCREEN_CURRETWIDTH(0));
        make.width.offset (SCREEN_CURRETWIDTH(300));
        make.height.equalTo (weakSelf.introLabel.mas_height).with.offset (0);
    }];
    
    [_seeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.timeLabel.mas_right).with.offset (SCREEN_CURRETWIDTH(20));
        make.top.equalTo (weakSelf.timeLabel.mas_top).with.offset (0);
        make.width.offset (SCREEN_CURRETWIDTH(200));
        make.height.equalTo (weakSelf.timeLabel.mas_height).with.offset (0);
    }];
    
    [_photoImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.timeLabel.mas_left).with.offset (0);
        make.top.equalTo (weakSelf.backImV.mas_bottom).with.offset (SCREEN_CURRETWIDTH(-90));
        make.width.offset (SCREEN_CURRETWIDTH(80));
        make.height.offset (SCREEN_CURRETWIDTH(80));
    }];
    
    [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.photoImv.mas_right).with.offset (SCREEN_CURRETWIDTH(10));
        make.top.equalTo (weakSelf.photoImv.mas_top).with.offset (0);
        make.right.equalTo (weakSelf.backImV.mas_right).with.offset (SCREEN_CURRETWIDTH(-320));
        make.bottom.equalTo (weakSelf.photoImv.mas_bottom).with.offset (0);
    }];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.nickLabel.mas_right).with.offset (SCREEN_CURRETWIDTH(10));
        make.top.equalTo (weakSelf.nickLabel.mas_top).with.offset (0);
        make.right.equalTo (weakSelf.backImV.mas_right).with.offset (SCREEN_CURRETWIDTH(-10));
        make.bottom.equalTo (weakSelf.nickLabel.mas_bottom).with.offset (0);
    }];
    
}

- (void)setHotModel:(CircleHotModel *)hotModel {
    if (_hotModel != hotModel) {
        _hotModel = hotModel;
        //赋值
        self.titleLabel.text = _hotModel.title;
        self.introLabel.text = _hotModel.intro;
        self.timeLabel.text = _hotModel.time;
        self.seeLabel.text = [NSString stringWithFormat:@"%@：%ld",LocalString(@"circle_see"),_hotModel.see];
        self.nickLabel.text = _hotModel.nickname;
        self.locationLabel.text = _hotModel.location;
        [self.photoImv sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:_hotModel.portrait]] placeholderImage:[UIImage imageNamed:@"man"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
//        [self.backImV sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:_hotModel.pictures]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//        }];
        [self.backImV setImageWithURL:[NSURL URLWithString:[XFAPI image_url:_hotModel.pictures]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        } usingActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    }
}
















@end
