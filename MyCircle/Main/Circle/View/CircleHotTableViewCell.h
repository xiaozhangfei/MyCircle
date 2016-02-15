//
//  CircleHotTableViewCell.h
//  MyCircle
//
//  Created by and on 15/11/2.
//  Copyright © 2015年 and. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleHotModel;
@interface CircleHotTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *backImV;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *nickLabel;
@property (strong, nonatomic) UILabel *introLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *seeLabel;
@property (strong, nonatomic) UIImageView *photoImv;//头像

@property (strong, nonatomic) CircleHotModel *hotModel;

@end
