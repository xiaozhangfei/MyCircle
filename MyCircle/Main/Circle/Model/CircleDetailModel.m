//
//  CircleDetailModel.m
//  MyCircle
//
//  Created by and on 15/12/19.
//  Copyright © 2015年 and. All rights reserved.
//

#import "CircleDetailModel.h"

@implementation CircleDetailModel

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"see"]) {
        self.see = [value integerValue];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //[super setValue:value forUndefinedKey:key];
    
}

@end
