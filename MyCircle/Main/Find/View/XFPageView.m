//
//  XFPageView.m
//  MyCircle
//
//  Created by and on 16/1/27.
//  Copyright © 2016年 and. All rights reserved.
//

#import "XFPageView.h"

@implementation XFPageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        
    }
    return self;
}


- (void)initView {
    pageScroll = [[UIScrollView alloc] initWithFrame:CGRectZero];
    pageScroll.delegate = self;
    pageScroll.pagingEnabled = YES;
    pageScroll.alwaysBounceHorizontal = YES;
    [self addSubview:pageScroll];
    firstImv = [[UIImageView alloc] initWithFrame:CGRectZero];
    [pageScroll addSubview:firstImv];
    midImv = [[UIImageView alloc] initWithFrame:CGRectZero];
    [pageScroll addSubview:midImv];
    lastImv = [[UIImageView alloc] initWithFrame:CGRectZero];
    [pageScroll addSubview:lastImv];
}

- (void)setImagesArr:(NSArray *)imagesArr {
    firstImv.image = [UIImage imageNamed:imagesArr[0]];
    midImv.image = [UIImage imageNamed:imagesArr[1]];
    lastImv.image = [UIImage imageNamed:imagesArr[2]];
    [self layoutIfNeeded];
}

- (void)initTimer {
    timer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)timerAction {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    pageScroll.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    pageScroll.contentSize = CGSizeMake(3 * self.frame.size.width, self.frame.size.height);
    //调整contentOffset
    //pageScroll.contentOffset
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    firstImv.frame = rect;
    rect.origin.x += self.frame.size.width;
    midImv.frame = rect;
    rect.origin.x += self.frame.size.width;
    lastImv.frame = rect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
