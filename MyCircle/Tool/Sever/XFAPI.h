//
//  XFAPI.h
//  Chuangdou
//
//  Created by and on 15/6/28.
//  Copyright (c) 2015年 and. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface XFAPI : NSObject


#pragma mark -
#pragma mark - base
+ (NSString *)baseUrl;
+ (NSString *)baseImageUrl;
+ (NSString *)baseVideoUrl;
+ (NSString *)image_url:(NSString *)url;
+ (NSString *)video_url:(NSString *)url;
#pragma mark -
#pragma mark - account
#pragma mark -- 注册用户
+ (NSString *)userRegister;
#pragma mark -- 使用手机号，密码登陆
+ (NSString *)login;
#pragma mark -- 使用手机验证码登陆
+ (NSString *)loginWithAuthcode;
#pragma mark -- 检查手机号
+ (NSString *)checkPhoneNum;
#pragma mark -- 检查昵称是否可用
+ (NSString *)checkNickNameWithNick:(NSString *)nick;
#pragma mark -- 修改密码
+ (NSString *)uppwd;
#pragma mark -- 获取个人信息
+ (NSString *)getPersonInfo:(NSString *)pid;
//修改备注
+ (NSString *)upmarkname;
//删除好友
+ (NSString *)deleteFriend;

#pragma mark -- 融云
+ (NSString *)getrc;
//获取朋友信息
+ (NSString *)getFrinds;

#pragma mark -
#pragma mark - circle
#pragma mark -- 创建圈子作品
+ (NSString *)createCircle;
#pragma mark -- hot circle
+ (NSString *)getHotsWithPages:(NSInteger)page sort:(NSString *)sort;
#pragma mark -- circle 详情
+ (NSString *)getCircleDetailWithCid:(NSString *)cid;

#pragma mark -- 图片上传，获取token
+ (NSString *)getUpTokenForPhotoWithType:(NSString *)type;





#pragma mark - ME



#pragma mark - 图片上传
+ (NSString *)upImageToCircle;

#pragma mark - 图片上传
+ (NSString *)upVideoToCircle;

#pragma mark - 广告
+ (NSString *)getAdContent;


#pragma mark - JS
+ (NSString *)upjscode;

//rsa加密版js
+ (NSString *)jscode;

#pragma mark -- test rsa
+ (NSString *)rsa;

@end

