//
//  AFManagerHandle.m
//  Chuangdou
//
//  Created by tech on 15/7/16.
//  Copyright (c) 2015年 and. All rights reserved.
//

#import "AFManagerHandle.h"
#import <AFHTTPRequestOperationManager.h>

static AFManagerHandle *_manager = nil;
@implementation AFManagerHandle

- (instancetype)init
{
    if (self = [super init]) {
        self.manager = [[AFHTTPRequestOperationManager alloc] init];
        _manager = [AFHTTPRequestOperationManager manager];
        // 设置请求头
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc] init];
        NSString *uid;
        if (ISEMPTY([XFAppContext sharedContext].uid)) {
            uid = @"111";
        }else {
            uid = [XFAppContext sharedContext].uid;
        }
        NSString *token;
        if (ISEMPTY([XFAppContext sharedContext].token)) {
            token = @"222";
        }else {
            token = [XFAppContext sharedContext].token;
        }
        
        NSLog(@"ids = %@",[XFAppContext sharedContext].uid);
        NSLog(@"tokens = %@",[XFAppContext sharedContext].token);
        NSLog(@"version = %@",APP_VERSION);
        NSLog(@"uuid = %@",APP_UUID);
        [serializer setValue:uid forHTTPHeaderField:@"UID"];
        [serializer setValue:token forHTTPHeaderField:@"TOKEN"];
        [serializer setValue:APP_UUID forHTTPHeaderField:@"DEVICE"];
        [serializer setValue:APP_VERSION forHTTPHeaderField:@"VERSION"];
        _manager.requestSerializer = serializer;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

+ (instancetype) shareHandle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[AFManagerHandle alloc] init];
    });
    return _manager;
}

- (void)reset//重置
{
    // 重置请求头
    AFHTTPRequestSerializer *serializer = _manager.requestSerializer;
    [serializer setValue:@"111" forHTTPHeaderField:@"UID"];
    [serializer setValue:@"222" forHTTPHeaderField:@"TOKEN"];
    [serializer setValue:APP_UUID forHTTPHeaderField:@"DEVICE"];
    [serializer setValue:APP_VERSION forHTTPHeaderField:@"VERSION"];
    _manager.requestSerializer = serializer;
}

- (void)update//修正
{
    // 修正请求头
    AFHTTPRequestSerializer *serializer = _manager.requestSerializer;
    [serializer setValue:[XFAppContext sharedContext].uid forHTTPHeaderField:@"UID"];
    [serializer setValue:[XFAppContext sharedContext].token forHTTPHeaderField:@"TOKEN"];
    [serializer setValue:APP_UUID forHTTPHeaderField:@"DEVICE"];
    [serializer setValue:APP_VERSION forHTTPHeaderField:@"VERSION"];
    _manager.requestSerializer = serializer;
}

//添加httpHeader键值对
- (void)addHttpHeaderWithKey:(NSString *)key value:(NSString *)value {
    AFHTTPRequestSerializer *serializer = _manager.requestSerializer;
    [serializer setValue:value forHTTPHeaderField:key];
//    _manager.requestSerializer = serializer;
}
@end
