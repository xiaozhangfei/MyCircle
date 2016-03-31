//
//  UIScrollView+XFRefresh.m
//  MyCircle
//
//  Created by and on 16/2/15.
//  Copyright © 2016年 and. All rights reserved.
//

#import "UIScrollView+XFRefresh.h"

//@interface UIScrollView ()
//{
//    UIView *_head;
//    BOOL _refreshing;
//}
//@end

@implementation UIScrollView (XFRefresh)

- (UIView *)xfHeader {
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, -100, self.frame.size.width, 100)];
    head.backgroundColor = [UIColor orangeColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.text = @"xfRefresh 刷新";
    [head addSubview:label];
    //label.center = head.center;
    //_refreshing = NO;
    return head;
}

- (void)addXFRefreshHeader{
    //if (!head) {
        [self addSubview:[self xfHeader]];
    //}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y > 100 && _head && !_refreshing) {
//        [self getData];
//    }
}

- (void)getData {
    NSLog(@"xf getData");
}

@end
