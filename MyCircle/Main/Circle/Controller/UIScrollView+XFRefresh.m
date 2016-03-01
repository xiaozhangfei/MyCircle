//
//  UIScrollView+XFRefresh.m
//  MyCircle
//
//  Created by and on 16/2/15.
//  Copyright © 2016年 and. All rights reserved.
//

#import "UIScrollView+XFRefresh.h"

@implementation UIScrollView (XFRefresh)

- (UIView *)xfHeader {
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, -100, self.frame.size.width, 100)];
    head.backgroundColor = [UIColor orangeColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.text = @"xfRefresh 刷新";
    [head addSubview:label];
    //label.center = head.center;
    return head;
}

- (void)addXFRefreshHeader {
    [self addSubview:[self xfHeader]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
