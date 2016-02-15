//
//  AGIPCGridItem.m
//  AGImagePickerController
//
//  Created by Artur Grigor on 17.02.2012.
//  Copyright (c) 2012 - 2013 Artur Grigor. All rights reserved.
//  
//  For the full copyright and license information, please view the LICENSE
//  file that was distributed with this source code.
//  

#import "AGIPCGridItem.h"


#import "AGImagePickerController+Helper.h"

@interface AGIPCGridItem ()
{
    AGImagePickerController *_imagePickerController;
    ALAsset *_asset;
    id<AGIPCGridItemDelegate> __ag_weak _delegate;
    
    BOOL _selected;
    

}



+ (void)resetNumberOfSelections;

@end

static NSUInteger numberOfSelectedGridItems = 0;

@implementation AGIPCGridItem

#pragma mark - Properties

@synthesize imagePickerController = _imagePickerController, delegate = _delegate, asset = _asset, selected = _selected, thumbnailImageView = _thumbnailImageView, checkmarkImageView = _checkmarkImageView;

- (void)setSelected:(BOOL)selected
{
    @synchronized (self)
    {
        if (_selected != selected)
        {
            if (selected) {
                // Check if we can select
                if ([self.delegate respondsToSelector:@selector(agGridItemCanSelect:)])
                {
                    if (![self.delegate agGridItemCanSelect:self])
                        return;
                }
            }
            
            _selected = selected;
            
            if (_selected)
            {
                numberOfSelectedGridItems++;
                self.checkmarkImageView.image = [UIImage imageNamed:@"noalselect"];
            }
            else
            {
                if (numberOfSelectedGridItems > 0)
                    numberOfSelectedGridItems--;
                self.checkmarkImageView.image = [UIImage imageNamed:@"alselect"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if ([self.delegate respondsToSelector:@selector(agGridItem:didChangeSelectionState:)])
                {
                    [self.delegate performSelector:@selector(agGridItem:didChangeSelectionState:) withObject:self withObject:@(_selected)];
                }
                
                if ([self.delegate respondsToSelector:@selector(agGridItem:didChangeNumberOfSelections:)])
                {
                    [self.delegate performSelector:@selector(agGridItem:didChangeNumberOfSelections:) withObject:self withObject:@(numberOfSelectedGridItems)];
                }
                
            });
        }
    }
}

- (BOOL)selected
{
    BOOL ret;
    @synchronized (self) { ret = _selected; }
    
    return ret;
}

- (void)setAsset:(ALAsset *)asset
{
    @synchronized (self)
    {
        if (_asset != asset)
        {
            _asset = asset;
            // Drawing must be exectued in main thread. springox(20131218)
            //self.thumbnailImageView.image = [UIImage imageWithCGImage:_asset.thumbnail];
        }
    }
}

- (ALAsset *)asset
{
    ALAsset *ret = nil;
    @synchronized (self) { ret = _asset; }
    
    return ret;
}

#pragma mark - Object Lifecycle

- (id)initWithImagePickerController:(AGImagePickerController *)imagePickerController andAsset:(ALAsset *)asset
{
    self = [self initWithImagePickerController:imagePickerController asset:asset andDelegate:nil];
    return self;
}

- (id)initWithImagePickerController:(AGImagePickerController *)imagePickerController asset:(ALAsset *)asset andDelegate:(id<AGIPCGridItemDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.imagePickerController = imagePickerController;
        
        self.selected = NO;
        self.delegate = delegate;
        
        CGRect frame = self.imagePickerController.itemRect;
        CGRect checkmarkFrame = [self.imagePickerController checkmarkFrameUsingItemFrame:frame];
        
        self.thumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        // Drawing must be exectued in main thread. springox(20131220)
		//self.thumbnailImageView.contentMode = UIViewContentModeScaleToFill;
		[self addSubview:self.thumbnailImageView];
        
        // Position the checkmark image in the bottom right corner
        self.checkmarkImageView = [[UIImageView alloc] initWithFrame:checkmarkFrame];
        self.checkmarkImageView.image = [UIImage imageNamed:@"noalselect"];
		[self addSubview:self.checkmarkImageView];
        
        self.asset = asset;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.thumbnailImageView.contentMode = UIViewContentModeScaleToFill;

    if (self.selected) {
        self.checkmarkImageView.image = [UIImage imageNamed:@"noalselect"];
    }else {
        self.checkmarkImageView.image = [UIImage imageNamed:@"alselect"];
    }
}

// Drawing must be exectued in main thread. springox(20131218)
- (void)loadImageFromAsset
{
    self.thumbnailImageView.image = [UIImage imageWithCGImage:_asset.thumbnail];
    if ([self.imagePickerController.selection containsObject:self]) {
        self.selected = YES;
    }
}

#pragma mark - Others

- (void)tap
{
    self.selected = !self.selected;
}

- (void)zoneImageAction
{
    //放大图片  [UIImage imageWithCGImage:_asset.thumbnail]
    NSLog(@"图片放大..");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor blackColor];
    [window addSubview:view];
    ALAssetRepresentation *defaultAsset = [_asset defaultRepresentation];
    CGImageRef ratioThum = [defaultAsset fullResolutionImage];

    UIImage *image = [UIImage imageWithCGImage:ratioThum];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width / 2, view.frame.size.height / 2, 0, 0)];
    img.tag = 1999;
    img.image = image;
    [view addSubview:img];
    CGImageRelease(ratioThum);
    //CGImageRelease(image.CGImage);
    //image = nil;
    UITapGestureRecognizer *noZoneGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noZoneAction:)];
    noZoneGestureRecognizer.numberOfTapsRequired = 1;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:noZoneGestureRecognizer];
    //[view addTapCallBack:self sel:@selector(noZoneAction:)];
    //动画显示
    CGFloat height = image.size.height * view.frame.size.width / image.size.width;
    CGRect rect = CGRectMake(0, (view.frame.size.height - height) / 2, view.frame.size.width, height);
    [UIView animateWithDuration:0.5f animations:^{
        img.frame = rect;
    }];
}

- (void)noZoneAction:(UIGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5f animations:^{
        CGRect rect = CGRectZero;
        rect.origin.x = sender.view.frame.size.width / 2;
        rect.origin.y = sender.view.frame.size.height / 2;
        [sender.view viewWithTag:1999].frame = rect;
    } completion:^(BOOL finished) {
        [sender.view removeFromSuperview];
    }];
}

#pragma mark - Private

+ (void)resetNumberOfSelections
{
    numberOfSelectedGridItems = 0;
}

+ (NSUInteger)numberOfSelections
{
    return numberOfSelectedGridItems;
}

@end
