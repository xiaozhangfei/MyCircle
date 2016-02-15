//
//  XFPicVideoPicker.m
//  MyCircle
//
//  Created by and on 15/12/13.
//  Copyright © 2015年 and. All rights reserved.
//

#import "XFPicVideoPicker.h"
#import "BaseViewController.h"
#import "UIIMage+Resizing.h"
#import <MediaPlayer/MediaPlayer.h>

#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface XFPicVideoPicker () <UIAlertViewDelegate>

@property (nonatomic, readonly, weak) BaseViewController <XFPicVideoPickerProtocol> *controller;
@property (nonatomic, strong) UIViewController *imagePickerViewController;
@property (nonatomic,strong) UIImagePickerController *imagePicker;

@end

@implementation XFPicVideoPicker

- (id)initWithController:(BaseViewController<XFPicVideoPickerProtocol> *)controller
{
    self = [super init];
    if (self) {
        _controller = controller;
    }
    return self;
}

- (void)showPicActionSheet:(id)sender descMsg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"图片选择" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选取", nil];
    alert.delegate = self;
    alert.tag = 555;
    [alert show];
}

- (void)showVideoActionSheet:(id)sender descMsg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频选择" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍摄",@"从手机相册选取", nil];
    alert.delegate = self;
    alert.tag = 556;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.type == XFPicVideoPickerTypePic) {
        switch (buttonIndex) {
            case 1:
                [self getPhotoFromCamera];
                break;
            case 2:
            {
                [self getPhotoFromLibrary];
            }
                break;
            default:
                break;
        }
    }else {
        switch (buttonIndex) {
            case 1:
                [self getVideoFromCamera];
                break;
            case 2:
                [self getVideoFromLibrary];
                break;
            default:
                break;
        }
    }
    
}

#pragma mark -- pic
/** 从相机里获取图片*/
- (void)getPhotoFromCamera
{
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = _isAllowsEditing;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self.controller presentViewController:imagePicker animated:YES completion:nil];
    }else {
        [self showAlertWithMsg:@"相机不可用"];
    }
}

/**从相册里获取图片*/
- (void)getPhotoFromLibrary
{

    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        //pickerImage.mediaTypes = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",kUTTypeImage],nil];
        pickerImage.delegate = self;
        pickerImage.allowsEditing = _isAllowsEditing;
        [self.controller presentViewController:pickerImage animated:YES completion:nil];
    }
}


#pragma mark -- video
/** 拍摄视频 **/
- (void)getVideoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
         //设置图像选取控制器的来源模式为相机模式
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置图像选取控制器的类型为动态图像
        _imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        //设置摄像图像品质
        _imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        //设置最长摄像时间
        _imagePicker.videoMaximumDuration = 30;
        //允许用户进行编辑
        _imagePicker.allowsEditing = _isAllowsEditing;
        [self.controller presentViewController:_imagePicker animated:YES completion:nil];
    }else {
        [self showAlertWithMsg:@"相机不可用"];
    }
}
/** 从相册里获取视频 */
- (void)getVideoFromLibrary
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
        videoPicker.sourceType = UIImagePickerControllerCameraCaptureModePhoto;
        videoPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:videoPicker.sourceType];
        videoPicker.delegate = self;
        videoPicker.allowsEditing = YES;
        
        [self.controller presentViewController:videoPicker animated:YES completion:nil];
    }
}

- (void)showAlertWithMsg:(NSString *)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self.controller presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (self.type == XFPicVideoPickerTypePic) {//图片
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.controller selectImage:@[image]];
    } else {//视频
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if([mediaType isEqualToString:@"public.movie"]) {
            NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            NSString *url = [videoURL path];
            NSLog(@"====1234567======>%@",videoURL);
            NSLog(@"found a video");
            //获取视频的thumbnail
            MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:videoURL];
            UIImage  *thumbnail = [player thumbnailImageAtTime:0.1 timeOption:MPMovieTimeOptionNearestKeyFrame];
            player = nil;
            [self.controller selectVideo:url videoUrl:videoURL image:thumbnail];
        } else if ([mediaType isEqualToString:(NSString*)kUTTypeMovie]) {//如果是录制视频
            NSLog(@"video...");
            NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
            NSString *urlStr=[url path];
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
                MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
                player.shouldAutoplay = NO;
                UIImage  *thumbnail = [player thumbnailImageAtTime:0.1 timeOption:MPMovieTimeOptionNearestKeyFrame];
                player = nil;
                
                [self.controller selectVideo:urlStr videoUrl:url image:thumbnail];
                //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
                //UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
            }
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else {
        NSLog(@"视频保存成功.");
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
