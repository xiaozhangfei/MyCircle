//
//  TouchIDView.m
//  MyCircle
//
//  Created by and on 15/11/5.
//  Copyright © 2015年 and. All rights reserved.
//

#import "TouchIDView.h"

#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "XFAPI.h"
#import "XFAppContext.h"
@implementation TouchIDView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _photoImv = [[UIImageView alloc] init];
    //_photoImv.backgroundColor = [UIColor cyanColor];
    _photoImv.layer.masksToBounds = YES;
    _photoImv.layer.cornerRadius = 40;
    [self addSubview:_photoImv];
    [_photoImv sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:[XFAppContext sharedContext].portrait]] placeholderImage:[UIImage imageNamed:@"login_head portrait@2x"] completed:nil];
    
    _touchImv = [[UIImageView alloc] init];
    _touchImv.tag = 1301;
    _touchImv.image = [UIImage imageNamed:@"alipay_msp_mini_finger"];
    [self addSubview:_touchImv];
    
    _touchLabel = [[UILabel alloc] init];
    _touchLabel.text = @"点击进行指纹解锁";
    _touchLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_touchLabel];
    
    _loginToElseLabel = [[UILabel alloc] init];
    _loginToElseLabel.text = @"使用验证码登入";
    _loginToElseLabel.textAlignment = NSTextAlignmentCenter;
    _loginToElseLabel.tag = 1302;
    [self addSubview:_loginToElseLabel];
    
    __weak typeof (self) weakSelf = self;
    
    [_photoImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.mas_top).with.offset (100);
        make.centerX.equalTo (weakSelf.mas_centerX).with.offset (0);
        make.width.offset(80);
        make.height.offset(80);
    }];
    
    [_touchImv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo (weakSelf.mas_centerY).with.offset (0);
        make.centerX.equalTo (weakSelf.mas_centerX).with.offset (0);
        make.width.offset(120);
        make.height.offset(120);
    }];
    
    [_touchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.touchImv.mas_bottom).with.offset(20);
        make.centerX.equalTo (weakSelf.mas_centerX).with.offset (0);
        make.width.equalTo (weakSelf.mas_width).with.offset (0);
        make.height.offset (40);
    }];
    
    [_loginToElseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.mas_bottom).with.offset (-100);
        make.centerX.equalTo (weakSelf.mas_centerX).with.offset (0);
        make.width.equalTo (weakSelf.mas_width).with.offset (0);
        make.height.offset (40);

    }];
    
    
    
    
}

@end
