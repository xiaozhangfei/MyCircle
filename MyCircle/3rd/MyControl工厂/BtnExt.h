//
//  BtnExt.h
//  MyCircle
//
//  Created by and on 16/1/4.
//  Copyright © 2016年 and. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XFBtnTypeDefault,//默认
    XFBtnTypeLeft,//标题在左
    XFBtnTypeTop,//标题在上
    XFBtnTypeRight,//标题在右
    XFBtnTypeBottom//标题在下
} XFBtnType;

@interface BtnExt : UIButton

@property (assign, nonatomic) XFBtnType btnType;//按钮的类型
@property (assign, nonatomic) CGSize imageSize;//图片大小
@property (assign, nonatomic) CGFloat imageToBorderOffset;//图片向边框的偏移量

@end
