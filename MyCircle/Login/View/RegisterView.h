//
//  RegisterView.h
//  MyCircle
//
//  Created by and on 15/11/2.
//  Copyright © 2015年 and. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFTextField.h"
#import "AFViewShaker.h"

@interface RegisterView : UIView

@property (strong, nonatomic) XFTextField *phoneTF;
@property (strong, nonatomic) XFTextField *authCodeTF;
@property (strong, nonatomic) UIButton *sendAuthCodeButton;
@property (strong, nonatomic) XFTextField *passwordTF;

@property (strong, nonatomic) XFTextField *nicknameTF;
@property (strong, nonatomic) UIButton *testNickBtn;

@property (strong, nonatomic) UIButton *registerBtn;
@property (strong, nonatomic) UIButton *cancelBtn;

@property (nonatomic, strong) AFViewShaker *viewShaker;

//震动一个
- (void)onShakeOneWithView:(UIView *)sender;
//震动全部
- (void)onShakeAllAction;
//震动完成后操作
- (void)onShakeAllWithBlockAction:(UIButton *)sender;


@end

