//
//  MiscTool.h
//  Chuangdou
//
//  Created by tech on 15/6/29.
//  Copyright (c) 2015年 and. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MiscTool : NSObject

/*!
 返回一个textField的leftView
 */
+ (UIView *)returnLeftPlaceViewWithImageStr:(NSString *)imageStr frame:(CGRect )frame;


/*!
 判断手机号格式，正确返回YES，格式不对返回NO
 */
+(BOOL) isValidateMobile:(NSString *)mobile;


/*!
 计算文本 高度/宽度
 */
+ (CGFloat)returnTextHeight:(NSString *)text textFont:(NSInteger)fontSize CGSize:(CGSize)sizes;

+ (CGFloat)TextHeight:(NSString *)text textFont:(UIFont *)font CGSize:(CGSize)sizes;
/*!
 计算文本 宽度
 */
+ (CGFloat)returnTextWidth:(NSString *)text textFont:(NSInteger)fontSize CGSize:(CGSize)sizewidth;

/*!
 根据 1989-10-19 生日格式 计算出对于的星座
 */
+ (NSString *)getXZ:(NSString *)brithDay;

//分享
+ (UIView *)returnIconAndTitleViewWithIndex:(NSInteger )index;

//转字符串为字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//转换字符串为带链接的字符串
+ (NSString*)parseText:(NSString*)text;

//获取当前ip地址
+ (NSString *)deviceIPAdress;

#pragma mark -- 通过当前时间戳和userid，再计算md5来获取新的图片的名称
+ (NSString *)imageNameFromTime;

//上传多张图片时，获取图片名称数组
+ (NSArray *)imageNamesWithCount:(NSInteger )count;

//md5加密
+ (NSString *)md5:(NSString *)value;

#pragma mark -- 通过当前时间戳和userid，再计算md5来获取新的视频和图片的名称，视频和缩略图，同一个名称，后缀不同，所以不返回后缀
+ (NSString *)videoNameFromTime;

/**
 *  对密码进行加密，方便传输
 *
 *  @param pwd 密码明文
 *
 *  @return 经过md5 -> RSA公钥加密 后的字符串
 */
+ (NSString *)encryptPwdForTrans:(NSString *)pwd;

@end
