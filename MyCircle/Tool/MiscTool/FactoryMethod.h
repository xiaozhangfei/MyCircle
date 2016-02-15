//
//  FactoryMethod.h
//  MyCircle
//
//  Created by and on 15/11/3.
//  Copyright © 2015年 and. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
@interface FactoryMethod : NSObject

+ (UIImageView *)imageViewWithFrame:(CGRect )frame image:(UIImage *)image;

+ (UIButton *)buttonWithFrame:(CGRect )frame target:(id)target action:(SEL)action buttonType:(UIButtonType)type;

@end
