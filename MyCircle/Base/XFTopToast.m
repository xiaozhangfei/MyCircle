//
//  XFTopToast.m
//  MyCircle
//
//  Created by and on 15/12/18.
//  Copyright © 2015年 and. All rights reserved.
//

#import "XFTopToast.h"

@interface XFTopToast ()
{
    //    NSInteger offsetLeft;
    //    NSInteger offsetTop;
    NSTimer *_timer;
    
    UIView *_view;
    UILabel *_textLabel;
    UIImageView *_imageView;
    CGFloat _time;
}

@end

@implementation XFTopToast

//- (void)dealloc {
//    _textLabel = nil;
//    _imageView = nil;
//    _view = nil;
//}

+ (XFTopToast *)showXFTopViewWithText:(NSString *)text image:(UIImage *)image leftOffset:(CGFloat )leftOffset topOffset:(CGFloat )topOffset backColor:(UIColor *)color time:(CGFloat )time {
    XFTopToast *toast = [[XFTopToast alloc] initWithText:text image:image leftOffset:leftOffset topOffset:topOffset backColor:color time:time];
    return toast;
}

//文字和图片不能全为空
- (id)initWithText:(NSString *)text image:(UIImage *)image leftOffset:(CGFloat )leftOffset topOffset:(CGFloat )topOffset backColor:(UIColor *)color time:(CGFloat )time {
    if (self = [super init]) {
        CGSize windowSize = [UIScreen mainScreen].bounds.size;
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, 80)];
        _view.backgroundColor = color;
        //添加backView到keyWindow上
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_view];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.image = image;
        [_view addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.text = text;
        _textLabel.textColor = [UIColor whiteColor];
        [_textLabel sizeToFit];
        [_view addSubview:_textLabel];
        
        //
        
        CGFloat height = _view.frame.size.height - 2 * topOffset;
        if ((text == nil || text.length == 0) && (image != nil)) {//文字为空，图片居中
            _imageView.frame = CGRectMake(0, 0, height, height);
            _imageView.center = _view.center;
        }else if (image == nil && !(text == nil || text.length == 0)) {//图片为空，文字不为空
            _textLabel.frame = CGRectMake(leftOffset, topOffset, windowSize.width - 2 * leftOffset, height);
        }else if (image != nil && !(text == nil || text.length == 0)){//都不为空
            _imageView.frame = CGRectMake(leftOffset, topOffset, height, height);
            _textLabel.frame = CGRectMake(CGRectGetMaxX(_imageView.frame), topOffset, windowSize.width - CGRectGetMaxX(_imageView.frame) - leftOffset, height);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(hideToast) withObject:nil afterDelay:time];

        });
        //[_timer fire];
    }
    return self;
}

- (void)hideToast {
    [_timer invalidate];
    _timer = nil;
    _textLabel = nil;
    _imageView = nil;
    [_view removeFromSuperview];
    _view = nil;
}

@end
