//
//  HomeIconTitleView.m
//  MyCircle
//
//  Created by and on 15/12/16.
//  Copyright © 2015年 and. All rights reserved.
//

#import "HomeIconTitleView.h"

@implementation HomeIconTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_imageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.numberOfLines = 2;
    _label.font = [UIFont systemFontOfSize:13.0f];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
    
    //_imageView.backgroundColor = [UIColor whiteColor];
    _label.text = @"主屏幕";
    
}
/*
_________
|       |
| image |
|_______|
| label |
|_______|
 
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    _label.frame = CGRectMake(0, CGRectGetMaxY(_imageView.frame), _imageView.frame.size.width, self.frame.size.height - self.frame.size.width);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
