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

@interface LoginViewController ()

@property (strong, nonatomic) LoginView *lv;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.lv = [[LoginView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:self.lv];
    
    [self.lv.sendAuthCodeButton addTarget:self action:@selector(sendAuthCodeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.lv.registerBtn addTarget:self action:@selector(registerBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.lv.loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.lv.cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];

    [self registerLJWKeyboardHandler];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)registerBtnAction:(UIButton *)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
    //重写navigationBar按钮方法时，开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)cancelBtnAction:(UIButton *)sender {
    
//    // 1.根据网址初始化OC字符串对象
//    NSString *urlStr = [NSString stringWithFormat:@"%@", @"http://zxfserver.sinaapp.com/home/account/logincode"];
//    // 2.创建NSURL对象
//    NSURL *url = [NSURL URLWithString:urlStr];
//    // 3.创建请求
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    // 4.创建参数字符串对象
//    NSString *parmStr = @"mobile=12345&code=123&zone=86";
//    // 5.将字符串转为NSData对象
//    NSData *pramData = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
//    // 6.设置请求体
//    [request setHTTPBody:pramData];
//    // 7.设置请求方式
//    [request setHTTPMethod:@"POST"];
//    
//
//    // 创建同步链接
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSDictionary *di = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//    NSLog(@"ressss = %@",di);
//    
//    return;

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
    if ([self.lv.authCodeTF.text isEqualToString:@""]) {
        [self.lv onShakeOneWithView:self.lv.authCodeTF];
        return false;
    }
    if ([self.lv.passwordTF.text isEqualToString:@""]) {
        [self.lv onShakeOneWithView:self.lv.passwordTF];
        return false;
    }
    return true;
}

- (void)loginPostSever:(UIButton *)button {
    __weak typeof (self) weakSelf = self;
    NSDictionary *dict = @{@"mobile":self.lv.phoneTF.text,
                           @"code":self.lv.authCodeTF.text,
                           @"zone":@"86"};
    
    
    [AFHTTPRequestOperationManager postWithURLString:[XFAPI loginWithAuthcode] parameters:dict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
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
        context.token = pm.token;
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
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didPresentControllerButtonTouchFail {
    [self showToast:@"登录失败"];
}


@end
