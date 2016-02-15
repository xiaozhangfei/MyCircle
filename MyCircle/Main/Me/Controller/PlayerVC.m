//
//  PlayerVC.m
//  MyCircle
//
//  Created by and on 15/12/15.
//  Copyright © 2015年 and. All rights reserved.
//

#import "PlayerVC.h"
#import "PlayerView.h"
#import "UIView+Ext.h"

#import "XFAPI.h"
@interface PlayerVC ()

@property (strong, nonatomic) PlayerView *pv;
@property (assign, nonatomic) BOOL isZone;

@property (copy, nonatomic) NSString *videoUrl;
@end

@implementation PlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置对应的导航条的返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_black"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftBarButtonAction:)];
    
    _videoUrl = [XFAPI video_url:@"circle/7fcfb61fb9b6525ba46de8d36460decb.mov"];
    
    CGRect rect=   [UIScreen mainScreen].bounds;

    _pv = [[PlayerView alloc] initWithFrame:CGRectMake(10, 100, rect.size.width - 20, 300)];
    [self.view addSubview:_pv];
    _isZone = NO;
    [_pv.zoneImageButton addTapCallBack:self sel:@selector(zoneAction:)];
    [_pv addTapCallBack:self sel:@selector(pvAction:)];
}

- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pvAction:(UIGestureRecognizer *)sender {
    NSLog(@"pv --");
}

- (void)zoneAction:(UIGestureRecognizer *)sender {
    //UIWindow *window = [UIApplication sharedApplication].keyWindow;
    NSLog(@"zone");
    if (_isZone) {
        _pv.transform = CGAffineTransformMakeRotation(0 * M_PI / 180);//旋转回到正常状态
        _isZone = NO;
    }else {

        CGRect r = self.view.frame;
        _isZone = YES;
        
        __weak typeof (self) weakSelf = self;
        _pv.transform = CGAffineTransformScale(_pv.transform, 2, 2);
        _pv.transform = CGAffineTransformRotate (_pv.transform, M_PI / 2);
        
        CGRect re = _pv.frame;
        [UIView animateWithDuration:2.0f animations:^{
            //weakSelf.pv.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
            weakSelf.pv.transform = CGAffineTransformRotate (_pv.transform, M_PI_4);

            weakSelf.pv.transform = CGAffineTransformScale(_pv.transform, r.size.width / re.size.width, r.size.height / re.size.height);
        } completion:^(BOOL finished) {
            
//            [UIView animateWithDuration:2.0f animations:^{
//                weakSelf.pv.frame = CGRectMake(0, 0, r.size.height, r.size.width);
//                //weakSelf.pv.center = weakSelf.view.center;
//
//            } completion:^(BOOL finished) {
//                weakSelf.pv.frame = CGRectMake(0, 0, r.size.height, r.size.width);
//            }];
        }];
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
