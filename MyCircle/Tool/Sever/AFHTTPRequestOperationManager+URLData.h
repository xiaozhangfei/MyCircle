//
//  AFHTTPRequestOperationManager+URLData.h
//  Chuangdou
//
//  Created by and on 15/7/1.
//  Copyright (c) 2015年 and. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <Foundation/Foundation.h>

@class BaseModel;

/*
 *数据请求进度block
 */
typedef void(^dataRequestProgressBlock) (NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);
/*
 *数据请求成功block
 */
typedef void(^SuccessBlock) (AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel);
/*
 *数据请求失败block
 */
typedef void(^failureBlock) (AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel);
/*
 *图片上传成功成功block
 */
typedef void(^upImageSuccessBlock) (AFHTTPRequestOperation *operation, id responseDict, BaseModel *baseModel);
/*
 *图片上传失败block
 */
typedef void(^upImageFailBlock) (AFHTTPRequestOperation *operation, NSError *error);
/*
 *文件上传进度block
 */
typedef void(^upImageProgressBlock) (NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);

@interface AFHTTPRequestOperationManager (URLData)
/*
 *post数据请求,无提示进度
 */
+ (void)postWithURLString:(NSString *)urlStr parameters:(id )dict success:(SuccessBlock)success failure:(failureBlock)failure;
/*
 *get数据请求，无提示进度
 */
+ (void)getWithURLString:(NSString *)urlStr parameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(failureBlock)failure;
/*
 *get数据请求，有进度回调
 */
+ (void)getWithURLString:(NSString *)urlStr parameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(failureBlock)failure dataRequestProgress:(dataRequestProgressBlock )dataRequestProgress;
/*
 *delete数据请求
 */
+ (void)deleteWithURLString:(NSString *)urlStr parameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(failureBlock)failure;
/*
 *put数据请求
 */
+ (void)putWithURLString:(NSString *)urlStr parameters:(NSDictionary *)dict success:(SuccessBlock)success failure:(failureBlock)failure;

#pragma mark -- 图片上传
/*
 *imageName 新图片名称
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
                         uploadProgress:(upImageProgressBlock )upImageProgress;


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
                          uploadProgress:(upImageProgressBlock )upImageProgress;


#pragma mark -- 视频上传，包括一张缩略图
/*
 *videoUrl      视频url
 *videoName     上传后视频名称、也同样是视频缩略图名称，只是后缀不同
 *thumbImage    视频缩略图
 *dict parameters,作为上传标记，通过标记来区分是头像，还是circle图片，nosql 为 1，则不存储到sql，仅仅上传文件
 */
+ (void)upVideoToServerWithVideoUrl:(NSURL *)videoUrl
                          vid:(NSString *)vid
                         thumbImage:(UIImage *)thumbImage
                         parameters:(NSDictionary *)dict
                            success:(upImageSuccessBlock )upSuccess
                               fail:(upImageFailBlock )upFail
                     uploadProgress:(upImageProgressBlock )upImageProgress;




@end
