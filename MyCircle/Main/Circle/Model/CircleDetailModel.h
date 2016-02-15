//
//  CircleDetailModel.h
//  MyCircle
//
//  Created by and on 15/12/19.
//  Copyright © 2015年 and. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleDetailModel : NSObject

@property (copy, nonatomic) NSString *cid;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *intro;
@property (copy, nonatomic) NSString *pictures;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *location;
@property (assign, nonatomic) NSInteger see;
@property (copy, nonatomic) NSString *isnew;

@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *portrait;

@property (copy, nonatomic) NSString *vid;
@property (copy, nonatomic) NSString *vthumb;
@property (copy, nonatomic) NSString *vpath;
@property (copy, nonatomic) NSString *vcdate;
@property (copy, nonatomic) NSString *vname;


@end
