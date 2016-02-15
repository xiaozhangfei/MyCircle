//
//  XFPageView.h
//  MyCircle
//
//  Created by and on 16/1/27.
//  Copyright © 2016年 and. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFPageView : UIView <UIScrollViewDelegate>
{
    UIScrollView *pageScroll;
    UIImageView *firstImv;
    UIImageView *midImv;
    UIImageView *lastImv;
    NSTimer *timer;//定时器
}

@property (nonatomic, strong) NSArray *imagesArr;

@end
