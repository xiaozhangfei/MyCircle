//
//  CircleHotModel.m
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import "CircleHotModel.h"

@implementation CircleHotModel

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
