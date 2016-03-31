//
//  LoginView.m
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import "LoginView.h"
#import <Masonry.h>
#import "UtilsMacro.h"
@interface LoginView ()<UITextFieldDelegate>

@end
@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imv = [[UIImageView alloc] initWithFrame:frame];
        //imv.image = [UIImage imageNamed:@"backimage.jpg"];
        imv.backgroundColor = HexColor(0x51B9c7);
        [self addSubview:imv];
        [self initView];
    }
    return self;
}

- (void)initView {
    
    _loginTypeSegment = [[UISegmentedControl alloc] initWithItems:@[LocalString(@"login_loginWithCode"),LocalString(@"login_loginWithPwd")]];
    [self addSubview:_loginTypeSegment];
    
    _phoneTF = [[XFTextField alloc] init];
    _phoneTF.placeholder = LocalString(@"login_phone");
    [self addSubview:_phoneTF];
    
    _authCodeTF = [[XFTextField alloc] init];
    _authCodeTF.placeholder = LocalString(@"login_authCode");
    _authCodeTF.borderStyle = UITextBorderStyleLine;
    [self addSubview:_authCodeTF];
    
    _sendAuthCodeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_sendAuthCodeButton setTitle:LocalString(@"login_sendAuthCode") forState:(UIControlStateNormal)];
    [self addSubview:_sendAuthCodeButton];
    
    _passwordTF = [[XFTextField alloc] init];
    _passwordTF.placeholder = LocalString(@"login_pwd");
    _passwordTF.borderStyle = UITextBorderStyleLine;
    [self addSubview:_passwordTF];
    
    _registerBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_registerBtn setTitle:LocalString(@"login_noID") forState:(UIControlStateNormal)];
    [self addSubview:_registerBtn];
    
    
    _loginBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_loginBtn setTitle:LocalString(@"login_login") forState:(UIControlStateNormal)];
    [self addSubview:_loginBtn];
    
    _cancelBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_cancelBtn setTitle:LocalString(@"login_cancel") forState:(UIControlStateNormal)];
    [self addSubview:_cancelBtn];
    
    //添加震动
    _viewShaker = [[AFViewShaker alloc] initWithViewsArray:@[_phoneTF,_authCodeTF,_passwordTF]];
    
    _loginTypeSegment.tintColor = [UIColor whiteColor];
    _loginTypeSegment.selectedSegmentIndex = 0;
    _loginTypeSegment.backgroundColor = HexColor(0x51B9c7);
    
    //键盘样式
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _authCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordTF.returnKeyType = UIReturnKeyDone;
    //字体颜色
    _phoneTF.textColor = [UIColor whiteColor];
    _authCodeTF.textColor = [UIColor whiteColor];
    _passwordTF.textColor = [UIColor whiteColor];
    //按钮样式
    _sendAuthCodeButton.layer.masksToBounds = YES;
    _sendAuthCodeButton.layer.cornerRadius = 20;
    _sendAuthCodeButton.layer.borderWidth = 1;
    [_sendAuthCodeButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _sendAuthCodeButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _registerBtn.layer.masksToBounds = YES;
    _registerBtn.layer.cornerRadius = 20;
    _registerBtn.layer.borderWidth = 1;
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _registerBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 20;
    _loginBtn.layer.borderWidth = 1;
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _loginBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.cornerRadius = 20;
    _cancelBtn.layer.borderWidth = 1;
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _cancelBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self initFrames];
}

- (void)initFrames {
    __weak typeof (self) weakSelf = self;
    
    [_loginTypeSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.mas_top).with.offset (60);
        make.width.offset (300);
        make.centerX.equalTo (weakSelf.mas_centerX).with.offset (0);
        make.height.offset (30);
    }];
    
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.loginTypeSegment.mas_top).with.offset (60);
        make.left.equalTo (weakSelf.mas_left).with.offset (40);
        make.right.equalTo (weakSelf.mas_right).with.offset (-40);
        make.height.offset (40);
    }];
    
    [_authCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo (weakSelf.phoneTF.mas_height).offset(0);
        make.width.equalTo (weakSelf.phoneTF.mas_width).offset (-150);
        make.top.equalTo (weakSelf.phoneTF.mas_bottom).with.offset (40);
        make.left.equalTo (weakSelf.mas_left).with.offset (40);
    }];
    
    [_sendAuthCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.authCodeTF.mas_top).with.offset (0);
        make.left.equalTo (weakSelf.authCodeTF.mas_right).with.offset (20);
        make.right.equalTo (weakSelf.phoneTF.mas_right).with.offset (0);
        make.height.equalTo (weakSelf.authCodeTF.mas_height).with.offset (0);
    }];
    
    [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo (weakSelf.phoneTF.mas_height).offset(0);
        make.width.equalTo (weakSelf.phoneTF.mas_width).offset (0);
        make.top.equalTo (weakSelf.authCodeTF.mas_bottom).with.offset (40);
        make.left.equalTo (weakSelf.mas_left).with.offset (40);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo (weakSelf.passwordTF.mas_height).offset(0);
        make.width.equalTo (weakSelf.passwordTF.mas_width).offset (0);
        make.top.equalTo (weakSelf.passwordTF.mas_bottom).with.offset (40);
        make.left.equalTo (weakSelf.mas_left).with.offset (40);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo (weakSelf.passwordTF.mas_height).offset(0);
        make.width.equalTo (weakSelf.passwordTF.mas_width).offset (0);
        make.bottom.equalTo (weakSelf.cancelBtn.mas_top).with.offset (-20);
        make.left.equalTo (weakSelf.mas_left).with.offset (40);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo (weakSelf.passwordTF.mas_height).offset(0);
        make.width.equalTo (weakSelf.passwordTF.mas_width).offset (0);
        make.bottom.equalTo (weakSelf.mas_bottom).with.offset (-20);
        make.left.equalTo (weakSelf.mas_left).with.offset (40);
    }];
}


#pragma -- InputText

- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor grayColor];
    textNameLabel.frame = frame;
    return textNameLabel;
}


#pragma -- shake
- (void)onShakeOneWithView:(UIView *)sender {
    [[[AFViewShaker alloc] initWithView:sender] shake];
}

- (void)onShakeAllAction {
    [self.viewShaker shake];
}

- (void)onShakeAllWithBlockAction:(UIButton *)sender {
    [self.viewShaker shakeWithDuration:0.6 completion:^{
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"请填写全部信息"
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }];
}

@end
