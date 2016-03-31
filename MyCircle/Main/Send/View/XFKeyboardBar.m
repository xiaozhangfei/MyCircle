//
//  XFKeyboardBar.m
//  MyCircle
//
//  Created by and on 16/3/18.
//  Copyright © 2016年 and. All rights reserved.
//

#import "XFKeyboardBar.h"
@interface XFKeyboardBar ()
{
    UIScrollView *_scrollView;
}

@property (nonatomic,strong) UIView *toolbarView;

@property (nonatomic,strong) CALayer *topBorder;


@end

@implementation XFKeyboardBar
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        //[self initView];
//        
//        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        [self addSubview:[self inputAccessoryView]];
//    }
//    return self;
//}

+ (instancetype)initWithButtons:(NSArray *)buttons widths:(NSArray *)widths {
    return [[XFKeyboardBar alloc] initWithButtons:buttons widths:widths];

}

- (id)initWithButtons:(NSArray *)buttons widths:(NSArray *)widths{
    self = [super initWithFrame:CGRectMake(0, 0, App_Frame_Width, 40)];
    if (self) {
        _buttons = [buttons copy];
        _buttonsWidth = [widths copy];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:[self inputAccessoryView]];
    }
    return self;
}

- (UIView *)inputAccessoryView {
    //[self drawBackView];
    self.backgroundColor = [UIColor whiteColor];
    
    _toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 40)];
    _toolbarView.backgroundColor = [UIColor colorWithWhite:0.973 alpha:1.0];
    _toolbarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    _topBorder = [CALayer layer];
    _topBorder.frame = CGRectMake(0.0f, 0.0f, App_Frame_Width, 0.5f);
    _topBorder.backgroundColor = [UIColor colorWithWhite:0.678 alpha:1.0].CGColor;
    
    [_toolbarView.layer addSublayer:_topBorder];
    [_toolbarView addSubview:[self fakeToolbar]];
    

    return _toolbarView;
    
}

- (void)layoutSubviews {
    
    CGRect frame = _toolbarView.bounds;
    frame.size.height = 0.5f;
    
    _topBorder.frame = frame;
}


- (UIScrollView *)fakeToolbar {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 40)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _scrollView.showsHorizontalScrollIndicator = NO;
    //_scrollView.contentInset = UIEdgeInsetsMake(6.0f, 0.0f, 8.0f, 6.0f);
    
    [self addButtons];
    
    return _scrollView;
}
- (void)addButtons {
    for (UIButton *btn in _buttons) {
        [_scrollView addSubview:btn];
    }
    
    CGFloat totalWith = 0;
    for (NSNumber *width in _buttonsWidth) {
        totalWith += [width floatValue];
    }
    CGFloat mr = 5.0f;
    CGFloat radius = 10.0f;
    if (totalWith > App_Frame_Width - mr * 2) {
        CGFloat margin = 10;
        _scrollView.frame = CGRectMake(0, 0, App_Frame_Width, 40);
        CGRect rect = CGRectMake(mr, mr, 0, 40 - 2 * mr);
        for (int i = 0; i < _buttons.count; i ++) {
            UIButton *btn = _buttons[i];
            rect.size.width = [_buttonsWidth[i] floatValue];
            btn.frame = rect;
            rect.origin.x += rect.size.width + margin;
        }
        _scrollView.contentSize = CGSizeMake(totalWith + _buttons.count * margin + 2 * mr, _scrollView.frame.size.height);
    }else {
        CGFloat des = (App_Frame_Width - totalWith - 2 * mr) / (_buttons.count - 1);
        _scrollView.frame = CGRectMake(0, 0, App_Frame_Width, 40);
        CGRect rect = CGRectMake(mr, mr, 0, 40 - 2 * mr);
        for (int i = 0; i < _buttons.count; i ++) {
            UIButton *btn = _buttons[i];
            rect.size.width = [_buttonsWidth[i] floatValue];
            btn.frame = rect;
            rect.origin.x += (rect.size.width + des);
        }
    }
}

@end
