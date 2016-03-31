//
//  XFAPI.m
//  Chuangdou
//
//  Created by and on 15/6/28.
//  Copyright (c) 2015年 and. All rights reserved.
//

#import "XFAPI.h"

//#define PrBaseU @"http://www.u22t.com:8080/"
//#define DeBaseU @"http://localhost/"
@implementation XFAPI : NSObject

static NSString * const baseURL = @"http://zxfserver.sinaapp.com/home/";
static NSString * const baseImageURL = @"http://7xo6u7.com1.z0.glb.clouddn.com/";
static NSString * const baseVideoURL = @"http://zxfserver.sinaapp.com/Public/video/";

#pragma mark -
#pragma mark - base
+ (NSString *)baseUrl {
    return baseURL;
}
+ (NSString *)baseImageUrl {//图片baseURL
    return baseImageURL;
}
+ (NSString *)baseVideoUrl {//视频baseURL
    return baseVideoURL;
}
+ (NSString *)image_url:(NSString *)url {//图片链接
    return [NSString stringWithFormat:@"%@%@",baseImageURL,url];
}
+ (NSString *)video_url:(NSString *)url {//视频地址
    return [NSString stringWithFormat:@"%@%@",baseVideoURL,url];
}


#pragma mark -
#pragma mark -- 广告
+ (NSString *)getAdContent {
    return [NSString stringWithFormat:@"%@index/adcon",baseURL];
}

#pragma mark -
#pragma mark - account
#pragma mark -- 注册用户
+ (NSString *)userRegister {//注册
    return [NSString stringWithFormat:@"%@account/register",baseURL];
}
#pragma mark -- 使用手机号，密码登陆
+ (NSString *)login {//登录
    return [NSString stringWithFormat:@"%@account/login",baseURL];
}
#pragma mark -- 使用手机验证码登陆
+ (NSString *)loginWithAuthcode {//用验证码登录
    return [NSString stringWithFormat:@"%@account/logincode",baseURL];
}
#pragma mark -- 检查手机号
+ (NSString *)checkPhoneNum {
    return [NSString stringWithFormat:@"%@account/testMobile",baseURL];
}
#pragma mark -- 检查昵称是否可用
+ (NSString *)checkNickNameWithNick:(NSString *)nick {//昵称是否可使用
    return [NSString stringWithFormat:@"%@account/testnick/nick/%@",baseURL,nick];
}
#pragma mark -- 修改密码
+ (NSString *)uppwd {
    return [NSString stringWithFormat:@"%@account/uppwd",baseURL];
}
#pragma mark -- 获取个人信息
+ (NSString *)getPersonInfo:(NSString *)pid {
    return [NSString stringWithFormat:@"%@account/person/pid/%@",baseURL,pid];
}
//修改备注
+ (NSString *)upmarkname {
    return [NSString stringWithFormat:@"%@account/upmarkname",baseURL];
}
//删除好友
+ (NSString *)deleteFriend {
    return [NSString stringWithFormat:@"%@account/deletefriend",baseURL];
}

#pragma mark -- 融云
+ (NSString *)getrc {
    return [NSString stringWithFormat:@"%@account/getrc",baseURL];
}
//获取朋友信息
+ (NSString *)getFrinds {
    return [NSString stringWithFormat:@"%@account/friends",baseURL];
}


#pragma mark -- 获取上传图片的token
+ (NSString *)getUpTokenForPhotoWithType:(NSString *)type {
    return [NSString stringWithFormat:@"%@file/upimgtoken/type/%@",baseURL,type];
}

#pragma mark -
#pragma mark - circle
#pragma mark -- 创建圈子作品
+ (NSString *)createCircle {//创建圈子作品
    return [NSString stringWithFormat:@"%@index/create",baseURL];
}
#pragma mark -- hot circle
+ (NSString *)getHotsWithPages:(NSInteger)page sort:(NSString *)sort
{
    return [NSString stringWithFormat:@"%@index/circlehot/page/%ld/sort/%@",baseURL,(long)page,sort];
}
#pragma mark -- circle 详情
+ (NSString *)getCircleDetailWithCid:(NSString *)cid {//获取详情
    return [NSString stringWithFormat:@"%@index/detail/cid/%@",baseURL, cid];
}



+ (NSString *)sendAuthCodeWithPhoneNum:(NSString *)phoneNum {//发送验证码
    return [NSString stringWithFormat:@"%@account/verify-code?mobile=%@",baseURL,phoneNum];
}





#pragma mark - ME



#pragma mark - 图片上传
+ (NSString *)upImageToCircle {
    return [NSString stringWithFormat:@"%@file/upimg",baseURL];
}

#pragma mark - 图片上传
+ (NSString *)upVideoToCircle {
    return [NSString stringWithFormat:@"%@public/upvideo.php",baseURL];
}

#pragma mark - JS
+ (NSString *)upjscode {
    return [NSString stringWithFormat:@"%@index/upjscode",baseURL];
}

+ (NSString *)jscode {
    return [NSString stringWithFormat:@"%@rsa/jscode",baseURL];
}

#pragma mark -- test rsa
+ (NSString *)rsa {
    return [NSString stringWithFormat:@"%@rsa/bicode",baseURL];
}

@end
