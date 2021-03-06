//
//  RegisterView.m
//  MyCircle
//
//  Created by and on 15/11/2.
//  Copyright © 2015年 and. All rights reserved.
//

#import "RegisterView.h"
#import <Masonry.h>
#import "UtilsMacro.h"

#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/SMSSDK+ExtexdMethods.h>

@implementation RegisterView

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
    
    _phoneTF = [[XFTextField alloc] init];
    _phoneTF.placeholder = LocalString(@"login_phone");
    [self addSubview:_phoneTF];
    
    _authCodeTF = [[XFTextField alloc] init];
    _authCodeTF.placeholder = LocalString(@"login_authCode");
    [self addSubview:_authCodeTF];
    
    _sendAuthCodeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_sendAuthCodeButton setTitle:LocalString(@"login_sendAuthCode") forState:(UIControlStateNormal)];
    [self addSubview:_sendAuthCodeButton];
    [_sendAuthCodeButton addTarget:self action:@selector(sendAuthCodeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _passwordTF = [[XFTextField alloc] init];
    _passwordTF.placeholder = LocalString(@"login_pwd");
    [self addSubview:_passwordTF];
    
    _nicknameTF = [[XFTextField alloc] init];
    _nicknameTF.placeholder = LocalString(@"login_nick");
    [self addSubview:_nicknameTF];
    
    _testNickBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_testNickBtn setTitle:LocalString(@"login_verifyNick") forState:(UIControlStateNormal)];
    [self addSubview:_testNickBtn];
    
    _registerBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_registerBtn setTitle:LocalString(@"login_register") forState:(UIControlStateNormal)];
    [self addSubview:_registerBtn];
    
    _cancelBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_cancelBtn setTitle:LocalString(@"login_cancel") forState:(UIControlStateNormal)];
    [self addSubview:_cancelBtn];
    
    //添加震动
    _viewShaker = [[AFViewShaker alloc] initWithViewsArray:@[_phoneTF,_authCodeTF,_passwordTF,_nicknameTF]];

    
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _authCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    
    _phoneTF.textColor = [UIColor whiteColor];
    _authCodeTF.textColor = [UIColor whiteColor];
    _passwordTF.textColor = [UIColor whiteColor];
    _nicknameTF.textColor = [UIColor whiteColor];
    
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
    
    _testNickBtn.layer.masksToBounds = YES;
    _testNickBtn.layer.cornerRadius = 20;
    _testNickBtn.layer.borderWidth = 1;
    [_testNickBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _testNickBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.cornerRadius = 20;
    _cancelBtn.layer.borderWidth = 1;
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _cancelBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self initFrames];

}

- (void)initFrames {
    __weak typeof (self) weakSelf = self;
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.mas_top).with.offset (140);
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
    
    [_nicknameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo (weakSelf.passwordTF.mas_height).offset(0);
        make.width.equalTo (weakSelf.passwordTF.mas_width).offset (-150);
        make.top.equalTo (weakSelf.passwordTF.mas_bottom).with.offset (40);
        make.left.equalTo (weakSelf.mas_left).with.offset (40);
    }];
    
    [_testNickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.nicknameTF.mas_top).with.offset (0);
        make.left.equalTo (weakSelf.nicknameTF.mas_right).with.offset (20);
        make.right.equalTo (weakSelf.passwordTF.mas_right).with.offset (0);
        make.height.equalTo (weakSelf.nicknameTF.mas_height).with.offset (0);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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

//只获取验证码，验证验证码是否正确由服务器来进行
- (void)sendAuthCodeButtonAction:(UIButton *)sender {
    if ([_phoneTF.text isEqualToString:@""]) {
        [self onShakeOneWithView:_phoneTF];
        return;
    }
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneTF.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error) {
                                     if (!error) {
                                         NSLog(@"验证码发送成功");
                                         [self uptimeAction];

                                     } else {
                                         NSLog(@"错误吗：%zi,错误描述：%@",error.code, error.userInfo);
                                     }
                                 }];
}

- (void)uptimeAction {
    _count = 60;
    [_sendAuthCodeButton setTitle:[NSString stringWithFormat:@"%ds",_count] forState:(UIControlStateNormal)];
    _sendAuthCodeButton.enabled = NO;
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerCount:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
}
- (void)timerCount:(NSTimer *)sender {
    if (_count != 0) {
        _count --;
        [_sendAuthCodeButton setTitle:[NSString stringWithFormat:@"%ds",_count] forState:(UIControlStateNormal)];
    }else {
        [sender invalidate];
        [_sendAuthCodeButton setTitle:LocalString(@"login_sendAuthCode") forState:(UIControlStateNormal)];
        _sendAuthCodeButton.enabled = YES;
    }
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
                                    message:LocalString(@"alert_fill")
                                   delegate:self
                          cancelButtonTitle:LocalString(@"alert_ok")
                          otherButtonTitles:nil] show];
    }];
}


@end
