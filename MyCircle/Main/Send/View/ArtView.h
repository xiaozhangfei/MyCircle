//
//  ArtView.h
//  MyCircle
//
//  Created by and on 16/3/18.
//  Copyright © 2016年 and. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XFTextField;
@class RFKeyboardToolbar;
@class ToolBarToastView;
@interface ArtView : UIView <UITextViewDelegate>

@property (strong, nonatomic) XFTextField *titleField;

@property (strong, nonatomic) UITextView *textView;

@property (strong, nonatomic) RFKeyboardToolbar *toolBar;

@property (strong, nonatomic) ToolBarToastView *toast;

@end
