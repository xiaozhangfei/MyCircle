//
//  BaseModel.m
//  Chuangdou
//
//  Created by tech on 15/7/1.
//  Copyright (c) 2015年 and. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    NSLog(@"2");
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"description"]) {
        _s_description = value;
    }
    if ([key isEqualToString:@"error"]) {
        _error = [value boolValue];
    }

}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //[super setValue:value forUndefinedKey:key];
    
}

@end
