//
//  BtnExt.m
//  MyCircle
//
//  Created by and on 16/1/4.
//  Copyright © 2016年 and. All rights reserved.
//

#import "BtnExt.h"

@implementation BtnExt


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imageWidth = self.imageSize.width;
    CGFloat imageHeight = self.imageSize.height;
//    imageWidth = imageWidth == 0 ? 60 : imageWidth;
//    imageHeight = imageHeight == 0 ? 60 : imageHeight;
    
    switch (self.btnType) {
        case XFBtnTypeDefault:
            
            break;
        case XFBtnTypeBottom:
        {
            // Center image
            CGRect rect = CGRectMake(0, 0, imageWidth, imageHeight);
            self.imageView.frame = rect;
            CGPoint center = CGPointZero;//取中心
            center.x = self.frame.size.width/2;
            center.y = self.imageView.frame.size.height / 2 - self.imageToBorderOffset;
            self.imageView.center = center;
            
            //Center text
            CGRect newFrame = [self titleLabel].frame;
            newFrame.origin.x = 0;
            newFrame.origin.y = CGRectGetMaxY(self.imageView.frame) + 5;
            newFrame.size.width = self.frame.size.width;
            self.titleLabel.frame = newFrame;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case XFBtnTypeRight:
        {
            // image
            CGRect rect = CGRectMake(self.imageToBorderOffset, (self.frame.size.height - imageHeight) / 2, imageWidth, imageWidth);
            self.imageView.frame = rect;
            
            //Center text
            CGRect r1 = CGRectMake(CGRectGetMaxX(self.imageView.frame), CGRectGetMinY(self.imageView.frame), self.frame.size.width - CGRectGetMaxX(self.imageView.frame), self.imageView.frame.size.height);
            self.titleLabel.frame = r1;
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case XFBtnTypeLeft:
        {
            
        }
            break;
        case XFBtnTypeTop:
        {
            
        }
            break;
        default:
            break;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
