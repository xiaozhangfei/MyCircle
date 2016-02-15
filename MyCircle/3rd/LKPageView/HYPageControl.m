//
//  HYPageControl.m
//  DaDiJinRong
//
//  Created by HY on 15/6/2.
//  Copyright (c) 2015年 HY. All rights reserved.
//

#import "HYPageControl.h"

@interface HYPageControl ()
{
    UIImage* _activeImage;
    UIImage* _inactiveImage;
}
@end

@implementation HYPageControl

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _activeImage = [UIImage imageNamed:@"pageContr_red"];
    _inactiveImage = [UIImage imageNamed:@"pageContr_w"];

    return self;
    
}

-(void)updateDots {
    for (int i = 0; i < [self.subviews count]; i++){
        
        UIImageView *dot = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage) dot.image = _activeImage;
        
        else dot.image = _inactiveImage;
    }
    
}

-(void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
    
}

@end
