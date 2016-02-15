//
//  UIView+Ext.m
//  Here
//
//  Created by liumadu on 15-1-5.
//  Copyright (c) 2015年 lmd. All rights reserved.
//

#import "UIView+Ext.h"
#import "UtilsMacro.h"

@implementation UIView (Ext)

- (BOOL)visible{
    return !self.hidden;
}

- (void)setVisible:(BOOL)visible{
    self.hidden = !visible;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)screenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}

- (CGFloat)screenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}

- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}

- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}
/*
 - (CGFloat)orientationWidth {
 return UIInterfaceOrientationIsLandscape(TTInterfaceOrientation())
 ? self.height : self.width;
 }
 
 - (CGFloat)orientationHeight {
 return UIInterfaceOrientationIsLandscape(TTInterfaceOrientation())
 ? self.width : self.height;
 }
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}

- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
    } else {
        return nil;
    }
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)addSubviews:(NSArray *)views
{
    for (UIView* v in views) {
        [self addSubview:v];
    }
}

- (void)removeAllRecognizers
{
  for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
    [self removeGestureRecognizer:recognizer];
  }
}

- (void)addTapCallBack:(id)target sel:(SEL)selector
{
  self.userInteractionEnabled = YES;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
  [self addGestureRecognizer:tap];
}

//长按手势
- (void)addlongCallBack:(id)target sel:(SEL)selector
{
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:tap];
}
//拖拽手势
- (void)addpanCallBack:(id)target sel:(SEL)selector
{
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:selector];
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:pan];
}



+ (UIView *)returnSplitLineViewWithFrame:(CGRect )frame
{
  UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:frame];
  //[self.view addSubview:imageView1];
  //imageView1.backgroundColor = [UIColor purpleColor];
  
  UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
  [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
  CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
  
  CGFloat lengths[] = {2,2};
  CGContextRef line = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(line, UIColorFromRGB(215, 215, 215).CGColor);
  
  CGContextSetLineDash(line, 0, lengths, 1);  //画虚线
  CGContextMoveToPoint(line, 0.0, 1.0);    //开始画线
  CGContextAddLineToPoint(line, frame.size.width, 1.0);
  CGContextStrokePath(line);
  
  imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
  return imageView1;
}

+ (UIView *)returnSplitLineViewWithFrame:(CGRect )frame WithColor:(UIColor *)color
{
  UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:frame];
  //[self.view addSubview:imageView1];
  //imageView1.backgroundColor = [UIColor purpleColor];
  
  UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
  [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
  CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
  
  CGFloat lengths[] = {2,2};
  CGContextRef line = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(line, color.CGColor);
  
  CGContextSetLineDash(line, 0, lengths, 1);  //画虚线
  CGContextMoveToPoint(line, 0.0, 1.0);    //开始画线
  CGContextAddLineToPoint(line, frame.size.width, 1.0);
  CGContextStrokePath(line);
  
  imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
  return imageView1;
}

#pragma mark -- 获取一张500kb左右的图片
+ (NSData *)imageToQualityWithImage:(UIImage *)image KB:(NSInteger )kb {
    CGFloat scale = 1.0f;
    CGFloat minScale = 0.1f;
    NSData *data = UIImageJPEGRepresentation(image, scale);
    while (data.length > kb * 1024 * 8 && scale > minScale) {
        scale = scale - 0.1;
        data = UIImageJPEGRepresentation(image, scale);
    }
    return data;
}

@end
