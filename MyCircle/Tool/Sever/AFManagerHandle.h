//
//  AFManagerHandle.h
//  Chuangdou
//
//  Created by tech on 15/7/16.
//  Copyright (c) 2015年 and. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperationManager;

@interface AFManagerHandle : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

+ (instancetype) shareHandle;

- (void)reset;//重置

- (void)update;//修正

//添加httpHeader键值对
- (void)addHttpHeaderWithKey:(NSString *)key value:(NSString *)value;

@end
