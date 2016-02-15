//
//  PersonModel.m
//  MyCircle
//
//  Created by and on 15/11/2.
//  Copyright © 2015年 and. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"userid"]) {
        _uid = [NSString stringWithFormat:@"%@",value];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //[super setValue:value forUndefinedKey:key];
}

@end
