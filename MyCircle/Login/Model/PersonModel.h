//
//  PersonModel.h
//  MyCircle
//
//  Created by and on 15/11/2.
//  Copyright © 2015年 and. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonModel : NSObject

@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *rctoken;
@property (copy, nonatomic) NSString *version;
@property (copy, nonatomic) NSString *device;
@property (copy, nonatomic) NSString *cdate;
@property (copy, nonatomic) NSString *udate;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *birth;
@property (copy, nonatomic) NSString *intro;
@property (copy, nonatomic) NSString *intrests;
@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSString *portrait;
@property (copy, nonatomic) NSString *background;

@end
