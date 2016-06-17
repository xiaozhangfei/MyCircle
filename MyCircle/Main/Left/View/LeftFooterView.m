//
//  LeftFooterView.m
//  MyCircle
//
//  Created by and on 15/12/30.
//  Copyright © 2015年 and. All rights reserved.
//

#import "LeftFooterView.h"
#import <Masonry.h>
#import "AppMacro.h"

#import "AFHTTPRequestOperationManager+URLData.h"
#import "XFAPI.h"
#import "UtilsMacro.h"

@implementation LeftFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
//    UIView *setView = [[UIView alloc] init];
//    [self addSubview:setView];
//    
//    _setImg = [[UIImageView alloc] init];
//    _setImg.image = [UIImage imageNamed:@"MoreSetting"];
//    [setView addSubview:_setImg];
//    
//    _setLabel = [[UILabel alloc] init];
//    _setLabel.text = @"设置";
//    [setView addSubview:_setLabel];
//    
//    _setView = setView;
//
//    UIView *nightView = [[UIView alloc] init];
//    [self addSubview:nightView];
//    
//    _nightImg = [[UIImageView alloc] init];
//    _nightImg.image = [UIImage imageNamed:@"tabbar_discover"];
//    [nightView addSubview:_nightImg];
//    
//    _nightLabel = [[UILabel alloc] init];
//    _nightLabel.text = @"夜间";
//    [nightView addSubview:_nightLabel];
//    
//    
//    _nightView = nightView;
    
    BtnExt *setBtn = [[BtnExt alloc] init];
    [setBtn setImage:[UIImage imageNamed:@"MoreSetting"] forState:(UIControlStateNormal)];
    [setBtn setTitle:NSLocalizedString(@"set_setting", @"set_") forState:(UIControlStateNormal)];
    setBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [setBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [setBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    setBtn.btnType = XFBtnTypeLeft;
    setBtn.imageSize = CGSizeMake(SCREEN_ORIGINWIDTH_5(50), SCREEN_ORIGINWIDTH_5(50));
    setBtn.imageToBorderOffset = SCREEN_ORIGINWIDTH_5(0);
    [self addSubview:setBtn];
    _setView = setBtn;
    
    BtnExt *nightBtn = [[BtnExt alloc] init];
    [nightBtn setImage:[UIImage imageNamed:@"tabbar_discover"] forState:(UIControlStateNormal)];
    [nightBtn setTitle:NSLocalizedString(@"set_night", @"set_") forState:(UIControlStateNormal)];
    nightBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [nightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [nightBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateHighlighted)];
    nightBtn.btnType = XFBtnTypeLeft;
    nightBtn.imageSize = CGSizeMake(SCREEN_ORIGINWIDTH_5(50), SCREEN_ORIGINWIDTH_5(50));
    nightBtn.imageToBorderOffset = SCREEN_ORIGINWIDTH_5(10);
    [self addSubview:nightBtn];
    _nightView = nightBtn;
    
    UIView *weatherView = [[UIView alloc] init];
    [self addSubview:weatherView];
    
    _degreeLabel = [[UILabel alloc] init];
    _degreeLabel.textAlignment = NSTextAlignmentRight;
    [weatherView addSubview:_degreeLabel];
    
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.textAlignment = NSTextAlignmentRight;
    [weatherView addSubview:_locationLabel];
    
    _weatherView = weatherView;
    _degreeLabel.textColor = [UIColor whiteColor];
    _degreeLabel.font = [UIFont systemFontOfSize:13.0f];
    _locationLabel.textColor = [UIColor whiteColor];
    _locationLabel.font = [UIFont systemFontOfSize:13.0f];
    //_degreeLabel.text = @"4º";
    //_locationLabel.text = @"北京";
    
    
    __weak typeof (self) weakSelf = self;
    //左侧
    CGFloat blockWidth = SCREEN_ORIGINWIDTH_5(130);
    CGFloat blank = (self.frame.size.width - 3 * blockWidth - SCREEN_ORIGINWIDTH_5(40)) / 2;
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (weakSelf.mas_left).offset (SCREEN_ORIGINWIDTH_5(0));
        make.bottom.equalTo (weakSelf.mas_bottom).offset (SCREEN_ORIGINWIDTH_5(-10));
        make.height.offset (SCREEN_ORIGINWIDTH_5(50));
        make.width.offset (blockWidth);
    }];
    //中间
    [nightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (setBtn.mas_right).offset (blank);
        make.top.equalTo (setBtn.mas_top);
        make.height.equalTo (setBtn.mas_height);
        make.width.offset (blockWidth);
    }];
    //右侧
    [weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (nightBtn.mas_right).offset (blank);
        make.top.equalTo (nightBtn.mas_top).offset (SCREEN_ORIGINWIDTH_5(-40));
        make.right.equalTo (weakSelf.mas_right).offset (SCREEN_ORIGINWIDTH_5(-10));
        make.bottom.equalTo (nightBtn.mas_bottom);
    }];
    [_degreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weatherView.mas_left);
        make.top.equalTo (weatherView.mas_top);
        make.height.offset (SCREEN_ORIGINWIDTH_5(40));
        make.width.equalTo (weatherView.mas_width);
    }];
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weatherView.mas_left);
        make.top.equalTo (weakSelf.degreeLabel.mas_bottom);
        make.right.equalTo (weatherView.mas_right);
        make.bottom.equalTo (weatherView.mas_bottom);
    }];
 
    //[self locationAction];
}
#pragma mark -
#pragma mark --
#pragma mark -- 定位
- (void)locationAction {
    NSLog(@"开始定位");
    self.locationLabel.text = @"定位中...";
    
    //定位管理器
    _locationManager = [[CLLocationManager alloc]init];
    _geocoder = [[CLGeocoder alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
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
    self.locationLabel.text = @"定位失败";
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
    //self.labelLocation.text = [NSString stringWithFormat:@"%@，%@，%@，%@",placemark.country, placemark.locality, placemark.thoroughfare, placemark.subThoroughfare];
    NSString *city = placemark.locality;
    NSString *sub = [city substringWithRange:NSMakeRange(city.length - 1, 1)];
    if ([sub isEqualToString:@"省"] || [sub isEqualToString:@"市"] || [sub isEqualToString:@"县"]) {
        city = [city substringWithRange:NSMakeRange(0, city.length - 1)];
    }
    self.locationLabel.text = city;
    NSLog(@"定位 %@",city);
    [self refreshWeather];
}

#pragma mark -- 获取天气
- (void)refreshWeather {
    //    //重新定位
    //    [_leftFooterView locationAction];
    //    if (ISEMPTY(_leftFooterView.locationLabel.text)) {
    //        [self showToast:@"定位失败"];
    //        return;
    //    }
    NSString *key = @"e86a8b44382709a32ebee5a785e92d9b";
    if (ISEMPTY(self.locationLabel.text)) {
        return;
    }
    NSString *city = self.locationLabel.text;
    __weak typeof (self) weakSelf = self;
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    // 设置请求头
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    AFJSONRequestSerializer *serializer = [[AFJSONRequestSerializer alloc] init];
    [serializer setValue:key forHTTPHeaderField:@"apikey"];
    manager.requestSerializer = serializer;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"http://apis.baidu.com/heweather/weather/free"] parameters:@{@"city":city} success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSData *JSONData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *di = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        [weakSelf getWeatherReponse:di];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}

- (void)getWeatherReponse:(id)response {
    NSLog(@"weather = %@",response);
    NSString *flag = @"";
    //判断是否存在
    for (NSString *key in [response allKeys]) {
        NSString *str = [key substringWithRange:NSMakeRange(0, 9)];
        if ([str isEqualToString:@"HeWeather"]) {
            flag = key;
        }
    }
    if ([flag isEqualToString:@""]) {
        //[self showToast:@"获取天气失败"];
        return;
    }
    NSDictionary *dict = response[flag][0];
    if (![dict[@"status"] isEqualToString:@"ok"]) {
        //[self showToast:dict[@"status"]];
        NSLog(@"天气获取 %@",dict[@"status"]);
        return;
    }
    //实况天气
    NSDictionary *now = dict[@"now"];
    self.degreeLabel.text = [NSString stringWithFormat:@"%@º",now[@"tmp"]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
