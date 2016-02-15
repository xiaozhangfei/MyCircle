//
//  FriendCell.h
//  MyCircle
//
//  Created by and on 15/12/31.
//  Copyright © 2015年 and. All rights reserved.
//

#import <SWTableViewCell/SWTableViewCell.h>

#import "FriendModel.h"

@interface FriendCell : SWTableViewCell

@property (strong, nonatomic) UIImageView *photoImg;
@property (strong, nonatomic) UILabel *nickLabel;
@property (strong, nonatomic) UILabel *marknameLabel;
@property (strong, nonatomic) UILabel *introLabel;
@property (strong, nonatomic) FriendModel *friendModel;

@end
