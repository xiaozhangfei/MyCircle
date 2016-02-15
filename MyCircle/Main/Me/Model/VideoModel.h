//
//  VideoModel.h
//  MyCircle
//
//  Created by and on 15/12/14.
//  Copyright © 2015年 and. All rights reserved.
//

#import "BaseView.h"

@interface VideoModel : BaseView

@property (copy, nonatomic) NSString *vid;
@property (copy, nonatomic) NSString *videourl;
@property (copy, nonatomic) NSString *videoname;
@property (copy, nonatomic) NSString *thumbimage;
@property (copy, nonatomic) NSString *thumbname;
@property (copy, nonatomic) NSString *videosize;
@property (copy, nonatomic) NSString *cdate;

@end
