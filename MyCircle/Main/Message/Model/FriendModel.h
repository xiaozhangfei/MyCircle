//
//  FriendModel.h
//  MyCircle
//
//  Created by and on 15/12/31.
//  Copyright © 2015年 and. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

@property (copy, nonatomic) NSString *fid;
@property (copy, nonatomic) NSString *uid;//所属人的id
@property (copy, nonatomic) NSString *friendid;//朋友的id
@property (copy, nonatomic) NSString *nickname;//朋友的昵称
@property (copy, nonatomic) NSString *markname;//备注
@property (copy, nonatomic) NSString *intro;//简介
@property (copy, nonatomic) NSString *portrait;//碰哟的头像
@property (copy, nonatomic) NSString *cdate;//建立朋友关系的时间

@end
