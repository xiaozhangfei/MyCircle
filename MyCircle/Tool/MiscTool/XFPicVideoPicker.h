//
//  XFPicVideoPicker.h
//  MyCircle
//
//  Created by and on 15/12/13.
//  Copyright © 2015年 and. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BaseViewController;

typedef enum {
    XFPicVideoPickerTypePic,
    XFPicVideoPickerTypeVideo
} XFPicVideoPickerType;

@protocol XFPicVideoPickerProtocol <NSObject>

@optional
- (void)selectImage:(NSArray *)images;

- (void)selectVideo:(NSString *)urlStr videoUrl:(NSURL *)videoUrl image:(UIImage *)image ;

@end

@interface XFPicVideoPicker : UIView <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (assign, nonatomic) XFPicVideoPickerType type;
@property (assign, nonatomic) BOOL isAllowsEditing;

//选择图片时需要设置
@property (assign, nonatomic) NSInteger maxCount;
@property (assign, nonatomic) NSInteger columnCount;
- (id)initWithController:(BaseViewController<XFPicVideoPickerProtocol> *)controller;

- (void)showPicActionSheet:(id)sender descMsg:(NSString *)msg;

- (void)showVideoActionSheet:(id)sender descMsg:(NSString *)msg;

@end
