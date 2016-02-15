//
//  CollectView.h
//  MyCircle
//
//  Created by and on 15/12/14.
//  Copyright © 2015年 and. All rights reserved.
//

#import "BaseView.h"

@class VideoModel;
@interface CollectView : BaseView

@property (strong, nonatomic) UILabel *videoName;//视频名称
@property (strong, nonatomic) UIImageView *thumbImage;//缩略图
@property (strong, nonatomic) UILabel *sizeLabel;//大小
@property (strong, nonatomic) UIImageView *progressImage;//圆环进度

@property (strong, nonatomic) VideoModel *videoModel;

@end
