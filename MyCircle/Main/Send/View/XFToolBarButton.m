//
//  XFToolBarButton.m
//  MyCircle
//
//  Created by and on 16/3/18.
//  Copyright © 2016年 and. All rights reserved.
//

#import "XFToolBarButton.h"

@interface XFToolBarButton ()
@property (nonatomic, strong) NSString *title;

@property (nonatomic, copy) eventBlock buttonPressBlock;

@end

@implementation XFToolBarButton


+ (instancetype)buttonWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

- (id)initWithTitle:(NSString *)title {
    _title = title;
    return [self init];
}

- (id)init {
    CGSize sizeOfText = [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.f]}];
    
    if (self = [super initWithFrame:CGRectMake(0, 0, sizeOfText.width + 18.104, sizeOfText.height + 10.298)]) {
        self.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.0];
        
        self.layer.cornerRadius = 3.0f;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
        
        [self setTitle:self.title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithWhite:0.500 alpha:1.0] forState:UIControlStateNormal];
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
        self.titleLabel.textColor = [UIColor colorWithWhite:0.500 alpha:1.0];
    }
    return self;
}

+ (instancetype)buttonWithTitle:(NSString *)title andEvent:(eventBlock)event forControlEvents:(UIControlEvents)controlEvent {
    XFToolBarButton *newButton = [XFToolBarButton buttonWithTitle:title];
    [newButton addEvent:event forControlEvents:controlEvent];
    
    return newButton;
}

- (void)addEvent:(eventBlock)event forControlEvents:(UIControlEvents)controlEvent {
    self.buttonPressBlock = event;
    [self addTarget:self action:@selector(buttonPressed) forControlEvents:controlEvent];
}

- (void)buttonPressed {
    self.buttonPressBlock();
}
@end
