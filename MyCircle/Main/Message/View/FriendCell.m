//
//  FriendCell.m
//  MyCircle
//
//  Created by and on 15/12/31.
//  Copyright © 2015年 and. All rights reserved.
//

#import "FriendCell.h"
#import <UIImageView+WebCache.h>

@interface FriendCell ()


@end

@implementation FriendCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

//右边选项钮
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"修改备注"];//文字
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

- (void)initView {
    
    _photoImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    _photoImg.layer.masksToBounds = YES;
    _photoImg.layer.cornerRadius = SCREEN_CURRETWIDTH(10);
    [self.contentView addSubview:_photoImg];
    
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nickLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:_nickLabel];
    _marknameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _marknameLabel.font = [UIFont systemFontOfSize:13.0f];
    _marknameLabel.textColor = UIColorFromRGB(120, 120, 120);
    [self.contentView addSubview:_marknameLabel];
    //
    _introLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _introLabel.font = [UIFont systemFontOfSize:12.0f];
    _introLabel.textColor = UIColorFromRGB(120, 120, 120);
    [self.contentView addSubview:_introLabel];
    self.rightUtilityButtons = [self rightButtons];//右边选项钮
}

- (void)setFriendModel:(FriendModel *)friendModel {
    if (_friendModel != friendModel) {
        _friendModel = friendModel;
        NSString *nick = _friendModel.nickname;
        if (!ISEMPTY(_friendModel.markname)) {
            nick = [NSString stringWithFormat:@"%@(%@)",_friendModel.nickname,_friendModel.markname];
        }
        _nickLabel.text = nick;
        _introLabel.text = _friendModel.intro;
        if (ISEMPTY(_friendModel.portrait)) {
            _photoImg.image = [UIImage imageNamed:@"login_head portrait"];
        }else {
            [_photoImg sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:_friendModel.portrait]] placeholderImage:[UIImage imageNamed:@"login_head portrait"] completed:nil];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _photoImg.frame = CGRectMake(SCREEN_CURRETWIDTH(15), SCREEN_CURRETWIDTH(15), SCREEN_CURRETWIDTH(80), SCREEN_CURRETWIDTH(80));
    _nickLabel.frame = CGRectMake(CGRectGetMaxX(_photoImg.frame) + SCREEN_CURRETWIDTH(15), CGRectGetMinY(_photoImg.frame), self.contentView.width - CGRectGetMaxX(_photoImg.frame) - SCREEN_CURRETWIDTH(45), _photoImg.height / 2);
    _introLabel.frame = CGRectMake(CGRectGetMinX(_nickLabel.frame), CGRectGetMaxY(_nickLabel.frame), CGRectGetWidth(_nickLabel.frame), CGRectGetHeight(_nickLabel.frame));
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
