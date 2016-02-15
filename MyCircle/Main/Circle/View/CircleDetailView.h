//
//  CircleDetailView.h
//  MyCircle
//
//  Created by and on 15/12/19.
//  Copyright © 2015年 and. All rights reserved.
//

#import "BaseView.h"
#import "CircleDetailModel.h"
@interface CircleDetailView : BaseView
{
    UIImageView *_firstImg;
    UIImageView *_secondImg;
}

@property (strong, nonatomic) UIScrollView *backScroll;
@property (strong, nonatomic) UIScrollView *adScroll;
@property (strong, nonatomic) UIImageView *playIcon;
@property (strong, nonatomic) UIImageView *photoImg;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *introLabel;

@property (strong, nonatomic) CircleDetailModel *detailModel;

@end
