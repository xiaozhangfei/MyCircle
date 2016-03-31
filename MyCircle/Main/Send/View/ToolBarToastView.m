//
//  ToolBarToastView.m
//  MyCircle
//
//  Created by and on 16/3/18.
//  Copyright © 2016年 and. All rights reserved.
//

#import "ToolBarToastView.h"

@interface ToolBarToastView ()
{
    UIScrollView *_scrollView;
}


@end

@implementation ToolBarToastView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    //[self drawBackView];
    self.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self addSubview:_scrollView];
    
    for (UIButton *btn in _buttons) {
        [_scrollView addSubview:btn];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat totalWith = 0;
    for (NSNumber *width in _buttonsWidth) {
        totalWith += [width floatValue];
    }
    CGFloat mr = 5.0f;
    CGFloat radius = 10.0f;
    if (totalWith > WIDTH(self) - mr * 2) {
        CGFloat margin = 10;
        _scrollView.frame = CGRectMake(mr, mr, WIDTH(self) - 2 * mr, HEIGHT(self) - 2 * mr);
        CGRect rect = CGRectMake(0, 0, 0, HEIGHT(self) - 2 * mr);
        for (int i = 0; i < _buttons.count; i ++) {
            UIButton *btn = _buttons[i];
            rect.size.width = [_buttonsWidth[i] floatValue];
            btn.frame = rect;
            rect.origin.x += rect.size.width + margin;
        }
        _scrollView.contentSize = CGSizeMake(totalWith + _buttons.count * mr, _scrollView.frame.size.height);
    }else {
        CGFloat des = (WIDTH(self) - totalWith - 2 * mr) / _buttons.count;
        _scrollView.frame = CGRectMake(mr, mr, WIDTH(self) - 2 * mr, HEIGHT(self) - 2 * mr);
        CGRect rect = CGRectMake(mr, 0, 0, HEIGHT(self) - 2 * mr);
        for (int i = 0; i < _buttons.count; i ++) {
            UIButton *btn = _buttons[i];
            rect.size.width = [_buttonsWidth[i] floatValue];
            btn.frame = rect;
            rect.origin.x += rect.size.width + des;
        }
    }
    
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext(); //设置上下文
    
    //创建路径 创建一个新的 CGMutablePathRef 类型的可变路径并返回其句柄。
    CGMutablePathRef path = CGPathCreateMutable();
    /* How big is our screen? We want the X to cover the whole screen */
  
    CGContextSetFillColorWithColor(context, [UIColor brownColor].CGColor);
    CGContextSetLineWidth(context, 2);
    [[UIColor purpleColor] setStroke];

    CGContextBeginPath(context);
    
    //形状
    CGFloat mr = 5.0f;
    CGFloat radius = 10.0f;
    //从左上角开始画路径 将路径上当前画笔位置移动到 CGPoint 类型的参数指定的点。
    CGPathMoveToPoint(path, NULL, mr, mr + radius);
    //原点   半径    开始角度    结束角度    方向
    CGContextAddArc(context, mr + radius, mr + radius, radius, DEGREES_TO_RADIANS(-180), DEGREES_TO_RADIANS(-90), 0);//0为顺时针
    CGPathMoveToPoint(path, NULL, mr + radius, mr);//画弧之后，改变画笔终点
    //结束点
    CGPathAddLineToPoint(path, NULL, WIDTH(self) - mr - radius, mr);
    CGContextAddArc(context, WIDTH(self) - mr - radius, mr + radius, radius, DEGREES_TO_RADIANS(-90), DEGREES_TO_RADIANS(0), 0);//0为顺时针
    CGPathMoveToPoint(path, NULL, WIDTH(self) - mr, mr + radius);

    CGPathAddLineToPoint(path, NULL, WIDTH(self) - mr, HEIGHT(self) - mr - radius);
    CGContextAddArc(context, WIDTH(self) - mr - radius, HEIGHT(self) - mr - radius, radius, DEGREES_TO_RADIANS(0), DEGREES_TO_RADIANS(90), 0);//0为顺时针
    CGPathMoveToPoint(path, NULL, WIDTH(self) - mr - radius, HEIGHT(self) - mr);

//    CGPathAddLineToPoint(path, NULL, mr + radius, HEIGHT(self) - mr);
    
    CGFloat mmm = -5.0f;
    CGContextAddLineToPoint(context, WIDTH(self) / 2 + mr, HEIGHT(self) - mr);
    CGPathMoveToPoint(path, NULL, WIDTH(self) / 2 + mr, HEIGHT(self) - mr);

    
    CGContextAddLineToPoint(context, WIDTH(self) / 2, HEIGHT(self) - mr - mmm);
    CGPathMoveToPoint(path, NULL, WIDTH(self) / 2, HEIGHT(self) - mr - mmm);

    CGContextAddLineToPoint(context, WIDTH(self) / 2 - mr, HEIGHT(self) - mr);
    CGPathMoveToPoint(path, NULL, WIDTH(self) / 2 - mr, HEIGHT(self) - mr);

    CGContextAddLineToPoint(context, mr + radius, HEIGHT(self) - mr);
    CGPathMoveToPoint(path, NULL, mr + radius, HEIGHT(self) - mr);

    
    
    CGContextAddArc(context, mr + radius, HEIGHT(self) - mr - radius, radius, DEGREES_TO_RADIANS(90), DEGREES_TO_RADIANS(180), 0);//0为顺时针
    CGPathMoveToPoint(path, NULL, mr, HEIGHT(self) - mr - radius);
    CGPathAddLineToPoint(path, NULL, mr, mr + radius);
    
    CGContextClosePath(context); //封闭当前线路

    CGContextDrawPath(context, kCGPathStroke);

    CGPathRelease(path);

    
}

@end
