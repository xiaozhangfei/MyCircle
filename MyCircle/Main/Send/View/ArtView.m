//
//  ArtView.m
//  MyCircle
//
//  Created by and on 16/3/18.
//  Copyright © 2016年 and. All rights reserved.
//

#import "ArtView.h"
#import "XFTextField.h"
#import <Masonry.h>
#import <RFKeyboardToolbar.h>
#import "ToolBarToastView.h"
#import "XFToolBarButton.h"
#import "XFKeyboardBar.h"

@interface ArtView ()
@property (strong, nonatomic) XFKeyboardBar *keyboardBar;
@end

@implementation ArtView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _titleField = [[XFTextField alloc] init];
    _titleField.boColor = [UIColor lightGrayColor];
    [self addSubview:_titleField];
    
    _textView = [[UITextView alloc] init];
    [self addSubview:_textView];
    
    _titleField.placeholder = @"标题";
    
    _textView.delegate = self;
    //_textView.inputAccessoryView = self.toolBar;
    
    _textView.inputAccessoryView = self.keyboardBar;
    [self initFrame];

}

- (void)initFrame {
    CGFloat margin = 10;
    __weak typeof (self) weakSelf = self;
    [_titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.mas_top).offset (0);
        make.left.equalTo (weakSelf.mas_left).offset (margin);
        make.right.equalTo (weakSelf.mas_right).offset (margin);
        make.height.offset (40);
    }];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.titleField.mas_bottom).offset (0);
        make.left.equalTo (weakSelf.titleField.mas_left).offset (0);
        make.right.equalTo (weakSelf.titleField.mas_right).offset (0);
        make.bottom.equalTo (weakSelf.mas_bottom).offset (0);
    }];
}

- (XFKeyboardBar *)keyboardBar {
    if (_keyboardBar == nil) {
        __weak typeof (self) weakSelf = self;
        XFToolBarButton *hideBtn = [XFToolBarButton buttonWithTitle:@"v"];
        [hideBtn addEvent:^{
            // Do anything in this block here
            [weakSelf.textView endEditing:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        
        XFToolBarButton *hBtn = [XFToolBarButton buttonWithTitle:@"#" andEvent:^{
            [weakSelf.textView insertText:@"\n# "];

        } forControlEvents:(UIControlEventTouchUpInside)];
    
        XFToolBarButton *yBtn = [XFToolBarButton buttonWithTitle:@"“" andEvent:^{
            [weakSelf.textView insertText:@"\n> "];
        } forControlEvents:(UIControlEventTouchUpInside)];
        
        XFToolBarButton *desBtn = [XFToolBarButton buttonWithTitle:@"---" andEvent:^{
            [weakSelf.textView insertText:@"\n--- \n"];
        } forControlEvents:(UIControlEventTouchUpInside)];
        
        XFToolBarButton *lBtn = [XFToolBarButton buttonWithTitle:@"*" andEvent:^{
            [weakSelf.textView insertText:@"\n* "];
        } forControlEvents:(UIControlEventTouchUpInside)];
        
        XFToolBarButton *zBtn = [XFToolBarButton buttonWithTitle:@"~" andEvent:^{
            [weakSelf.textView insertText:@" ~~~~ "];
            NSRange range = weakSelf.textView.selectedRange;
            range.location -= 3;
            _textView.selectedRange = range;
        } forControlEvents:(UIControlEventTouchUpInside)];
        
        XFToolBarButton *cBtn = [XFToolBarButton buttonWithTitle:@"code" andEvent:^{
            [weakSelf.textView insertText:@"\n```\n\n```\n"];
            NSRange range = weakSelf.textView.selectedRange;
            range.location -= 5;
            _textView.selectedRange = range;
        } forControlEvents:(UIControlEventTouchUpInside)];
        
        XFToolBarButton *bBtn = [XFToolBarButton buttonWithTitle:@"B" andEvent:^{
            [weakSelf.textView insertText:@" **** "];
            NSRange range = weakSelf.textView.selectedRange;
            range.location -= 3;
            _textView.selectedRange = range;
        } forControlEvents:(UIControlEventTouchUpInside)];
        
        XFToolBarButton *xBtn = [XFToolBarButton buttonWithTitle:@"/B" andEvent:^{
            [weakSelf.textView insertText:@" ** "];
            NSRange range = weakSelf.textView.selectedRange;
            range.location -= 2;
            _textView.selectedRange = range;
        } forControlEvents:(UIControlEventTouchUpInside)];
        
        
        XFToolBarButton *linkBtn = [XFToolBarButton buttonWithTitle:@"link" andEvent:^{
            //[weakSelf.textView insertText:@"\n--- \n"];
            [weakSelf.textView insertText:@" ![链接标题]() "];
            //NSLog(@"sel = %@",_textView.selectedRange);
            //_textView.selectedRange = range;
            NSRange range = weakSelf.textView.selectedRange;
            range.location -= 2;
            _textView.selectedRange = range;
        } forControlEvents:(UIControlEventTouchUpInside)];
        
        XFToolBarButton *toastBtn = [XFToolBarButton buttonWithTitle:@"image" andEvent:^{
            //[weakSelf.textView insertText:@"\n--- \n"];
            [weakSelf.textView insertText:@"\n ![图片标题][] \n"];
            //NSLog(@"sel = %@",_textView.selectedRange);
            //_textView.selectedRange = range;
            NSRange range = weakSelf.textView.selectedRange;
            range.location -= 3;
            _textView.selectedRange = range;
        } forControlEvents:(UIControlEventTouchUpInside)];
        
        NSArray *buttons = @[hideBtn, hBtn, yBtn, lBtn, zBtn, cBtn, bBtn, xBtn, desBtn, linkBtn, toastBtn];
        NSArray *buttonsWidth = @[@(50),@(50),@(50),@(50),@(50),@(50),@(50),@(50),@(50),@(50),@(50)];
        _keyboardBar = [XFKeyboardBar initWithButtons:buttons widths:buttonsWidth];

        //[XFToolBarButton toolbarWithButtons:@[hideBtn, hBtn, yBtn, desBtn, toastBtn]];
    }
    return _keyboardBar;

}

- (RFKeyboardToolbar *)toolBar {
    if (_toolBar == nil) {
        __weak typeof (self) weakSelf = self;
        RFToolbarButton *hideBtn = [RFToolbarButton buttonWithTitle:@"v"];
        [hideBtn addEventHandler:^{
            // Do anything in this block here
            [weakSelf.textView endEditing:YES];
        } forControlEvents:UIControlEventTouchUpInside];

        RFToolbarButton *hBtn = [RFToolbarButton buttonWithTitle:@"H" andEventHandler:^{
            [weakSelf.textView insertText:@"\n# "];
        } forControlEvents:(UIControlEventTouchUpInside)];
        
        RFToolbarButton *yBtn = [RFToolbarButton buttonWithTitle:@"“" andEventHandler:^{
            [weakSelf.textView insertText:@"\n> "];
        } forControlEvents:(UIControlEventTouchUpInside)];
        
        RFToolbarButton *desBtn = [RFToolbarButton buttonWithTitle:@"---" andEventHandler:^{
            [weakSelf.textView insertText:@"\n--- \n"];
        } forControlEvents:(UIControlEventTouchUpInside)];
        
        RFToolbarButton *toastBtn = [RFToolbarButton buttonWithTitle:@"显示Toast" andEventHandler:^{
            [weakSelf.textView insertText:@"\n![]() \n"];
           
            
        } forControlEvents:(UIControlEventTouchUpInside)];
        
        _toolBar = [RFKeyboardToolbar toolbarWithButtons:@[hideBtn, hBtn, yBtn, desBtn, toastBtn]];
    }
    return _toolBar;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    __weak typeof (self) weakSelf = self;
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.titleField.mas_bottom).offset (0);
        make.left.equalTo (weakSelf.titleField.mas_left).offset (0);
        make.right.equalTo (weakSelf.titleField.mas_right).offset (0);
        make.bottom.equalTo (weakSelf.mas_bottom).offset (260);
    }];
    [_textView needsUpdateConstraints];
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    __weak typeof (self) weakSelf = self;
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.titleField.mas_bottom).offset (0);
        make.left.equalTo (weakSelf.titleField.mas_left).offset (0);
        make.right.equalTo (weakSelf.titleField.mas_right).offset (0);
        make.bottom.equalTo (weakSelf.mas_bottom).offset (0);
    }];
    [_textView needsUpdateConstraints];
}


@end
