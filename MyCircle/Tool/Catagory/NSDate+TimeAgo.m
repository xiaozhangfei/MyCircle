
//
//  NSDate+TimeAgo.m
//  Chuangdou
//
//  Created by Jiangxing on 15/7/23.
//  Copyright (c) 2015年 and. All rights reserved.
//

#import "NSDate+TimeAgo.h"

@implementation NSDate (TimeAgo)

- (NSString *)timeAgo
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    int minutes;
    
    if(deltaSeconds < 5)
    {
        return @"刚刚";
    }
    else if(deltaSeconds < 60)
    {
        return [NSString stringWithFormat:@"%.0f秒钟之前",deltaSeconds];
    }
    else if(deltaSeconds < 120)
    {
        return [NSString stringWithFormat:@"1分钟之前"];
    }
    else if (deltaMinutes < 60)
    {
        return [NSString stringWithFormat:@"%.0f分钟之前",deltaMinutes];
    }
    else if (deltaMinutes < 120)
    {
        return [NSString stringWithFormat:@"1小时之前"];
    }
    else if (deltaMinutes < (24 * 60))
    {
        minutes = (int)floor(deltaMinutes/60);
        return [NSString stringWithFormat:@"%d小时之前",minutes];
    }
    else if (deltaMinutes < (24 * 60 * 2))
    {
        return @"昨天";
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24));
        return [NSString stringWithFormat:@"%d天之前",minutes];
    }
    else if (deltaMinutes < (24 * 60 * 14))
    {
        return @"上周";
    }
    else if (deltaMinutes < (24 * 60 * 31))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 7));
        return [NSString stringWithFormat:@"%d周之前",minutes];
    }
    else if (deltaMinutes < (24 * 60 * 61))
    {
        return @"上个月";
    }
    else if (deltaMinutes < (24 * 60 * 365.25))
    {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 30));
        return [NSString stringWithFormat:@"%d个月之前",minutes];
    }
    else if (deltaMinutes < (24 * 60 * 731))
    {
        return @"去年";
    }
    
    minutes = (int)floor(deltaMinutes/(60 * 24 * 365));
    return [NSString stringWithFormat:@"%d年之前",minutes];
}

@end
