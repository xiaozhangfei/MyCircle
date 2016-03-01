//
//  SendViewController.m
//  MyCircle
//
//  Created by and on 15/11/1.
//  Copyright © 2015年 and. All rights reserved.
//

#import "SendViewController.h"
#import "WriteCircleController.h"

#import "CircleHotModel.h"
#import <masonry.h>

#import "FactoryMethod.h"
#import "AppDelegate.h"

#import <CoreGraphics/CoreGraphics.h>
#import "UIImage+ImageEffects.h"

#import <POP.h>
#import "BtnExt.h"

@interface SendViewController ()

@end

@implementation SendViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)initAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:@"kankan" preferredStyle:(UIAlertControllerStyleActionSheet)];
    __weak typeof (self) weakSelf = self;
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewController];
    }];
    UIAlertAction *defult = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf pushDetail];
    }];
    // 添加按钮
    [alert addAction:cancel];
    [alert addAction:defult];
    //显示
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发送";
    [self initView];
}

- (void)initView {
    [self initBackView];
    [self initCancelButton];
    [self initPopButtons];
}

- (void)initBackView {
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 80)];
    imv.image = [UIImage imageNamed:@"Default_splashscreen_slogan"];
    [self.view addSubview:imv];
    imv.center = CGPointMake(self.view.width / 2, 64 + 80);
}

- (void)initCancelButton {
    //添加取消按钮背景
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, self.view.frame.size.width, 49)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [view addTapCallBack:self sel:@selector(cancelAction:)];

    CGFloat hWidth = 23;
    CGFloat cX = view.frame.size.width / 2;
    CGFloat cY = view.frame.size.height / 2;
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(cX - hWidth, cY - hWidth, 2 * hWidth, 2 * hWidth)];
    imv.image = [UIImage imageNamed:@"cancel"];
    imv.tag = 1200;
    [view addSubview:imv];
}

- (void)initPopButtons {
    NSArray *titleArray = @[@"文字", @"相册", @"长微博", @"签到", @"点评", @"更多"];
    NSArray *imageArray = @[@"tabbar_compose_idea",@"tabbar_compose_photo",@"tabbar_compose_headlines",@"tabbar_compose_lbs",@"tabbar_compose_review",@"tabbar_compose_more"];
    CGFloat w = SCREEN_CURRETWIDTH(170);

    for (int i = 0; i < 6; i ++) {
        BtnExt *btn = [[BtnExt alloc] initWithFrame:CGRectMake((self.view.width - w) / 2, self.view.height - 3 * w, w, w)];
        [btn setImage:[UIImage imageNamed:imageArray[i]] forState:(UIControlStateNormal)];
        [btn setTitle:titleArray[i] forState:(UIControlStateNormal)];
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
        btn.btnType = XFBtnTypeBottom;
        btn.imageSize = CGSizeMake(SCREEN_CURRETWIDTH(120), SCREEN_CURRETWIDTH(120));
        btn.imageToBorderOffset = SCREEN_CURRETWIDTH(0);
        btn.tag = 1210 + i;
        [btn addTarget:self action:@selector(popImvAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:btn];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf execAnimationsWhenAppear];
    });

}
//视图出现后执行
- (void)execAnimationsWhenAppear {

    CGFloat x = SCREEN_CURRETWIDTH(50);//x向间隔
    CGFloat y = SCREEN_CURRETWIDTH(80);//y向间隔
    CGFloat w = SCREEN_CURRETWIDTH(170);//宽
    //x 50 + w
    CGPoint point = CGPointMake(self.view.width / 2 - x - w, self.view.height - 2 * w - 2 * y - 40);
    for (int i = 0; i < 2; i ++) {
        for (int j = 0; j < 3; j ++) {
            BtnExt *btn = (BtnExt *)[self.view viewWithTag:1210 + i * 3 + j];
            
            POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
            anim.springBounciness = 16;
            anim.springSpeed = 6;
            anim.toValue = [NSValue valueWithCGPoint:point];
            [btn pop_addAnimation:anim forKey:[NSString stringWithFormat:@"po%d",1210 + i * 3 + j]];

            point.x += (x + w);//x 右移
        }
        point.x = self.view.width / 2 - x - w;//x初始
        point.y += (w + y);//y 下移
    }
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
       [weakSelf.view viewWithTag:1200].transform = CGAffineTransformMakeRotation(M_PI / 4);
    }];
    
}

- (void)cancelAction:(UIGestureRecognizer *)sender {
    [self dismissViewController];
}

- (void)popImvAction:(UIButton *)sender {
    [self showToast:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    
//    if(ISEMPTY([XFAppContext sharedContext].userid)) {
//        [self showToast:@"尚未登录"];
//        return;
//    }
    
    if (sender.tag == 1210) {
        WriteCircleController *vc = [[WriteCircleController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)pushDetail {
    WriteCircleController *detail = [[WriteCircleController alloc] init];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark --dismiss
- (void)dismissViewController {
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionFade];
    [animation setSubtype:kCATransitionFromTop];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.view layer] addAnimation:animation forKey:@"sendDismiss"];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
