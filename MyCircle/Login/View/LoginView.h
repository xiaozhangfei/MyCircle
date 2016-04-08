//
//  LoginView.h
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFViewShaker.h"
#import "XFTextField.h"
@interface LoginView : UIView
{
    int _count;
}
@property (strong, nonatomic) UISegmentedControl *loginTypeSegment;


@property (strong, nonatomic) XFTextField *phoneTF;
@property (strong, nonatomic) XFTextField *authCodeTF;
@property (strong, nonatomic) UIButton *sendAuthCodeButton;
@property (strong, nonatomic) XFTextField *passwordTF;

@property (strong, nonatomic) UIButton *registerBtn;

@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIButton *cancelBtn;


@property (nonatomic, strong) AFViewShaker *viewShaker;

//震动一个
- (void)onShakeOneWithView:(UIView *)sender;
//震动全部
- (void)onShakeAllAction;
//震动完成后操作
- (void)onShakeAllWithBlockAction:(UIButton *)sender;

@end
