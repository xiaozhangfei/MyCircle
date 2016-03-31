//
//  FindOneModel.m
//  MyCircle
//
//  Created by and on 16/3/3.
//  Copyright © 2016年 and. All rights reserved.
//

#import "FindOneModel.h"

#import <MJExtension.h>

@implementation Location

+ (instancetype)mj_objectWithKeyValues:(id)keyValues {
    return nil;
}

@end

@implementation FindOneModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"f_id" : @"fid"};
}

@end
