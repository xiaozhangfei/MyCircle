//
//  LeftHeaderView.m
//  MyCircle
//
//  Created by and on 15/12/13.
//  Copyright © 2015年 and. All rights reserved.
//

#import "LeftHeaderView.h"
#import "AppMacro.h"
#import <Masonry.h>
@implementation LeftHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _portraitImv = [[UIImageView alloc] initWithFrame:CGRectZero];
    _portraitImv.layer.masksToBounds = YES;
    _portraitImv.layer.cornerRadius = SCREEN_CURRETWIDTH(75);
    [self addSubview:_portraitImv];
    
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_nickLabel];
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_introLabel];
    
    __weak typeof (self) weakSelf = self;
    [_portraitImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.mas_left).with.offset (SCREEN_CURRETWIDTH(30));
        make.top.equalTo (weakSelf.mas_top).with.offset (SCREEN_CURRETWIDTH(80));
        make.width.offset (SCREEN_CURRETWIDTH(150));
        make.height.offset (SCREEN_CURRETWIDTH(150));
    }];
    
    [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.portraitImv.mas_right).with.offset (SCREEN_CURRETWIDTH(10));
        make.top.equalTo (weakSelf.portraitImv.mas_top).with.offset (0);
        make.right.equalTo (weakSelf.mas_right).with.offset (SCREEN_CURRETWIDTH(-10));
        make.height.equalTo (weakSelf.portraitImv.mas_height);
    }];
    
    [_introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.portraitImv.mas_left);
        make.right.equalTo (weakSelf.nickLabel.mas_right);
        make.top.equalTo (weakSelf.portraitImv.mas_bottom).with.offset (SCREEN_CURRETWIDTH(10));
        make.height.offset (SCREEN_CURRETWIDTH(50));
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
