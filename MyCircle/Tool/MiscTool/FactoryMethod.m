//
//  FactoryMethod.m
//  MyCircle
//
//  Created by and on 15/11/3.
//  Copyright © 2015年 and. All rights reserved.
//

#import "FactoryMethod.h"

@implementation FactoryMethod

+ (UIImageView *)imageViewWithFrame:(CGRect )frame image:(UIImage *)image {
    UIImageView *imv = [[UIImageView alloc] initWithFrame:frame];
    imv.image = image;
    return imv;
}

+ (UIButton *)buttonWithFrame:(CGRect )frame target:(id)target action:(SEL)action buttonType:(UIButtonType)type {
    UIButton *button = [UIButton buttonWithType:(type)];
    button.frame = frame;
    [button addTarget:target action:@selector(action) forControlEvents:(UIControlEventTouchUpInside)];
    return button;
}



@end
