//
//  CircleHotModel.h
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleHotModel : NSObject

@property (copy, nonatomic  ) NSString  *cid;
@property (copy, nonatomic  ) NSString  *pictures;//图片
@property (copy, nonatomic  ) NSString  *nickname;//昵称
@property (copy, nonatomic  ) NSString  *uid;//id
@property (copy, nonatomic  ) NSString  *time;//时间
@property (copy, nonatomic  ) NSString  *title;//标题
@property (copy, nonatomic  ) NSString  *intro;//描述
@property (copy, nonatomic  ) NSString  *location;//地点
@property (assign, nonatomic) NSInteger see;//浏览数
@property (copy, nonatomic  ) NSString  *portrait;//头像
@property (copy, nonatomic  ) NSString  *isnew;//是否最新


@end
