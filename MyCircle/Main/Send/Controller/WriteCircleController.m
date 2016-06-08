//
//  WriteCircleController.m
//  MyCircle
//
//  Created by and on 15/11/4.
//  Copyright © 2015年 and. All rights reserved.
//

#import "WriteCircleController.h"
#import "WriteView.h"

#import <UIViewController+LJWKeyboardHandlerHelper.h>



//图片上传
#import "AFManagerHandle.h"
#import "MiscTool.h"

#import "XFPicVideoPicker.h"
//
//#import <AssetsLibrary/AssetsLibrary.h>
//#import <ImageIO/ImageIO.h>
//
////#import "DoImagePickerController.h"
////#import "AssetHelper.h"
//
//#import "AGImagePickerController.h"
//#import "AGIPCToolbarItem.h"

#import <Photos/Photos.h>

#import "ALAsset+AGIPC.h"
#import "AFHTTPRequestOperationManager+URLData.h"

@interface WriteCircleController () <XFPicVideoPickerProtocol, UIAlertViewDelegate>
{
    UIScrollView *_scroll;
    UIImage *_upImage;//图片
    NSURL *_videoUrl;//视频地址
    UIImage *_thumbImage;//视频缩略图
    NSInteger _nowSelectImage;//标记当前点击的图片的index
    NSInteger _imageCount;//图片个数


}
@property (strong, nonatomic) WriteView *writeView;
@property (strong, nonatomic) XFPicVideoPicker *xfPicker;//图片视频选择器

@property (strong, nonatomic) NSMutableArray *selectedPhotos;

@end

@implementation WriteCircleController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedPhotos = [NSMutableArray array];
    
    [self initView];
    [self initData];
    //[self initAGPicker];
}

- (void)initAGPicker {
    //self.selectedPhotos = [NSMutableArray array];
    

}

- (void)picHandle:(NSArray *)array {
    for (int i = 0; i < array.count; i ++) {
        ((UIImageView *)[_writeView viewWithTag:i + 300]).hidden = NO;

        //通过ALAsset获取相对应的资源，获取图片的等比缩略图，原图的等比缩略
        ALAsset *asset = (ALAsset *)array[i];
        CGImageRef ratioThum = [asset aspectRatioThumbnail];
        //获取相片的缩略图，该缩略图是相册中每张照片的poster图
        //CGImageRef thum = [asset thumbnail];
        UIImage* rti = [UIImage imageWithCGImage:ratioThum];
        ((UIImageView *)[_writeView viewWithTag:i + 300]).image = rti;
    }
}

- (void)initView {
    
    self.title = @"发心情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    rightImg.image = [UIImage imageNamed:@"pay_open_touchID_success"];
    [rightImg addTapCallBack:self sel:@selector(rightBarButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightImg];
    
    _scroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    //20 + 50 + 20 + 120 + 20 + 50 + 20 + width
    _scroll.backgroundColor = HexColor(0xFBF7ED);
    _scroll.contentSize = CGSizeMake(_scroll.frame.size.width, SCREEN_CURRETWIDTH(1120));
    [self.view addSubview:_scroll];
    
    _writeView = [[WriteView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_CURRETWIDTH(1120))];
    [_scroll addSubview:_writeView];
    
    _writeView.labelLocation.text = @"暂无定位";
    for (int i = 0; i < 5; i ++) {
        [[_writeView viewWithTag:300 + i] addTapCallBack:self sel:@selector(pickAssets:)];//点击添加
        [[_writeView viewWithTag:300 + i] addlongCallBack:self sel:@selector(imageLongPressAction:)];//长按编辑
        [[_writeView viewWithTag:320 + i] addTapCallBack:self sel:@selector(deleteImageAction:)];//删除图片
    }
    [_writeView.videoPic addTapCallBack:self sel:@selector(uploadVideoAction:)];
    //注册收键盘
    [self registerLJWKeyboardHandler];
}

- (void)initData {
    _imageCount = 0;
    [self getData];
}

- (void)getData {
    
}
#pragma mark -- 图片选择、上传
- (void)uploadImageAction:(UIGestureRecognizer *)sender {
    if (!_xfPicker) {
        _xfPicker = [[XFPicVideoPicker alloc] initWithController:self];
    }
    _xfPicker.type = XFPicVideoPickerTypePic;
    _xfPicker.isAllowsEditing = NO;
    [_xfPicker showPicActionSheet:self descMsg:@"图片选择"];

}

- (void)selectImage:(NSArray *)images {
//    for (int i = 0; i < 5; i++) {
//        ((UIImageView *)[_writeView viewWithTag:i + 320]).hidden = NO;
//    }
//    for (int i = 0;i < images.count;i ++) {
//        CGImageRef ratioThum = [[(ALAsset *)images[i] defaultRepresentation] fullResolutionImage];
//        
//        UIImage *image = [UIImage imageWithCGImage:ratioThum];
//        ((UIImageView *)[_writeView viewWithTag:i + 320]).image = image;
//        CGImageRelease(ratioThum);
//        CGImageRelease(image.CGImage);
//        image = nil;
//    }
//    
//    for (int i = 0; i < 5; i++) {
//        if (i == 0) {
//            ((UIImageView *)[_writeView viewWithTag:i + 320]).hidden = NO;
//        }
//        if (i < MIN(5, images.count)) {
//            ((UIImageView *)[_writeView viewWithTag:i + 300]).image = images[i];
//            ((UIImageView *)[_writeView viewWithTag:i + 300]).hidden = NO;
//        }else if (i == MIN(5, images.count)){
//            ((UIImageView *)[_writeView viewWithTag:i + 300]).image = [UIImage imageNamed:@"cancel"];
//            ((UIImageView *)[_writeView viewWithTag:i + 300]).hidden = NO;
//        }else {
//            ((UIImageView *)[_writeView viewWithTag:i + 300]).hidden = YES;
//        }
//        
//    }
//    if (images.count < 5) {
//        ((UIImageView *)[_writeView viewWithTag:320 + images.count - 1]).hidden = YES;
//    }
    
}

- (void)imageLongPressAction:(UILongPressGestureRecognizer *)sender {
   // NSLog(@"长按编辑 %ld",sender.v)
    [sender.view viewWithTag:sender.view.tag + 20].hidden = NO;
    
}

- (void)deleteImageAction:(UIGestureRecognizer *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = sender.view.tag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title isEqualToString:@"删除图片"]) {
        if (buttonIndex == 1) {
            NSLog(@"删除图片 %ld", alertView.tag - 20);
        }
    }
}

#pragma mark -- 视频选择
- (void)uploadVideoAction:(UIGestureRecognizer *)sender {
    if (!_xfPicker) {
        _xfPicker = [[XFPicVideoPicker alloc] initWithController:self];
    }
    _xfPicker.type = XFPicVideoPickerTypeVideo;
    _xfPicker.isAllowsEditing = NO;
    [_xfPicker showVideoActionSheet:self descMsg:@"视频选择"];
}

- (void)selectVideo:(NSString *)url videoUrl:(NSURL *)videoUrl image:(UIImage *)image {
    NSLog(@"url = %@",url);
    _writeView.videoPic.image = image;
    _videoUrl = videoUrl;
    _thumbImage = image;
    //将视频保存转为NSData
    //[self pushVideoToServerWithVideoUrl:videoUrl videoName:[MiscTool videoNameFromTime] thumbImage:image];
}

+ (BOOL)writeDataToPath:(NSString*)filePath andAsset:(ALAsset*)asset
{
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (!handle) {
        return NO;
    }
    static const NSUInteger BufferSize = 1024*1024;
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    uint8_t *buffer = calloc(BufferSize, sizeof(*buffer));
    NSUInteger offset = 0, bytesRead = 0;
    do {
        @try {
            bytesRead = [rep getBytes:buffer fromOffset:offset length:BufferSize error:nil];
            [handle writeData:[NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO]];
            offset += bytesRead;
        } @catch (NSException *exception) {
            free(buffer);
            return NO;
        }
    } while (bytesRead > 0);
    free(buffer);
    return YES;
}

#pragma mark -- 点击空白处收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark -- 返回 left、right BarItem action
- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewController];
}

#pragma mark --dismiss
- (void)dismissViewController {
    CATransition *animation = [CATransition animation];
    [animation setDuration:4.0];
    //[animation setType:suckEffect];
    animation.type = @"suckEffect";
    [animation setSubtype:kCATransitionFromTop];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [[self.view layer] addAnimation:animation forKey:@"sendDismiss"];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
/**
 *  提交表单
 */
- (void)rightBarButtonAction:(UIGestureRecognizer *)sender {
    //先提交表单，再上传图片
    NSString *location;
    NSString *title;
    NSString *intro;
    
    if (ISEMPTY(_writeView.labelLocation.text)) {
        location = @"大中国";
    }else {
        location = _writeView.labelLocation.text;
    }
    if (ISEMPTY(_writeView.textFieldTitle.text)) {
        title = @"无标题，自动生成";
    }else {
        title = _writeView.textFieldTitle.text;
    }
    if (ISEMPTY(_writeView.textViewIntro.text)) {
        intro = @"无简介自动生成";
    }else {
        intro = _writeView.textViewIntro.text;
    }
    //XFAppContext *context = [XFAppContext sharedContext];
    NSMutableDictionary *mDict = @{
                                   @"userid":@"123",
                                   @"title":title,
                                   @"intro":intro,
                                   @"location":location
                                   }.mutableCopy;
    if (_upImage) {
        NSString *imageName = [MiscTool imageNameFromTime];
        [mDict setObject:[NSString stringWithFormat:@"circle/%@",imageName] forKey:@"pictures"];
        //上传图片到服务器
        [self pushImageToServerWithName:imageName image:_upImage];
    }
    //return;
    if (_videoUrl) {
        NSString *vid = [MiscTool imageNameFromTime];
        //添加视频和图片地址到param
        [mDict setObject:vid forKey:@"vid"];

        //上传视频到服务器
        [self pushVideoToServerWithVideoUrl:_videoUrl vid:vid videoName:@"视频上传" thumbImage:_thumbImage];
    }
    
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager postWithURLString:[XFAPI createCircle] parameters:mDict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel) {
        
        if (![baseModel.code isEqual:@"200"]) {
            [weakSelf showToast:@"发送失败"];
            NSLog(@"发布失败");
            return;
        }
        [weakSelf showToast:@"发送成功"];
        NSLog(@"发布成功");
        [weakSelf dismissViewController];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        [weakSelf showToast:@"发布失败"];
    }];
    

    
}

- (void)pushImageToServerWithName:(NSString *)name image:(UIImage *)image {
    if (image) {//图片存在
        NSDictionary *dict = @{@"mark":@"pictures",@"nosql":@"1"};
        [AFHTTPRequestOperationManager upOneImageToServerWithImageName:name imageData:UIImagePNGRepresentation(image) miniType:@"image/png" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseDict, BaseModel *baseModel) {
            NSLog(@"图片上传成功，responseObject = %@",responseDict);
        } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"图片上传失败，error = %@",error);
        } uploadProgress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"bytesWritten=%lu, totalBytesWritten=%llu, totalBytesExpectedToWrite=%llu", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
            NSLog(@"图片-----%f",totalBytesWritten * 1.0 / totalBytesExpectedToWrite);
        }];
    }
}

/*
 *videoName 作为视频和缩略图的名称
 */
- (void)pushVideoToServerWithVideoUrl:(NSURL *)videoUrl vid:(NSString *)vid videoName:(NSString *)videoName thumbImage:(UIImage *)thumbImage {
    NSDictionary *dict = @{@"mark":@"circle",@"nosql":@"1",@"videoname":videoName, @"vid":vid};
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager upVideoToServerWithVideoUrl:videoUrl vid:vid thumbImage:thumbImage parameters:dict success:^(AFHTTPRequestOperation *operation, id responseDict, BaseModel *baseModel) {
        NSLog(@"视频上传成功，responseObject = %@",responseDict);
    } fail:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"视频上传失败，error = %@",error);
    } uploadProgress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        [weakSelf upVideoProgressWithBytesWritten:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }];
}

- (void)upVideoProgressWithBytesWritten:(NSUInteger )bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite {
    //NSLog(@"bytesWritten=%ld, totalBytesWritten=%lld, totalBytesExpectedToWrite=%lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    NSLog(@"视频-----%f",totalBytesWritten * 1.0 / totalBytesExpectedToWrite);
}

- (void)dealloc {
    _xfPicker = nil;
    _writeView = nil;
    _thumbImage = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)pickAssets:(id)sender
//{
//    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            // init picker
//            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
//            
//            // set delegate
//            picker.delegate = self;
//            
//            // to present picker as a form sheet in iPad
//            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//                picker.modalPresentationStyle = UIModalPresentationFormSheet;
//            
//            // present picker
//            [self presentViewController:picker animated:YES completion:nil];
//            
//        });
//    }];
//}
//
//// implement should select asset delegate
//- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
//{
//    NSInteger max = 3;
//    
//    // show alert gracefully
//    if (picker.selectedAssets.count >= max)
//    {
//        UIAlertController *alert =
//        [UIAlertController alertControllerWithTitle:@"Attention"
//                                            message:[NSString stringWithFormat:@"Please select not more than %ld assets", (long)max]
//                                     preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *action =
//        [UIAlertAction actionWithTitle:@"OK"
//                                 style:UIAlertActionStyleDefault
//                               handler:nil];
//        
//        [alert addAction:action];
//        
//        [picker presentViewController:alert animated:YES completion:nil];
//    }
//    
//    // limit selection to max
//    return (picker.selectedAssets.count < max);
//}
//
//#pragma mark - Assets Picker Delegate
//
//- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    
////    self.assets = [NSMutableArray arrayWithArray:assets];
//}

@end
