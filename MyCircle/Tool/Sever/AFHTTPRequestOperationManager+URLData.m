//
//  AFHTTPRequestOperationManager+URLData.m
//  Chuangdou
//
//  Created by and on 15/7/1.
//  Copyright (c) 2015年 and. All rights reserved.
//

#import "AFHTTPRequestOperationManager+URLData.h"

#import "BaseModel.h"
#import "XFAppContext.h"
#import "UtilsMacro.h"
#import <UIKit/UIKit.h>

#import "AFManagerHandle.h"
#import "MiscTool.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

#import <MJExtension.h>

#import "XFAPI.h"
@implementation AFHTTPRequestOperationManager (URLData)
//状态栏小菊花显示
+ (void)showNetworkActivityIndicator {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
//状态栏小菊花隐藏
+ (void)hideNetworkActivityIndicatorVisible {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -- post数据请求
+ (void)postWithURLStrintg:(NSString *)urlStr parameters:(id)dict success:(SuccessBlock)success failure:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFManagerHandle shareHandle].manager;
    __weak typeof (self)weakSelf = self;
    //状态栏菊花打开
    [self showNetworkActivityIndicator];
    
    [manager POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *di = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        success(operation, (NSDictionary *)di[@"data"],[weakSelf initBaseModelWithDictionary:di]);
        //状态栏菊花关闭
        [weakSelf hideNetworkActivityIndicatorVisible];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",error);
        failure(operation, error, nil);
        
        //状态栏菊花关闭
        [weakSelf hideNetworkActivityIndicatorVisible];
    }];
}


+ (BaseModel *)initBaseModelWithDictionary:(NSDictionary *)di {
    BaseModel *baseModel = [[BaseModel alloc] init];
    baseModel.error = [di[@"error"] boolValue];
    baseModel.code = di[@"code"];
    baseModel.s_description = di[@"description"];
    return baseModel;
}
#pragma mark -- get数据请求
+ (void)getWithURLString:(NSString *)urlStr parameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(failureBlock)failure
{
    
    AFHTTPRequestOperationManager *manager = [AFManagerHandle shareHandle].manager;
    __weak typeof (self)weakSelf = self;
    //状态栏菊花打开
    [self showNetworkActivityIndicator];
    
    NSString *stringCleanPath = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:stringCleanPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *di = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        success(operation, (NSDictionary *)di[@"data"],[weakSelf initBaseModelWithDictionary:di]);
        //状态栏菊花关闭
        [weakSelf hideNetworkActivityIndicatorVisible];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        failure(operation, error, nil);
        //状态栏菊花关闭
        [weakSelf hideNetworkActivityIndicatorVisible];
    }];

}
#pragma mark -- get数据请求，有进度条
+ (void)getWithURLString:(NSString *)urlStr parameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(failureBlock)failure  dataRequestProgress:(dataRequestProgressBlock )dataRequestProgress
{

    AFHTTPRequestOperationManager *manager = [AFManagerHandle shareHandle].manager;
    __weak typeof (self)weakSelf = self;
    //状态栏菊花打开
    [self showNetworkActivityIndicator];
    
    AFHTTPRequestOperation *option = [manager GET:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *di = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        success(operation, (NSDictionary *)di[@"data"],[weakSelf initBaseModelWithDictionary:di]);
        //状态栏菊花关闭
        [weakSelf hideNetworkActivityIndicatorVisible];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        failure(operation, error, nil);
        //状态栏菊花关闭
        [weakSelf hideNetworkActivityIndicatorVisible];
    }];
    
    //进度条
    [option setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        dataRequestProgress (bytesRead, totalBytesRead, totalBytesExpectedToRead);
    }];
}
#pragma mark -- delete数据请求
+ (void)deleteWithURLString:(NSString *)urlStr parameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFManagerHandle shareHandle].manager;
    __weak typeof (self)weakSelf = self;
    //状态栏菊花打开
    [self showNetworkActivityIndicator];
    [manager DELETE:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *di = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        success(operation, (NSDictionary *)di[@"data"],[weakSelf initBaseModelWithDictionary:di]);
        //状态栏菊花关闭
        [weakSelf hideNetworkActivityIndicatorVisible];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        failure(operation, error, nil);
        //状态栏菊花关闭
        [weakSelf hideNetworkActivityIndicatorVisible];
    }];
}
#pragma mark -- put数据请求
+ (void)putWithURLString:(NSString *)urlStr parameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFManagerHandle shareHandle].manager;
    __weak typeof (self)weakSelf = self;
    //状态栏菊花打开
    [self showNetworkActivityIndicator];
    [manager PUT:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *di = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        success(operation, (NSDictionary *)di[@"data"],[weakSelf initBaseModelWithDictionary:di]);
        //状态栏菊花关闭
        [weakSelf hideNetworkActivityIndicatorVisible];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        failure(operation, error, nil);
        //状态栏菊花关闭
        [weakSelf hideNetworkActivityIndicatorVisible];
    }];
}

#pragma mark -- 图片上传
/*
 *imageName 新图片名称  可为空，为空则在函数体内计算
 *imageData 图片数据
 *miniType 图片类型
 *dict parameters
 */
+ (void)upOneImageToServerWithImageName:(NSString *)imageName
                              imageData:(NSData *)imageData
                            miniType:(NSString *)miniType
                          parameters:(NSDictionary *)dict
                             success:(upImageSuccessBlock )upSuccess
                                fail:(upImageFailBlock )upFail
                      uploadProgress:(upImageProgressBlock )upImageProgress {
    AFHTTPRequestOperationManager *manager = [AFManagerHandle shareHandle].manager;
    __weak typeof (self)weakSelf = self;
    AFHTTPRequestOperation *operation = [manager POST:[XFAPI upImageToCircle] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //添加生成上传的数据体
        NSString *imgName = imageName;
        if (ISEMPTY(imageName)) {
            imgName = [MiscTool imageNameFromTime];
        }
        [formData appendPartWithFileData:imageData name:@"file" fileName:imgName mimeType:miniType];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id _Nonnull responseObject) {
        
        NSData *JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *di = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        upSuccess(operation, (NSDictionary *)di[@"data"],[weakSelf initBaseModelWithDictionary:di]);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        //NSLog(@"图片上传失败，error = %@",error);
        upFail (operation, error);
    }];
    //进度条
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"bytesWritten=%ld, totalBytesWritten=%lld, totalBytesExpectedToWrite=%lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
//        NSLog(@"-----%f",totalBytesWritten * 1.0 / totalBytesExpectedToWrite);
        upImageProgress (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }];
}

/*
 *  此方法应改为异步单个图片使用
 *
 *imageNameArr 新图片名称
 *imageDataArr 图片数据
 *miniTypeArr 图片类型
 *dict parameters,作为上传标记，通过标记来区分是头像，还是circle图片
 */
+ (void)upImagesToServerWithImageDataArr:(NSArray *)imageDataArr
                               miniTypeArr:(NSArray *)miniTypeArr
                             parameters:(NSDictionary *)dict
                                success:(upImageSuccessBlock )upSuccess
                                   fail:(upImageFailBlock )upFail
                         uploadProgress:(upImageProgressBlock )upImageProgress {
    AFHTTPRequestOperationManager *manager = [AFManagerHandle shareHandle].manager;
    __weak typeof (self)weakSelf = self;
    AFHTTPRequestOperation *operation = [manager POST:[XFAPI upImageToCircle] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //生成上传的数据体
        NSArray *imageNameArr = [MiscTool imageNamesWithCount:imageDataArr.count];
        for (NSInteger i = 0; i < imageDataArr.count; i ++) {
            [formData appendPartWithFileData:imageDataArr[i] name:[NSString stringWithFormat:@"file%ld",i] fileName:imageNameArr[i] mimeType:miniTypeArr[i]];
        }
        //newImageName = [NSString stringWithFormat:@"%@11.png", paramName];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id _Nonnull responseObject) {
        
        NSData *JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *di = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        upSuccess(operation, (NSDictionary *)di[@"data"],[weakSelf initBaseModelWithDictionary:di]);
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        //NSLog(@"图片上传失败，error = %@",error);
        upFail (operation, error);
    }];
    //进度条
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"bytesWritten=%ld, totalBytesWritten=%lld, totalBytesExpectedToWrite=%lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
//        NSLog(@"-----%f",totalBytesWritten * 1.0 / totalBytesExpectedToWrite);
        upImageProgress (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }];
}

#pragma mark -- 视频上传，包括一张缩略图
/*
 *videoUrl      视频url
 *videoName     上传后视频名称
 *thumbImage    视频缩略图
 *thumbIMageName 视频缩略图名称
 */
+ (void)upVideoToServerWithVideoUrl:(NSURL *)videoUrl
                          vid:(NSString *)vid
                         thumbImage:(UIImage *)thumbImage
                         parameters:(NSDictionary *)dict
                            success:(upImageSuccessBlock )upSuccess
                               fail:(upImageFailBlock )upFail
                     uploadProgress:(upImageProgressBlock )upImageProgress {
    
    AFHTTPRequestOperationManager *manager = [AFManagerHandle shareHandle].manager;
    AFHTTPRequestOperation *operation = [manager POST:[XFAPI upVideoToCircle] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *vName = vid;//视频名称
        if (ISEMPTY(vid)) {
            vName = [MiscTool md5:[MiscTool videoNameFromTime]];
        }else {
            vName = [MiscTool md5:vName];
        }
        [formData appendPartWithFileURL:videoUrl name:@"video" fileName:[NSString stringWithFormat:@"%@.mov",vName] mimeType:@"video/mov" error:nil];
        [formData appendPartWithFileData:UIImagePNGRepresentation(thumbImage) name:@"image" fileName:[NSString stringWithFormat:@"%@.png",vName] mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *di = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //NSLog(@"视频上传成功，responseObject = %@",di);
        BaseModel *baseModel = [[BaseModel alloc] init];
        baseModel.error = [di[@"error"] boolValue];
        baseModel.code = di[@"code"];
        baseModel.s_description = di[@"description"];
        upSuccess (operation, di, baseModel);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        //NSLog(@"图片上传失败，error = %@",error);
        upFail (operation, error);
    }];
    //进度条
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"bytesWritten=%ld, totalBytesWritten=%lld, totalBytesExpectedToWrite=%lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
//        NSLog(@"-----%f",totalBytesWritten * 1.0 / totalBytesExpectedToWrite);
        upImageProgress (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }];
}















@end
