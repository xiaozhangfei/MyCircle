//
//  TouchIDViewController.m
//  
//
//  Created by and on 15/11/5.
//
//

#import "TouchIDViewController.h"
#import "TouchIDView.h"

#import <LocalAuthentication/LocalAuthentication.h>

#import "LoginViewController.h"
#import "SFHFKeychainUtils.h"

@interface TouchIDViewController ()

@property (strong, nonatomic) TouchIDView *touchView;

@end

@implementation TouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _touchView = [[TouchIDView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_touchView];
    
    [_touchView.touchImv addTapCallBack:self sel:@selector(touchAction:)];
    
    [_touchView.loginToElseLabel addTapCallBack:self sel:@selector(touchAction:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf popTouchID];
    });
}

- (void)touchAction:(UIGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case 1301:
            [self popTouchID];
            break;
        case 1302:
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }
            break;
        default:
            break;
    }
}


- (void)popTouchID {
    LAContext *context=  [[LAContext alloc] init];
    NSError *error = nil;
    NSLog(@"pass = %@", [SFHFKeychainUtils getPasswordForUsername:@"哈哈" andServiceName:@"abc" error:nil]);
    
    
    //return;
    NSString *myLocalString = @"通过Home键验证已有手机指纹";
    __weak typeof (self) weakSelf = self;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:myLocalString reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"success");
                [weakSelf dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
            }else {
                NSLog(@"error = %@",error);
                if (error.code == kLAErrorUserFallback) {
                    NSLog(@"User tapped Enter Password");
                } else if (error.code == kLAErrorUserCancel) {
                    NSLog(@"User tapped Cancel");
                } else {
                    NSLog(@"Authenticated failed.");
                }
            }
        }];
    }else
    {
        //不支持指纹识别，LOG出错误详情
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
        //[self showPasswordAlert];
    }
}

- (void)dealloc {
}



@end
