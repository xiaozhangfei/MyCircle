//
//  XFToolBarButton.h
//  MyCircle
//
//  Created by and on 16/3/18.
//  Copyright © 2016年 and. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^eventBlock)();


@interface XFToolBarButton : UIButton

+ (instancetype)buttonWithTitle:(NSString *)title;

+ (instancetype)buttonWithTitle:(NSString *)title andEvent:(eventBlock)event forControlEvents:(UIControlEvents)controlEvent;

- (void)addEvent:(eventBlock)event forControlEvents:(UIControlEvents)controlEvent;


@end
