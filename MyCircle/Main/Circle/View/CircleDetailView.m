//
//  CircleDetailView.m
//  MyCircle
//
//  Created by and on 15/12/19.
//  Copyright © 2015年 and. All rights reserved.
//

#import "CircleDetailView.h"
#import "AppMacro.h"
#import "UtilsMacro.h"
#import <UIImageView+WebCache.h>
#import "XFAPI.h"
@implementation CircleDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _backScroll = [[UIScrollView alloc] initWithFrame:self.frame];
    [self addSubview:_backScroll];
    
    _adScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _adScroll.pagingEnabled = YES;
    [self addSubview:_adScroll];
    
    _firstImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_adScroll addSubview:_firstImg];
    
    _secondImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_adScroll addSubview:_secondImg];
    
    _playIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _playIcon.image = [UIImage imageNamed:@"playvideo"];
    [_adScroll addSubview:_playIcon];
    
    
    
    _photoImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_photoImg];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_titleLabel];
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_introLabel];
    
    _photoImg.layer.masksToBounds = YES;
    _photoImg.layer.cornerRadius = SCREEN_ORIGINWIDTH_5(40);
    
    _titleLabel.textColor = [UIColor whiteColor];
    _introLabel.numberOfLines = 3;
}

- (void)setDetailModel:(CircleDetailModel *)detailModel {
    if (_detailModel != detailModel) {
        _detailModel = detailModel;
        if (!ISEMPTY(_detailModel.vpath)) {
            [_firstImg sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:_detailModel.vthumb]] completed:nil];
        }
        [_secondImg sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:_detailModel.pictures]] completed:nil];
        _titleLabel.text = _detailModel.title;
        _introLabel.text = _detailModel.intro;
        [_photoImg sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:_detailModel.portrait]] completed:nil];
        [self layoutSubviews];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _adScroll.frame = CGRectMake(0, 0, self.frame.size.width, SCREEN_ORIGINWIDTH_5(450));
    if (!ISEMPTY(_detailModel.vpath)) {
        _adScroll.contentSize = CGSizeMake(self.frame.size.width * 2, _adScroll.frame.size.height);
        _firstImg.frame = CGRectMake(0, 0, _adScroll.frame.size.width, _adScroll.frame.size.height);
        _playIcon.frame = CGRectMake(0, 0, SCREEN_ORIGINWIDTH_5(100), SCREEN_ORIGINWIDTH_5(100));
        _playIcon.center = _firstImg.center;
    }else {
        _adScroll.contentSize = CGSizeMake(self.frame.size.width, _adScroll.frame.size.height);
        _firstImg.frame = CGRectMake(0, 0, 0, 0);
    }
    _secondImg.frame = CGRectMake(CGRectGetMaxX(_firstImg.frame), 0, _adScroll.frame.size.width, _adScroll.frame.size.height);
    _photoImg.frame = CGRectMake(SCREEN_ORIGINWIDTH_5(30), _adScroll.frame.size.height - SCREEN_ORIGINWIDTH_5(90), SCREEN_ORIGINWIDTH_5(80), SCREEN_ORIGINWIDTH_5(80));
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_photoImg.frame), CGRectGetMinY(_photoImg.frame), _adScroll.frame.size.width - CGRectGetMaxX(_photoImg.frame), _photoImg.frame.size.height);
    _introLabel.frame = CGRectMake(SCREEN_ORIGINWIDTH_5(20), CGRectGetMaxY(_adScroll.frame), _adScroll.frame.size.width - 2 * SCREEN_ORIGINWIDTH_5(20), SCREEN_ORIGINWIDTH_5(100));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
