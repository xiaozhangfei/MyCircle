//
//  XFTopToast.h
//  MyCircle
//
//  Created by and on 15/12/18.
//  Copyright © 2015年 and. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XFTopToast : NSObject


+ (XFTopToast *)showXFTopViewWithText:(NSString *)text
                                image:(UIImage *)image
                                leftOffset:(CGFloat )leftOffset
                            topOffset:(CGFloat )topOffset
                            backColor:(UIColor *)color
                                time:(CGFloat )time;

@end
