//
//  XFTextField.m
//  MyCircle
//
//  Created by and on 15/12/29.
//  Copyright © 2015年 and. All rights reserved.
//

#import "XFTextField.h"

@implementation XFTextField


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *color = _boColor ? _boColor : [UIColor whiteColor];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}


@end
