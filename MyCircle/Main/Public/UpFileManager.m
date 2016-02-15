//
//  UpFileManager.m
//  MyCircle
//
//  Created by and on 15/12/30.
//  Copyright © 2015年 and. All rights reserved.
//

#import "UpFileManager.h"

#import "XFAPI.h"
#import "AFHTTPRequestOperationManager+URLData.h"
#import "XFAppContext.h"
#import "BaseModel.h"

#import <QiniuSDK.h>
#import "UIView+Ext.h"
#import "XFTopToast.h"
#import "UtilsMacro.h"

static UpFileManager *_manager = nil;
@implementation UpFileManager

+ (instancetype) shareHandle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[UpFileManager alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        //_manager = [[UpFileManager alloc] init];
        
    }
    return self;
}

- (void)sendSingleImageWithImage:(UIImage *)image type:(UpFileManagerType )type key:(NSString *)key token:(NSString *)token {
    
    [self upImageWithImage:image type:(type) key:key token:token];
    
}

- (void)upImageWithImage:(UIImage *)image type:(UpFileManagerType )type key:(NSString *)key token:(NSString *)token {
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSDictionary *di = @{@"x:uid":[NSString stringWithFormat:@"%@",[[XFAppContext sharedContext].uid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]],
                         @"x:token":[[XFAppContext sharedContext].token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
//    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:@"text/plain" progressHandler:nil params:di checkCrc:YES cancellationSignal:nil];
    __weak typeof (self) weakSelf = self;
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:@"text/plain" progressHandler:^(NSString *key, float percent) {
        [weakSelf upImageProgressHandler:key percent:percent];
    } params:di checkCrc:YES cancellationSignal:nil];
    //不管自选还是第三方，从ImageView直接取出，不需要另行判断
    //NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSData *data = [UIView imageToQualityWithImage:image KB:500];
    [self initPregressView];
    [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"info = %@\nkey = %@\nresp=%@",info,key,resp);
        NSDictionary *re = (NSDictionary *)resp;
        if (![re[@"code"] isEqual:@"200"]) {
            //[weakSelf showToast:@"上传图片失败"];
            [weakSelf removeProgressView];
            [XFTopToast showXFTopViewWithText:@"上传图片失败" image:[UIImage imageNamed:@"operationbox_fail_web"] leftOffset:10 topOffset:20 backColor:HexColor(0x09BB07) time:5.0f];
            return ;
        }
        [weakSelf upImageSuccessHandleWithResponse:re type:type];
    } option:opt];
}

- (void)initPregressView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.width, 20)];
    backView.backgroundColor = HexColor(0xFBF7ED);
    backView.tag = 1111;
    [window addSubview:backView];
    UIView *proView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    proView.backgroundColor = HexColor(0x09BB07);
    proView.tag = 1112;
    [window addSubview:proView];
}

- (void)upImageProgressHandler:(NSString *)key percent:(float )percent {
    NSLog(@"key -- %@",key);
    NSLog(@"percent -- %f",percent);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    dispatch_async(dispatch_get_main_queue(), ^{
        [window viewWithTag:1112].frame = CGRectMake(0, 0, window.width * percent, 20);
    });
    
}
//移除进度条
- (void)removeProgressView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [[window viewWithTag:1112] removeFromSuperview];
    [[window viewWithTag:1111] removeFromSuperview];
}

- (void)upImageSuccessHandleWithResponse:(NSDictionary *)dict type:(UpFileManagerType )type{
    [self removeProgressView];
    [XFTopToast showXFTopViewWithText:@"上传图片成功" image:[UIImage imageNamed:@"Shake_Received_Icon"] leftOffset:10 topOffset:20 backColor:HexColor(0x09BB07) time:5.0f];
    //图片上传成功之后保存
    XFAppContext *context = [XFAppContext sharedContext];
    if (type == UpFileManagerTypePortrait) {
        context.portrait = dict[@"data"][@"path"];
        //头像上传成功后需通知更新其他处的头像，列表内头像需手动刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHPORTRAIT" object:nil userInfo:nil];
    }else if (type == UpFileManagerTypeBackground) {
        context.backgroundUrl = dict[@"data"][@"path"];
    }
    [context save];
}

@end
