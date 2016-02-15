//
//  XFAppContext.h
//  SaiKu
//
//  Created by Jiangxing on 15/3/2.
//  Copyright (c) 2015年 com.saiku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XFAppContext : NSObject

// 是否运行过导航页面
@property (nonatomic, copy) NSString *guideRun;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *rctoken;
@property (nonatomic, copy) NSString *nickname; //用户名
@property (nonatomic, copy) NSString *sex; //用户性别
@property (nonatomic, copy) NSString *birth; //用户生日
@property (nonatomic, copy) NSString *location;//用户地址
@property (nonatomic, copy) NSString *portrait;//头像地址
@property (nonatomic, copy) NSString *cdate;//创建用户日期
@property (nonatomic, copy) NSString *udate;//更新资料日期
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *intro; //自我介绍
@property (nonatomic, copy) NSString *interests; //兴趣字符串
@property (nonatomic, copy) NSString *backgroundUrl;

//若是打开app进入登录界面，则为NO
@property (nonatomic, assign) BOOL isFromSetting;//来自设置中的忘记密码，非正常


+ (instancetype)sharedContext;
- (void)save;
- (void)clear;

@end
