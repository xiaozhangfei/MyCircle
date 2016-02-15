//
//  UpFileManager.h
//  MyCircle
//
//  Created by and on 15/12/30.
//  Copyright © 2015年 and. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    UpFileManagerTypePortrait,
    UpFileManagerTypeBackground
} UpFileManagerType;

@interface UpFileManager : NSObject

@property (strong, nonatomic) UpFileManager *manager;

+ (instancetype)shareHandle;

//待上传的图片
@property (strong, nonatomic) NSMutableArray *images;
//待上传的图片类型，portrait, background, 或其他
@property (assign, nonatomic) NSString *type;

- (void)sendSingleImageWithImage:(UIImage *)image type:(UpFileManagerType )type key:(NSString *)key token:(NSString *)token;

@end
