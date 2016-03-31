//
//  LaunchVC.m
//  MyCircle
//
//  Created by and on 15/12/18.
//  Copyright © 2015年 and. All rights reserved.
//

#import "LaunchVC.h"
#import <UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "AdVC.h"
#import "AdModel.h"

@interface LaunchVC ()
{
    NSTimer *_timer;
}
@property (strong, nonatomic) UIImageView *bottomImv;

@property (strong, nonatomic) UIImageView *adImv;

@property (strong, nonatomic) UILabel *labelShake;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (assign, nonatomic) NSInteger nIndex;

@end

@implementation LaunchVC

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_timer) {
        [_timer invalidate];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
    _dataArray = [NSMutableArray array];
    [self initData];
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    
    //5s内如果数据请求不到，则跳过
    //if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    //}
}

- (void)initView {
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = HexColor(0xECECEC);
    
    _bottomImv = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_CURRETWIDTH(0), self.view.frame.size.height - 150, self.view.frame.size.width - SCREEN_CURRETWIDTH(0), 150)];
    _bottomImv.image = [UIImage imageNamed:@"LaunchImage"];
    [self.view addSubview:_bottomImv];

    _adImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - _bottomImv.frame.size.height)];
    [self.view addSubview:_adImv];
    [_adImv addTapCallBack:self sel:@selector(adImvAction:)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, self.view.frame.size.height - 100, 60, 35)];
    label.text = NSLocalizedString(@"ad_skip", @"ad_");
    label.textColor = HexColor(0x787878);
    label.layer.borderColor = [HexColor(0x787878) CGColor];
    label.layer.borderWidth = 1;
    label.layer.cornerRadius = 17.5;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label addTapCallBack:self sel:@selector(hideAction:)];
    
    _labelShake = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 70, self.view.frame.size.height - 190, 140, 30)];
    _labelShake.text = NSLocalizedString(@"ad_shake", @"ad_");
    _labelShake.textAlignment = NSTextAlignmentCenter;
    _labelShake.textColor = HexColor(0xF7E4B4);
    _labelShake.hidden = YES;
    [self.view addSubview:_labelShake];
    _labelShake.textColor = HexColor(0xF7E4B4);
    _labelShake.layer.borderColor = [HexColor(0xF7E4B4) CGColor];
    _labelShake.layer.borderWidth = 1;
    _labelShake.layer.cornerRadius = 15;
    [_labelShake addTapCallBack:self sel:@selector(shakeAction:)];
}

- (void)initData {
    __weak typeof (self) weakSelf = self;
    [AFHTTPRequestOperationManager getWithURLString:[XFAPI getAdContent] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict, BaseModel *baseModel){
        if (![baseModel.code isEqual:@"200"]) {
            [weakSelf showToast:@"网络错误"];
            return ;
        }
        [weakSelf adInfoHandle:(NSArray *)responseDict];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, BaseModel *baseModel) {
        NSLog(@"请求失败 error = %@", error);
    }];
}

- (void)adInfoHandle:(NSArray *)response {
    for (NSDictionary *dict in response) {
        AdModel *ad = [[AdModel alloc] init];
        [ad setValuesForKeysWithDictionary:dict];
        [_dataArray addObject:ad];
    }
    
    if (_dataArray.count == 0) {
        [self hideAction:nil];
        return;
    }
    self.labelShake.hidden = NO;
    
    _nIndex = arc4random() % _dataArray.count;
    
    [self setADInfoWithAdModel:_dataArray[_nIndex]];

}

- (void)setADInfoWithAdModel:(AdModel *)adModel {
    [_adImv sd_setImageWithURL:[NSURL URLWithString:[XFAPI image_url:adModel.pic]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
    }];
    //开启计时器
    [self createTimer];
}

- (void)adImvAction:(UIGestureRecognizer *)sender {
    NSLog(@"ad..");
    
    AdVC *ad = [[AdVC alloc] init];
    [self.navigationController pushViewController:ad animated:YES];
}

- (void)hideAction:(UIGestureRecognizer *)sender {
    NSLog(@"--跳过本页面");
    [((AppDelegate *)[UIApplication sharedApplication].delegate) setWindowRootVC];
}

- (void)delayMethod {
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf hideAction:nil];
    });
}


#pragma mark - 摇一摇相关方法
// 摇一摇开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    return;
}

// 摇一摇取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    return;
}

// 摇一摇摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
        [self shakeAction:nil];
    }
    return;
}

- (void)shakeAction:(UIGestureRecognizer *)sender {
    NSLog(@"摇动结束");
    
    NSInteger n = _nIndex;
    while (n == _nIndex) {
        n = arc4random() % _dataArray.count;
        NSLog(@"--n = %ld", n);
    }
    _nIndex = n;
    [self setADInfoWithAdModel:_dataArray[_nIndex]];
}

- (void)createTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    }
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
    }
}

- (void)dealloc {
    if (_timer) {
        [self stopTimer];
        _timer = nil;
    }
    _dataArray = nil;
    _labelShake = nil;
    _adImv = nil;
    _bottomImv = nil;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
