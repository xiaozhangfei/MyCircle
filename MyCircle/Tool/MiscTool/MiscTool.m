//
//  MiscTool.m
//  Chuangdou
//
//  Created by tech on 15/6/29.
//  Copyright (c) 2015年 and. All rights reserved.
//

#import "MiscTool.h"

#import "NSString+URLEncoding.h"
#import <CoreText/CoreText.h>
#import <CFNetwork/CFNetwork.h>

#include <ifaddrs.h>
#include <arpa/inet.h>

//md5加密
#import <CommonCrypto/CommonDigest.h>
#import "XFAppContext.h"
//RSA加密
#import "RSA.h"
#import "SecurityUtil.h"//aes加密

@implementation MiscTool

+ (UIView *)returnLeftPlaceViewWithImageStr:(NSString *)imageStr frame:(CGRect )frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, frame.size.width - 15, frame.size.height - 8)];
    imV.image = [UIImage imageNamed:imageStr];
    [view addSubview:imV];
    return view;
}

+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18,17开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((17[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


+ (CGFloat)TextHeight:(NSString *)text textFont:(UIFont *)font CGSize:(CGSize)sizes
{
    CFMutableAttributedStringRef attrString =CFAttributedStringCreateMutable(kCFAllocatorDefault,0);
    CFAttributedStringReplaceString (attrString,CFRangeMake(0,0), (CFStringRef) text);
    CFIndex stringLength = CFStringGetLength((CFStringRef) attrString);
    
    // Change font
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef) font.fontName, font.pointSize,NULL);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, stringLength), kCTFontAttributeName, ctFont);
    
    // Calc the size
    CTFramesetterRef framesetter =CTFramesetterCreateWithAttributedString(attrString);
    CFRange fitRange;
    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, stringLength), NULL, CGSizeMake(sizes.width, CGFLOAT_MAX), &fitRange);
    CFRelease(ctFont);
    CFRelease(framesetter);
    CFRelease(attrString);
    return frameSize.height;
}



//返回文本高度
+ (CGFloat)returnTextHeight:(NSString *)text textFont:(NSInteger)fontSize CGSize:(CGSize)sizes
{
    
    
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
//    
//    NSRange allRange = [text rangeOfString:text];
//    [attrStr addAttribute:NSFontAttributeName
//                    value:[UIFont systemFontOfSize:fontSize]
//                    range:allRange];
//    [attrStr addAttribute:NSForegroundColorAttributeName
//                    value:[UIColor blackColor]
//                    range:allRange];
////    NSRange destRange = [text rangeOfString:tagStr];
////    [attrStr addAttribute:NSForegroundColorAttributeName
////                    value:[UIColor blackColor]
////                    range:destRange];
//    CGFloat titleHeight;
//    
//    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(sizes.width, CGFLOAT_MAX)
//                                        options:options
//                                        context:nil];
//    titleHeight = ceilf(rect.size.height);
//   
//    return titleHeight+2;
      // 加两个像素,防止emoji被切掉.
  
  CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:sizes lineBreakMode:NSLineBreakByWordWrapping];
  return size.height;
}

//返回文本宽度
+ (CGFloat)returnTextWidth:(NSString *)text textFont:(NSInteger)fontSize CGSize:(CGSize)sizewidth
{
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:sizewidth lineBreakMode:NSLineBreakByWordWrapping];
    return size.width;
}



//根据 1989-10-19 生日格式 计算出对于的星座
+ (NSString *)getXZ:(NSString *)brithDay
{
    
    brithDay = [brithDay stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *day = [brithDay substringFromIndex:brithDay.length-2];
    NSString *month = [brithDay substringWithRange:NSMakeRange(brithDay.length-4, 2)];
    
    NSString *astroString = @"摩羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手摩羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    int m = [month intValue];
    int d = [day intValue];
    
    
    if (m<1||m>12||d<1||d>31){
        
        return @"错误日期格式!";
        
    }
    
    if(m==2 && d>29)
        
    {
        
        return @"错误日期格式!!";
        
    }else if(m==4 || m==6 || m==9 || m==11) {
        
        if (d>30) {
            
            return @"错误日期格式!!!";
            
        }
        
    }
    
    result=[NSString stringWithFormat:@"%@座",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    return result;
}


+ (UIView *)returnIconAndTitleViewWithIndex:(NSInteger )index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_ORIGINWIDTH_4(45), SCREEN_ORIGINWIDTH_4(72))];
    view.userInteractionEnabled = YES;
    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_ORIGINWIDTH_4(45), SCREEN_ORIGINWIDTH_4(45))];
    [view addSubview:imv];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imv.height, imv.width, view.height - imv.height)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColorFromRGB(153, 153, 153);
    label.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:label];
    switch (index) {
        case 0:
        {
            imv.image = [UIImage imageNamed:@"pc_wechat"];
            label.text = @"微信";
            view.tag = 1001;
        }
            break;
        case 1:
        {
            imv.image = [UIImage imageNamed:@"pc_circle"];
            label.text = @"朋友圈";
            view.tag = 1002;
        }
            break;
        case 2:
        {
            imv.image = [UIImage imageNamed:@"pc_weibo"];
            label.text = @"微博";
            view.tag = 1003;
        }
            break;
        case 3:
        {
            imv.image = [UIImage imageNamed:@"pc_qq"];
            label.text = @"QQ";
            view.tag = 1004;
        }
            break;
        case 4:
        {
            imv.image = [UIImage imageNamed:@"pc_link"];
            label.text = @"复制链接";
            view.tag = 1005;
        }
            break;
        case 5:
        {
            imv.image = [UIImage imageNamed:@"举报"];
            label.text = @"举报";
            view.tag = 1006;
        }
            break;
        default:
            break;
    }
    return view;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//转换字符串为带链接的字符串
+ (NSString*)parseText:(NSString*)text
{
    //目标样式<a href='http://www.google.com'>@zheng</a>
    //有三种不同形式的链接
    //<a href='user://zhang'>@zhang</a>        //@zhang
    //<a href='topic://#话题#'>%@</a>
    //<a href='http://www.google.com'>http://www.google.com</a>
    
    NSString* regEx = @"(@[\\w-]{2,30})|(#[^#]+#)|(http(s)?://([a-zA-Z0-9_./-]+))";
    //使用系统自带的类库
    NSRegularExpression* reg = [NSRegularExpression regularExpressionWithPattern:regEx
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:NULL];
    //NSMatchingReportProgress 搜索所有的结果
    NSArray* resultArr = [reg matchesInString:text
                                      options:NSMatchingReportProgress
                                        range:NSMakeRange(0, text.length)];
    
    NSString* finalText = text;
    NSString* replaceStr = nil;
    for (NSTextCheckingResult* result in resultArr) {
        NSString* linkStr = [text substringWithRange:result.range];
        
        if ([linkStr hasPrefix:@"@"]) { //用户
            replaceStr = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>", [linkStr substringFromIndex:1], linkStr];
        }
//        else if ([linkStr hasPrefix:@"#"]) { //话题
//            replaceStr = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",linkStr, linkStr];
//        }
//        else if ([linkStr hasPrefix:@"http"]) { //短链接
//            replaceStr = [NSString stringWithFormat:@"<a href='%@'>%@</a>", linkStr, linkStr];
//        }
        
        //替换
        if (replaceStr) {
            //只要出现了linkStr的地方,都需要替换成replaceStr
            finalText = [finalText stringByReplacingOccurrencesOfString:linkStr withString:replaceStr];
        }
    }
    
    return finalText;
}

+ (NSString *)deviceIPAdress {
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);  
    
    NSLog(@"手机的IP是：%@", address);
    return address;  
}
#pragma mark -- 通过当前时间戳和userid，再计算md5来获取新的图片的名称
+ (NSString *)imageNameFromTime {
    //将当前时间戳，userid连接，取md5
    NSInteger ini = [[NSDate date] timeIntervalSince1970];
    NSString *paramName = [NSString stringWithFormat:@"%ld%@", ini, [XFAppContext sharedContext].uid];
    paramName = [MiscTool md5:paramName];
    //得到图片名
    NSString *newImageName = [NSString stringWithFormat:@"%@.png", paramName];
    
    return newImageName;
}
//上传多张图片时，获取图片名称数组
+ (NSArray *)imageNamesWithCount:(NSInteger )count {
    NSMutableArray *arr = [NSMutableArray array];
    //将当前时间戳，userid连接，取md5
    NSInteger ini = [[NSDate date] timeIntervalSince1970];
    NSString *paramName = [NSString stringWithFormat:@"%ld%@", ini, [XFAppContext sharedContext].uid];
    for (NSInteger i = 0; i < count; i ++) {
        NSString *param = [NSString stringWithFormat:@"%@%ld",paramName, i];
        paramName = [MiscTool md5:param];
        //得到图片名
        NSString *newImageName = [NSString stringWithFormat:@"%@.png", paramName];
        [arr addObject:newImageName];
    }
    return arr;
}

//md5加密
+ (NSString *)md5:(NSString *)value{
    
    const char *cStr = [value UTF8String];
    
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark -- 通过当前时间戳和userid，再计算md5来获取新的视频和图片的名称，视频和缩略图，同一个名称，后缀不同，所以不返回后缀
+ (NSString *)videoNameFromTime {
    //将当前时间戳，userid连接，取md5
    NSInteger ini = [[NSDate date] timeIntervalSince1970];
    NSString *paramName = [NSString stringWithFormat:@"%ld%@", ini, [XFAppContext sharedContext].uid];
    paramName = [MiscTool md5:paramName];
    return paramName;
}

//对密码加密
+ (NSString *)encryptPwdForTrans:(NSString *)pwd {
    NSString *md5 = [self md5:pwd];
    NSString *s = [RSA encryptString:md5 publicKey:rsa_public_key];
    return s;
}


//状态栏小菊花显示
+ (void)showNetworkActivityIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
//状态栏小菊花隐藏
+ (void)hideNetworkActivityIndicatorVisible {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


@end
