//
//  WriteView.m
//  MyCircle
//
//  Created by and on 15/12/11.
//  Copyright © 2015年 and. All rights reserved.
//

#import "WriteView.h"
#import <Masonry.h>
#import "AppMacro.h"
//定位
#import <CoreLocation/CoreLocation.h>
#import "UIView+Ext.h"


@interface WriteView () <CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;//定位
    CLGeocoder *_geocoder;//位置编码
}
@end

@implementation WriteView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    

    _textFieldTitle = [[UITextField alloc] initWithFrame:CGRectZero];
    [self addSubview:_textFieldTitle];
    
    _textViewIntro = [[UITextView alloc] initWithFrame:CGRectZero];
    [self addSubview:_textViewIntro];
    
    _imageLocation = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageLocation.image = [UIImage imageNamed:@"sight_icon_location_selected"];
    [self addSubview:_imageLocation];
    _labelLocation = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_labelLocation];
    
    for (int i = 0; i < 5; i ++) {
        UIImageView *imagePic = [[UIImageView alloc] initWithFrame:CGRectZero];
        imagePic.image = [UIImage imageNamed:@"cancel"];
        imagePic.tag = 300 + i;
        [self addSubview:imagePic];
        if (i != 0) {
            imagePic.hidden = YES;
        }
        UIImageView *deImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        deImg.image = [UIImage imageNamed:@"delete"];
        deImg.tag = 320 + i;
        if (i == 0) {
            deImg.hidden = YES;
        }
        [imagePic addSubview:deImg];
        
        [deImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo (imagePic.mas_right).with.offset (SCREEN_CURRETWIDTH(10));
            make.top.equalTo (imagePic.mas_top).with.offset (SCREEN_CURRETWIDTH(-10));
            make.width.offset (SCREEN_CURRETWIDTH(50));
            make.height.offset (SCREEN_CURRETWIDTH(50));
        }];
    }

    
    _videoPic = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_videoPic];
    
    _textFieldTitle.placeholder = @"标题";
    _textFieldTitle.backgroundColor = [UIColor whiteColor];
    _textViewIntro.text = @"简介";
    _textViewIntro.backgroundColor = [UIColor whiteColor];
    //_labelLocation.text = @"北京";
    _videoPic.image = [UIImage imageNamed:@"find"];
    
    [_labelLocation addTapCallBack:self sel:@selector(locationAction)];
    
    __weak typeof (self) weakSelf = self;
    [_textFieldTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.mas_top).with.offset (SCREEN_CURRETWIDTH(20));
        make.left.equalTo (weakSelf.mas_left).with.offset (SCREEN_CURRETWIDTH(20));
        make.right.equalTo (weakSelf.mas_right).with.offset (SCREEN_CURRETWIDTH(-20));
        make.height.offset (SCREEN_CURRETWIDTH(50));
    }];

    [_textViewIntro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.textFieldTitle.mas_bottom).with.offset (SCREEN_CURRETWIDTH(20));
        make.left.equalTo (weakSelf.textFieldTitle.mas_left).with.offset (0);
        make.right.equalTo (weakSelf.textFieldTitle.mas_right).with.offset (0);
        make.height.offset (SCREEN_CURRETWIDTH(100));
    }];
    
    [_imageLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.textViewIntro.mas_bottom).with.offset (SCREEN_CURRETWIDTH(20));
        make.left.equalTo (weakSelf.textViewIntro.mas_left).with.offset (0);
        make.height.offset (SCREEN_CURRETWIDTH(50));
        make.width.offset (SCREEN_CURRETWIDTH(50));
    }];
    
    [_labelLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.textViewIntro.mas_bottom).with.offset (SCREEN_CURRETWIDTH(20));
        make.left.equalTo (weakSelf.imageLocation.mas_right).with.offset (SCREEN_CURRETWIDTH(10));
        make.right.equalTo (weakSelf.textViewIntro.mas_right).with.offset (0);
        make.height.offset (SCREEN_CURRETWIDTH(50));
    }];
    
    UIImageView *imv = [self viewWithTag:300];
    [imv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (weakSelf.labelLocation.mas_bottom).with.offset (SCREEN_CURRETWIDTH(20));
        make.left.equalTo (weakSelf.imageLocation.mas_left).with.offset (0);
        make.width.offset (SCREEN_CURRETWIDTH(120));
        make.height.offset (SCREEN_CURRETWIDTH(120));
    }];
    CGFloat offset = SCREEN_CURRETWIDTH(20);
    for (int i = 1; i < 5; i ++) {
        UIImageView *img = [self viewWithTag:300 + i];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (imv.mas_top);
            make.left.equalTo (imv.mas_right).with.offset (offset);
            make.width.equalTo (imv.mas_width);
            make.height.equalTo (imv.mas_height);
        }];
        offset += (SCREEN_CURRETWIDTH(140));
    }
    
    [_videoPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (imv.mas_bottom).with.offset (SCREEN_CURRETWIDTH(20));
        make.left.equalTo (imv.mas_left);
        make.right.equalTo (imv.mas_right);
        make.height.equalTo (imv.mas_height);
    }];
 
}

#pragma mark -- 定位
- (void)locationAction {
    NSLog(@"开始定位");
    self.labelLocation.text = @"正在定位中...";
    
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    _geocoder=[[CLGeocoder alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate = self;
        //设置定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    
}
#pragma mark -- location delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败 error = %@",error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"%ld", [locations count]);
    
    CLLocation *oldLocation = locations[0];
    CLLocationCoordinate2D oldCoordinate = oldLocation.coordinate;
    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    
    //    CLLocation *newLocation = locations[1];
    //    CLLocationCoordinate2D newCoordinate = newLocation.coordinate;
    //    NSLog(@"经度：%f,纬度：%f",newCoordinate.longitude,newCoordinate.latitude);
    //
    //    //计算两个坐标距离
    //    float distance = [newLocation distanceFromLocation:oldLocation];
    //    NSLog(@"%f",distance);
    
    [manager stopUpdatingLocation];//停止定位
    [self getAddressByLatitude:oldCoordinate.latitude longitude:oldCoordinate.longitude];
    
}

#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark = [placemarks firstObject];
        
        CLLocation *location = placemark.location;//位置
        CLRegion *region = placemark.region;//区域
        NSDictionary *addressDic = placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        //        NSString *name = placemark.name;//地名
        //        NSString *thoroughfare = placemark.thoroughfare;//街道
        //        NSString *subThoroughfare = placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality = placemark.locality; // 城市
        //        NSString *subLocality = placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea = placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea = placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode = placemark.postalCode; //邮编
        //        NSString *ISOcountryCode = placemark.ISOcountryCode; //国家编码
        //        NSString *country = placemark.country; //国家
        //        NSString *inlandWater = placemark.inlandWater; //水源、湖泊
        //        NSString *ocean = placemark.ocean; // 海洋
        //        NSArray *areasOfInterest = placemark.areasOfInterest; //关联的或利益相关的地标
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
    }];
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    __weak typeof (self) weakSelf = self;
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSLog(@"详细信息:%@", placemark.addressDictionary);
        [weakSelf setDataWithLocation:placemark];
    }];
}

- (void)setDataWithLocation:(CLPlacemark *)placemark {
    self.labelLocation.text = [NSString stringWithFormat:@"%@%@", placemark.locality, placemark.thoroughfare];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
