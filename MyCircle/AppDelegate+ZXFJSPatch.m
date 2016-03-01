//
//  AppDelegate+ZXFJSPatch.m
//  MyCircle
//
//  Created by and on 16/2/15.
//  Copyright © 2016年 and. All rights reserved.
//

#import "AppDelegate+ZXFJSPatch.h"

//修改js
#import <JPEngine.h>

//AES加密
#import "SecurityUtil.h"
#import "GTMBase64.h"
//RSA加密
#import "RSA.h"

#import "MiscTool.h"

// RSA 公钥
#define rsa_public_key @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDdg086h7CIhMPG0EdzE/RacFc3rfpBkKYSQhX2OgObuICugbolSqiaUa6CZc4Ock988ubc6MKUqiLjGfNdOJ3Iod7ryqDb7z4cI08uphhyR6CmhgZZyu6DFzpoudMFQPKr3/vpGZ8Z/Vu7TGJwnuhkpEAUuSoMrYaSKj2qnGmNXQIDAQAB"

#define aesKey @"wodetian123"

@implementation AppDelegate (ZXFJSPatch)

- (void)hello {
    NSLog(@"hello -------------------------");
}

#pragma mark -- 测试加密
/*
 *  rsa非对称加密
 */
- (void)rsa {
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager postWithURLString:[XFAPI rsa] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
        if (![baseModel.code isEqual:@"200"]) {
            NSLog(@"未获取js代码:%@",baseModel.s_description);
            return ;
        }
        [weakSelf rsaHandle:responseDict];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        NSLog(@"js error = %@",error);
    }];
}
// 从网络请求的经过rsa加密过的字符串
- (void)rsaHandle:(NSDictionary *)response {
    NSString *bicode = response[@"code"];//经过rsa加密过的字符串
    
    NSString *cdbicode = [RSA decryptString:bicode publicKey:rsa_public_key];
    NSLog(@"rsa 解密数据 = %@",cdbicode);
}

#pragma mark -- 从网络获取js内容
- (void)getUpJS {
    
    //从网络获取js代码
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager postWithURLString:[XFAPI jscode] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
        if (![baseModel.code isEqual:@"200"]) {
            NSLog(@"未获取js代码:%@",baseModel.s_description);
            return ;
        }
        [weakSelf upJSHandle:responseDict];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        NSLog(@"js error = %@",error);
    }];
}

/*
 *  获取内容为
 *  con         js内容
 *  isUpdate    是否更新（无用）
 *  ver         验证内容，有con 计算md5，再进行rsa加密得来  ||  客户端首页解密得到con的md5值，将此md5值与获取的js内容的md5值进行比较
 *
 *  若值相等，则说明无篡改；否则，说明被篡改，放弃存储
 */
- (void)upJSHandle:(NSDictionary *)response {
    NSMutableString *jsString = [NSMutableString string];
    if (response && [(NSArray *)response count])
    for (NSDictionary *di in (NSArray *)response) {
        NSString *js = di[@"con"];
        
        //计算获取到的js内容的md5值
        NSString *jsMd5 = [MiscTool md5:js];
        
        //解密获取js内容的md5
        NSString *cdMd5 = [RSA decryptString:di[@"ver"] publicKey:rsa_public_key];
        NSLog(@"cd bicode = %@",cdMd5);
        
        //校验
        if (![jsMd5 isEqualToString:cdMd5]) {//经过校验，不相等，说明内容被篡改，直接返回不存储
            NSLog(@"zz 内容被篡改!!!");
            return;
        }
        
        [jsString appendString:js];
        //将代码下载到本地，保存成文件Document/up.js, 各个方法之间使用 ***** 分隔符
        [jsString appendString:@"*****"];
    }
    if ( [jsString isEqualToString:@""]) {//js为空
        [jsString appendString:@"*****"];
    }
    NSString *jsPath = [self jsFilePath];
    NSLog(@"js xx = 写入 %@",jsString);
    
    //将jsString 进行aes对称加密
    jsString = [self aes:jsString].mutableCopy;
    NSLog(@"xx 加密后 = %@",jsString);
    
    NSData *jsData = [jsString dataUsingEncoding:(NSUTF8StringEncoding)];
    [jsData writeToFile:jsPath atomically:YES];
    [self execUpJsWithJsArray:[self readJs]];
}

/*
 *  进行aes对称加密
 */
- (NSString *)aes:(NSString *)aString {
    NSString *biCode = [SecurityUtil encryptAESData:aString app_key:aesKey];
    //NSLog(@"xx 加密： %@",st);
    return biCode;
}
/*
 *  对字符串进行aes解密
 */
- (NSString *)cdAes:(NSString *)aString {
    //NSData *EncryptData1 = [GTMBase64 decodeString:[SecurityUtil encryptAESData:string app_key:aesKey]]; // 解密前进行 GTMBase64 编码
    NSData *EncryptData = [GTMBase64 decodeString:aString];
    NSString *unCode = [SecurityUtil decryptAESData:EncryptData app_key:aesKey];
    //NSLog(@"xx 解密：%@", string1);
    return unCode;
}

//返回js文件路径
- (NSString *)jsFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"up.js"];
    NSLog(@"xx filePath = %@",filePath);
    return filePath;
}

#pragma mark -- js 读取
/*
 *  从文本中读取js内容
 */
- (NSArray *)readJs {
    NSString *file = [self jsFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:file]) {//如果不存在
        return @[];
    }
    NSString *jsString = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    
    //取出后，将jsString 解密
    jsString = [self cdAes:jsString];
    NSLog(@"xx 解密后 = %@",jsString);
    
    NSArray *jsArray = [jsString componentsSeparatedByString:@"*****"];
    return jsArray;
}
/*
 *  执行js
 */
- (void)execUpJsWithJsArray:(NSArray *)jsArray {
    if (jsArray.count == 0) {
        return;
    }
    [JPEngine startEngine];
    for (NSString *js in jsArray) {
        if ([js isEqualToString:@""] || js == nil) {
            continue;
        }
        NSLog(@"read js = %@",js);
        [JPEngine evaluateScript:js];
    }
}

- (void)execJs {
    [self execUpJsWithJsArray:[self readJs]];
}


@end
