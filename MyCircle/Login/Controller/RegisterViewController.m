//
//  RegisterViewController.m
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import "RegisterViewController.h"

#import "RegisterView.h"

#import "PersonModel.h"
#import "AFManagerHandle.h"

#import <SMS_SDK/SMSSDK.h>
#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
#import <SMS_SDK/SMSSDK+ExtexdMethods.h>

#import "MiscTool.h"

#import <LJWKeyboardHandlerHeaders.h>

#import "AppDelegate.h"

@interface RegisterViewController ()

@property (strong, nonatomic) RegisterView *rv;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    self.rv = [[RegisterView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.rv];
    
    [self.rv.sendAuthCodeButton addTarget:self action:@selector(sendAuthCodeButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    //设置对应的导航条的返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction1:)];
    [self.rv.testNickBtn addTarget:self action:@selector(testNickBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.rv.registerBtn addTarget:self action:@selector(registerBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.rv.cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];

    [self registerLJWKeyboardHandler];
}

- (void)leftBarButtonAction1:(id )sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelBtnAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - 验证昵称
- (void)testNickBtnAction:(id )sender {
    if (![self checkNickField]) {
        return;
    }
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager getWithURLString:[XFAPI checkNickNameWithNick:self.rv.nicknameTF.text] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
        if (![baseModel.code isEqual:@"200"]) {
            [weakSelf showToast:baseModel.s_description];
            return ;
        }
        if ([responseDict[@"exist"] isEqualToString:@"1"]) {
            [weakSelf showToast:@"昵称已存在"];
        }else {
            [weakSelf showToast:@"昵称可用"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        [weakSelf showToast:@"网络错误"];
    }];
}

- (BOOL)checkNickField {
    if (ISEMPTY(self.rv.nicknameTF.text)) {
        [self.rv onShakeOneWithView:self.rv.nicknameTF];
        return false;
    }
    return true;
}

//只获取验证码，验证验证码是否正确由服务器来进行
- (void)sendAuthCodeButtonAction:(UIButton *)sender {
    if (![self checkAuthField]) {
        return;
    }
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.rv.phoneTF.text
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error) {
                                     if (!error) {
                                         NSLog(@"验证码发送成功");
                                     } else {
                                         NSLog(@"错误吗：%zi,错误描述：%@",error.code, error.userInfo);
                                     }
                                 }];
}

- (BOOL)checkAuthField {
    if (ISEMPTY(self.rv.phoneTF.text) || self.rv.phoneTF.text.length != 11) {
        [self.rv onShakeOneWithView:self.rv.phoneTF];
        return false;
    }
    return true;
}


-(void)registerBtnAction:(UIButton *)sender
{
    if (![self checkTextFields]) {
        return;
    }
    [self registerPostSever:sender];
}

//返回true，全部符合条件
- (BOOL)checkTextFields {
    if (ISEMPTY(self.rv.phoneTF.text)) {
        [self.rv onShakeOneWithView:self.rv.phoneTF];
        return false;
    }
    if (ISEMPTY(self.rv.authCodeTF.text)) {
        [self.rv onShakeOneWithView:self.rv.authCodeTF];
        return false;
    }
    if (ISEMPTY(self.rv.passwordTF.text)) {
        [self.rv onShakeOneWithView:self.rv.passwordTF];
        return false;
    }
    if (ISEMPTY(self.rv.nicknameTF.text)) {
        [self.rv onShakeOneWithView:self.rv.nicknameTF];
        return false;
    }
    return true;
}

#pragma mark -- 注册
- (void)registerPostSever:(UIButton *)sender {
    __weak typeof (self) weakSelf = self;
    NSDictionary *dict = @{
                           @"mobile":self.rv.phoneTF.text,
                           @"password":[MiscTool md5:self.rv.passwordTF.text],
                           @"nickname":self.rv.nicknameTF.text,
                           @"zone":@"86",
                           @"code":self.rv.authCodeTF.text
                           };
    [AFHTTPRequestOperationManager postWithURLString:[XFAPI userRegister] parameters:dict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
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
        context.token = pm.token;        //不保存device , version
        [context save];
        
        //登录成功，修正HTTP请求头
        [[AFManagerHandle shareHandle] update];
        
        //通知修改头像
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHPORTRAIT" object:nil userInfo:nil];
        
        //获取rctoken后，连接融云服务器
        [((AppDelegate *)[UIApplication sharedApplication].delegate) connectRC];
        
        //成功，跳转
        [weakSelf showToast:@"注册成功"];
        [weakSelf didPresentControllerButtonTouchSuccess];
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
    [self showToast:@"注册失败"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
