//
//  UIScrollView+XFRefresh.h
//  MyCircle
//
//  Created by and on 16/2/15.
//  Copyright © 2016年 and. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (XFRefresh) <UIScrollViewDelegate>

- (void)addXFRefreshHeader;

- (void)getData;

@end
