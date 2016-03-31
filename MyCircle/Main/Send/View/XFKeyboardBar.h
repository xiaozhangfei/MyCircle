//
//  XFKeyboardBar.h
//  MyCircle
//
//  Created by and on 16/3/18.
//  Copyright © 2016年 and. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFKeyboardBar : UIView
@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) NSArray *buttonsWidth;

+ (instancetype)initWithButtons:(NSArray *)buttons widths:(NSArray *)widths;

@end
