//
//  LoginViewController.m
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import "LoginViewController.h"

#import "AppDelegate.h"

#import "LoginView.h"

#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/SMSSDK+ExtexdMethods.h>

#import "AFManagerHandle.h"

#import "RegisterViewController.h"
#import <LJWKeyboardHandlerHeaders.h>
#import "PersonModel.h"
#import "MiscTool.h"

@interface LoginViewController ()

@property (strong, nonatomic) LoginView *lv;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalString(@"login_login");
    self.navigationController.navigationBarHidden = YES;
    self.lv = [[LoginView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:self.lv];
    
    [self.lv.sendAuthCodeButton addTarget:self action:@selector(sendAuthCodeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.lv.registerBtn addTarget:self action:@selector(registerBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.lv.loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.lv.cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.lv.loginTypeSegment addTarget:self action:@selector(loginTypeChangeAction:) forControlEvents:(UIControlEventValueChanged)];
    
    //初始化时设置密码框不能点击
    _lv.passwordTF.enabled = NO;
    _lv.passwordTF.boColor = [UIColor lightGrayColor];
    [_lv.passwordTF setNeedsDisplay];
    
    
    [self registerLJWKeyboardHandler];
}

- (void)loginTypeChangeAction:(UISegmentedControl *)sender {
    UIColor *ligthColor = [UIColor lightGrayColor];//不能点击时的颜色

    UIColor *normalColor = [UIColor whiteColor];//正常时的颜色
    
    if (sender.selectedSegmentIndex == 0) {
        _lv.authCodeTF.enabled = YES;
        _lv.sendAuthCodeButton.enabled = YES;
        
        _lv.authCodeTF.boColor = normalColor;
        [_lv.authCodeTF setNeedsDisplay];//调用drawRect方法
        _lv.sendAuthCodeButton.layer.borderColor = normalColor.CGColor;
        [_lv.sendAuthCodeButton setTitleColor:normalColor forState:(UIControlStateNormal)];
        
        _lv.passwordTF.boColor = ligthColor;
        [_lv.passwordTF setNeedsDisplay];
        
        _lv.passwordTF.enabled = NO;
    }else {
        _lv.authCodeTF.enabled = NO;
        _lv.sendAuthCodeButton.enabled = NO;
        
        _lv.authCodeTF.boColor = ligthColor;
        [_lv.authCodeTF setNeedsDisplay];
        _lv.sendAuthCodeButton.layer.borderColor = ligthColor.CGColor;
        [_lv.sendAuthCodeButton setTitleColor:ligthColor forState:(UIControlStateNormal)];
        
        _lv.passwordTF.boColor = normalColor;
        [_lv.passwordTF setNeedsDisplay];
        
        _lv.passwordTF.enabled = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)registerBtnAction:(UIButton *)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self pushVC:registerVC animated:YES];
}

- (void)cancelBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendAuthCodeButtonAction:(UIButton *)sender {
    if (![self checkAuthField]) {
        return;
    }
    NSLog(@"发送验证码");
    
    [SMSSDK getVerificationCodeByMethod:(SMSGetCodeMethodSMS) phoneNumber:self.lv.phoneTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            NSLog(@"验证码发送成功");
        } else {
            NSLog(@"错误吗：%zi,错误描述：%@",error.code, error.userInfo);
        }

    }];
}

- (BOOL)checkAuthField {
    
    if (ISEMPTY(self.lv.phoneTF.text) || self.lv.phoneTF.text.length != 11) {
        [self.lv onShakeOneWithView:self.lv.phoneTF];
        return false;
    }
    return true;
}

-(void)loginBtnAction:(UIButton *)sender
{
    if (![self checkTextFields]) {
        return;
    }

    __weak typeof (self) weakSelf = self;
    [weakSelf loginPostSever:sender];
    return;
    //先验证验证码是否发送成功，系统使用，无需服务器
    [SMSSDK commitVerificationCode:self.lv.authCodeTF.text phoneNumber:self.lv.phoneTF.text zone:@"86" result:^(NSError *error) {
        if (error) {
            NSLog(@"验证成功");
            [weakSelf loginPostSever:sender];
        } else {
            NSLog(@"验证失败");
            [weakSelf showToast:@"登录失败"];
        }
    }];

}
//返回true，全部符合条件
- (BOOL)checkTextFields {
    if ([self.lv.phoneTF.text isEqualToString:@""]) {
        [self.lv onShakeOneWithView:self.lv.phoneTF];
        return false;
    }
    
    if (_lv.loginTypeSegment.selectedSegmentIndex == 0) {
        if ([self.lv.authCodeTF.text isEqualToString:@""]) {
            [self.lv onShakeOneWithView:self.lv.authCodeTF];
            return false;
        }
    }else {
        if ([self.lv.passwordTF.text isEqualToString:@""]) {
            [self.lv onShakeOneWithView:self.lv.passwordTF];
            return false;
        }
    }
    return true;
}

- (void)loginPostSever:(UIButton *)button {
    __weak typeof (self) weakSelf = self;
    NSDictionary *dict = @{@"mobile":self.lv.phoneTF.text,
                           @"code":self.lv.authCodeTF.text,
                           @"zone":@"86"};
    NSString *url = [XFAPI loginWithAuthcode];//使用验证码登录
    
    //使用密码登录
    if (_lv.loginTypeSegment.selectedSegmentIndex == 1) {
        dict = @{@"mobile":self.lv.phoneTF.text,
                 @"password":[MiscTool encryptPwdForTrans:self.lv.passwordTF.text],
                 @"zone":@"86"};
        url = [XFAPI login];
    }
    
    [AFHTTPRequestOperationManager postWithURLString:url parameters:dict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
        if (![baseModel.code isEqual:@"200"]) {
            [weakSelf showToast:baseModel.s_description];
            return ;
        }
        PersonModel *pm = [[PersonModel alloc] init];
        [pm setValuesForKeysWithDictionary:responseDict];
        NSLog(@"pm = %@",responseDict);
        
        XFAppContext *context = [XFAppContext sharedContext];
        context.uid = pm.uid;
        context.birth = pm.birth;
        context.cdate = pm.cdate;
        context.udate = pm.udate;
        context.rctoken = pm.rctoken;
        context.interests = pm.intrests;
        context.intro = pm.intro;
        context.location = pm.location;
        context.nickname = pm.nickname;
        if (ISEMPTY(pm.portrait)) {
            pm.portrait = @"1234.jpg";
        }
        context.portrait = pm.portrait;
        context.sex = pm.sex;
        context.mobile = pm.mobile;
        context.token = pm.token;//修改本地token
        //不保存device , version
        [context save];
        
        //登录成功，修正HTTP请求头
        [[AFManagerHandle shareHandle] update];
        
        //成功，跳转
        [weakSelf didPresentControllerButtonTouchSuccess];
        
        //通知修改头像
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHPORTRAIT" object:nil userInfo:nil];
        
        //获取rctoken后，连接融云服务器
        [((AppDelegate *)[UIApplication sharedApplication].delegate) connectRC];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        NSLog(@"error = %@",error);
        [weakSelf didPresentControllerButtonTouchFail];
    }];
}

- (void)didPresentControllerButtonTouchSuccess {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPresentControllerButtonTouchFail {
    [self showToast:@"登录失败"];
}


@end
