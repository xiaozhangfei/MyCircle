//
//  PlayImgClickWebViewVC.h
//  DaDiJinRong
//
//  Created by and on 15/5/4.
//  Copyright (c) 2015年 and. All rights reserved.
//

#import "BaseViewController.h"

@interface XFWebViewVC : BaseViewController

@property (copy,   nonatomic) NSString *url;
/*
 * 是否隐藏navgationBar，默认显示
 * 若isHideNav = YES, 
 * 则webView frame.top = 20
 */
@property (assign, nonatomic) BOOL isHideNav;
//

/*
 * 是否显示分享按钮，默认显示使用浏览器打开、复制链接等
 * 若isShare = YES，则设置分享内容
 */
@property (assign, nonatomic) BOOL isShare;//右上角是否是分享
//分享内容
@property (copy,   nonatomic) NSString *shareUrl;
@property (copy,   nonatomic) NSString *shareText;
@property (strong, nonatomic) UIImage *shareImage;
@property (copy,   nonatomic) NSString *shareDesc;



@property (assign, nonatomic) BOOL isShowBack;//是否显示关闭按钮
@property (strong, nonatomic) UIColor *navBackColor;//nav背景色



@property (assign, nonatomic) BOOL isShowWxService;//微信服务

-(void)setTitleLabel:(NSString*)title;


@end
